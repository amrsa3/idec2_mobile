// ignore_for_file: avoid_web_libraries_in_flutter

/// Web implementation for web utilities
/// Uses dart:html for web-specific functionality

import 'dart:html' as html;

/// Clear browser storage
void clearBrowserStorage() {
  try {
    html.window.localStorage.clear();
    html.window.sessionStorage.clear();
  } catch (e) {
    // Ignore errors
  }
}

/// Reload browser page
void reloadBrowserPage() {
  try {
    html.window.location.reload();
  } catch (e) {
    // Ignore errors
  }
}

/// Check if running on web platform
bool get isWebPlatform => true;

/// Get browser user agent
String getBrowserUserAgent() {
  try {
    return html.window.navigator.userAgent;
  } catch (e) {
    return '';
  }
}

/// Clear specific storage key
void clearStorageKey(String key) {
  try {
    html.window.localStorage.remove(key);
    html.window.sessionStorage.remove(key);
  } catch (e) {
    // Ignore errors
  }
}

/// Get storage value from localStorage
String? getLocalStorageValue(String key) {
  try {
    return html.window.localStorage[key];
  } catch (e) {
    return null;
  }
}

/// Set storage value to localStorage
void setLocalStorageValue(String key, String value) {
  try {
    html.window.localStorage[key] = value;
  } catch (e) {
    // Ignore errors
  }
}

/// Remove storage value from localStorage
void removeLocalStorageValue(String key) {
  try {
    html.window.localStorage.remove(key);
  } catch (e) {
    // Ignore errors
  }
}

/// Get storage value from sessionStorage
String? getSessionStorageValue(String key) {
  try {
    return html.window.sessionStorage[key];
  } catch (e) {
    return null;
  }
}

/// Set storage value to sessionStorage
void setSessionStorageValue(String key, String value) {
  try {
    html.window.sessionStorage[key] = value;
  } catch (e) {
    // Ignore errors
  }
}

/// Remove storage value from sessionStorage
void removeSessionStorageValue(String key) {
  try {
    html.window.sessionStorage.remove(key);
  } catch (e) {
    // Ignore errors
  }
}

/// Clear all localStorage
void clearLocalStorage() {
  try {
    html.window.localStorage.clear();
  } catch (e) {
    // Ignore errors
  }
}

/// Clear all sessionStorage
void clearSessionStorage() {
  try {
    html.window.sessionStorage.clear();
  } catch (e) {
    // Ignore errors
  }
}

/// Get all localStorage keys
List<String> getLocalStorageKeys() {
  try {
    return html.window.localStorage.keys.toList();
  } catch (e) {
    return [];
  }
}

/// Iterate over localStorage entries
void forEachLocalStorage(void Function(String key, String value) callback) {
  try {
    html.window.localStorage.forEach((key, value) {
      callback(key, value);
    });
  } catch (e) {
    // Ignore errors
  }
}

/// Iterate over sessionStorage entries
void forEachSessionStorage(void Function(String key, String value) callback) {
  try {
    html.window.sessionStorage.forEach((key, value) {
      callback(key, value);
    });
  } catch (e) {
    // Ignore errors
  }
}
