import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/enhanced_dio_service_v2.dart';

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(EnhancedDioServiceV2.instance.dio);
});

// Dio Service Provider
