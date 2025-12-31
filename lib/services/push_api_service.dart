import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/push/push_models.dart';
import 'enhanced_dio_service_v2.dart';

enum FcmPlatformType {
  android,
  ios,
  web,
  other;

  String get serverValue {
    switch (this) {
      case FcmPlatformType.android:
        return 'ANDROID';
      case FcmPlatformType.ios:
        return 'IOS';
      case FcmPlatformType.web:
        return 'WEB';
      case FcmPlatformType.other:
        return 'OTHER';
    }
  }

  static FcmPlatformType currentPlatform() {
    if (kIsWeb) {
      return FcmPlatformType.web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FcmPlatformType.android;
      case TargetPlatform.iOS:
        return FcmPlatformType.ios;
      default:
        return FcmPlatformType.other;
    }
  }
}

class PushApiService {
  PushApiService._internal()
      : _dio = EnhancedDioServiceV2.instance.dio,
        _basePath = '/api/v1/notifications/device-tokens';

  static final PushApiService instance = PushApiService._internal();

  final Dio _dio;
  final String _basePath;

  Future<DeviceTokenTopicsResponse> getAvailableTopics() async {
    final response = await _dio.get<Map<String, dynamic>>('$_basePath/topics');
    final data = response.data?['data'] ?? response.data ?? <String, dynamic>{};
    return DeviceTokenTopicsResponse.fromJson(Map<String, dynamic>.from(data));
  }

  Future<List<DeviceTokenRecord>> listDeviceTokens() async {
    final response = await _dio.get<dynamic>(_basePath);
    final data = response.data;
    final Iterable<dynamic> items;

    if (data is Map && data['data'] is List) {
      items = data['data'] as List;
    } else if (data is List) {
      items = data;
    } else {
      items = const [];
    }

    return items
        .map(
          (item) => DeviceTokenRecord.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<DeviceTokenRecord?> getDeviceToken(String token) async {
    final response = await _dio.get<dynamic>('$_basePath/$token');
    final data = response.data;
    final payload = data is Map && data['data'] is Map ? data['data'] : data;
    if (payload is Map) {
      return DeviceTokenRecord.fromJson(Map<String, dynamic>.from(payload));
    }
    return null;
  }

  Future<void> registerToken({
    required String token,
    required FcmPlatformType platform,
    Map<String, dynamic>? deviceInfo,
    List<String>? topics,
  }) async {
    await _dio.post(
      _basePath,
      data: {
        'token': token,
        'platform': platform.serverValue,
        if (deviceInfo != null) 'deviceInfo': deviceInfo,
        if (topics != null && topics.isNotEmpty) 'topics': topics,
      },
    );
  }

  Future<void> unregisterToken(String token) async {
    await _dio.delete('$_basePath/$token');
  }

  Future<void> subscribeTopics({
    required String token,
    required List<String> topics,
  }) async {
    if (topics.isEmpty) return;
    await _dio.post(
      '$_basePath/topics',
      data: {
        'token': token,
        'topics': topics,
        'action': 'subscribe',
      },
    );
  }

  Future<void> unsubscribeTopics({
    required String token,
    required List<String> topics,
  }) async {
    if (topics.isEmpty) return;
    await _dio.post(
      '$_basePath/topics',
      data: {
        'token': token,
        'topics': topics,
        'action': 'unsubscribe',
      },
    );
  }
}
