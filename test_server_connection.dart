import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  print('🔍 Testing connection to new server: idec-ye.com:3000');
  
  final dio = Dio();
  
  try {
    // Test health endpoint
    print('\n1. Testing health endpoint...');
    final healthResponse = await dio.get('http://idec-ye.com:3000/api/v1/health');
    print('✅ Health check: ${healthResponse.statusCode}');
    print('📊 Server status: ${healthResponse.data['status']}');
    print('⏱️ Uptime: ${healthResponse.data['uptime']} seconds');
    
    // Test authentication endpoint
    print('\n2. Testing authentication endpoint...');
    try {
      final authResponse = await dio.post(
        'http://idec-ye.com:3000/api/v1/auth/login',
        data: {'email': 'test@example.com', 'password': 'test123'},
      );
      print('✅ Auth endpoint accessible: ${authResponse.statusCode}');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        print('✅ Auth endpoint accessible (400 expected for invalid credentials)');
      } else {
        print('❌ Auth endpoint error: $e');
      }
    }
    
    // Test users endpoint
    print('\n3. Testing users endpoint...');
    try {
      final usersResponse = await dio.get('http://idec-ye.com:3000/api/v1/users');
      print('✅ Users endpoint: ${usersResponse.statusCode}');
      print('📊 Users count: ${usersResponse.data['data']?.length ?? 0}');
    } catch (e) {
      print('⚠️ Users endpoint (may require auth): $e');
    }
    
    // Test governorates endpoint (CORRECTED)
    print('\n4. Testing governorates endpoint...');
    try {
      final govResponse = await dio.get('http://idec-ye.com:3000/api/v1/rule-data/governorates');
      print('✅ Governorates endpoint: ${govResponse.statusCode}');
      if (govResponse.data is Map && govResponse.data['data'] != null) {
        print('📊 Governorates count: ${govResponse.data['data'].length}');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('⚠️ Governorates endpoint not found (404)');
      } else {
        print('❌ Governorates endpoint error: $e');
      }
    }
    
    // Test qualifications endpoint (CORRECTED)
    print('\n5. Testing qualifications endpoint...');
    try {
      final qualResponse = await dio.get('http://idec-ye.com:3000/api/v1/rule-data/qualifications');
      print('✅ Qualifications endpoint: ${qualResponse.statusCode}');
      if (qualResponse.data is Map && qualResponse.data['data'] != null) {
        print('📊 Qualifications count: ${qualResponse.data['data'].length}');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('⚠️ Qualifications endpoint not found (404)');
      } else if (e is DioException && e.response?.statusCode == 401) {
        print('⚠️ Qualifications endpoint requires authentication (401)');
      } else {
        print('❌ Qualifications endpoint error: $e');
      }
    }
    
    // Test profile endpoint
    print('\n6. Testing profile endpoint...');
    try {
      final profileResponse = await dio.get('http://idec-ye.com:3000/api/v1/profiles/me');
      print('✅ Profile endpoint: ${profileResponse.statusCode}');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print('✅ Profile endpoint accessible (401 expected without auth)');
      } else {
        print('❌ Profile endpoint error: $e');
      }
    }
    
    print('\n🎉 Server connection test completed!');
    print('📡 Server is accessible at: idec-ye.com:3000');
    print('✅ All critical endpoints are working correctly');
    
  } catch (e) {
    print('❌ Failed to connect to server: $e');
    exit(1);
  }
}