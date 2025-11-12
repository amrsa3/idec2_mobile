// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

Future<html.ServiceWorkerRegistration?> ensureFirebaseMessagingServiceWorker({
  Duration timeout = const Duration(seconds: 15),
}) async {
  try {
    final serviceWorkerContainer = html.window.navigator.serviceWorker;
    if (serviceWorkerContainer == null) {
      html.window.console.warn(
        '⚠️ [FCM] Service workers are not supported in this browser context.',
      );
      return null;
    }

    final scriptUrl = Uri.base.resolve('firebase-messaging-sw.js').toString();

    try {
      final response = await html.HttpRequest.request(
        scriptUrl,
        method: 'GET',
      );
      html.window.console.log(
          'ℹ️ [FCM] Service worker script fetch status: ${response.status}');
    } catch (fetchError) {
      html.window.console.error(
        '❌ [FCM] Failed to fetch service worker script: $fetchError',
      );
    }

    final existingRegistration =
        await _findRegistration(serviceWorkerContainer, scriptUrl);
    if (existingRegistration != null) {
      return existingRegistration;
    }

    html.window.console.log(
        'ℹ️ [FCM] Registering firebase-messaging service worker… ($scriptUrl)');
    await serviceWorkerContainer.register(scriptUrl);

    return await _waitForReady(serviceWorkerContainer, timeout);
  } catch (error) {
    html.window.console.error(
      '❌ [FCM] Unable to register firebase-messaging service worker: $error',
    );
    return null;
  }
}

Future<html.ServiceWorkerRegistration?> waitForServiceWorkerRegistration({
  Duration timeout = const Duration(seconds: 15),
}) =>
    _waitForReady(html.window.navigator.serviceWorker, timeout);

Future<html.ServiceWorkerRegistration?> _waitForReady(
  html.ServiceWorkerContainer? container,
  Duration timeout,
) async {
  if (container == null) {
    return null;
  }

  try {
    return await container.ready.timeout(timeout);
  } on TimeoutException {
    html.window.console.error(
      '❌ [FCM] Service worker ready timeout after ${timeout.inSeconds}s',
    );
    return null;
  } catch (error) {
    html.window.console
        .error('❌ [FCM] Failed while waiting for SW readiness: $error');
    return null;
  }
}

Future<html.ServiceWorkerRegistration?> _findRegistration(
  html.ServiceWorkerContainer container,
  String scriptUrl,
) async {
  try {
    final all = await container.getRegistrations();
    for (final registration in all) {
      final installing = registration.installing;
      final waiting = registration.waiting;
      final active = registration.active;

      if (installing?.scriptURL == scriptUrl ||
          waiting?.scriptURL == scriptUrl ||
          active?.scriptURL == scriptUrl) {
        return registration;
      }
    }

    return null;
  } catch (error) {
    html.window.console
        .warn('⚠️ [FCM] Unable to list service worker registrations: $error');
    return null;
  }
}
