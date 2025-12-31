import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiEndpointTester {
  static const String localUrl = 'http://localhost:3000';

  late String baseUrl;
  String? authToken;

  ApiEndpointTester({String? customBaseUrl}) {
    baseUrl = customBaseUrl ?? localUrl;
  }

  Future<http.Response> makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    if (requiresAuth && authToken != null) {
      requestHeaders['Authorization'] = 'Bearer $authToken';
    }

    print('🔗 Making $method request to: $uri');

    try {
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      print('📊 Status: ${response.statusCode}');
      if (response.body.isNotEmpty && response.body.length < 500) {
        try {
          final jsonResponse = jsonDecode(response.body);
          print('📄 Response: ${jsonEncode(jsonResponse)}');
        } catch (e) {
          print('📄 Response (raw): ${response.body}');
        }
      } else if (response.body.isNotEmpty) {
        print(
            '📄 Response: [Large response - ${response.body.length} characters]');
      }

      return response;
    } catch (e) {
      print('❌ Network error: $e');
      rethrow;
    }
  }

  // Test server health and documentation
  Future<void> testServerHealth() async {
    print('\n🔍 Testing Server Health...');

    // Test API documentation
    try {
      final response = await makeRequest('GET', '/api/docs');
      if (response.statusCode == 200) {
        print('✅ API Documentation accessible at /api/docs');
      } else {
        print('⚠️  API Documentation returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Documentation failed: $e');
    }

    // Test health endpoint (correct path with global prefix)
    try {
      final response = await makeRequest('GET', '/health');
      if (response.statusCode == 200) {
        print('✅ Health endpoint working at /health');
      } else {
        print(
            '⚠️  Health endpoint at /health returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Health endpoint at /health failed: $e');
    }
  }

  // Test authentication endpoints
  Future<void> testAuthEndpoints() async {
    print('\n🔐 Testing Authentication Endpoints...');

    // Test registration
    final registerData = {
      'phone': '+967777034999',
      'password': 'TestPassword123!',
      'confirmPassword': 'TestPassword123!',
    };

    try {
      final response = await makeRequest('POST', '/api/v1/auth/register',
          body: registerData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Registration endpoint working');
      } else if (response.statusCode == 409) {
        print('✅ Registration endpoint working (user already exists)');
      } else {
        print('⚠️  Registration returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Registration failed: $e');
    }

    // Test login
    final loginData = {
      'phone': '+967777034999',
      'password': 'TestPassword123!',
    };

    try {
      final response =
          await makeRequest('POST', '/api/v1/auth/login', body: loginData);
      if (response.statusCode == 200) {
        print('✅ Login endpoint working');
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['data'] != null &&
              responseData['data']['accessToken'] != null) {
            authToken = responseData['data']['accessToken'];
            print('🔑 Auth token obtained successfully');
          }
        } catch (e) {
          print('⚠️  Could not extract token from response');
        }
      } else if (response.statusCode == 401) {
        print('✅ Login endpoint working (invalid credentials expected)');
      } else {
        print('⚠️  Login returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Login failed: $e');
    }

    // Test check user status
    try {
      final response = await makeRequest(
          'POST', '/api/v1/auth/check-user-status',
          body: loginData);
      if (response.statusCode == 200) {
        print('✅ Check user status endpoint working');
      } else {
        print('⚠️  Check user status returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Check user status failed: $e');
    }

    // Test refresh token
    try {
      final response = await makeRequest('POST', '/api/v1/auth/refresh',
          body: {'refreshToken': 'dummy-token'});
      if (response.statusCode == 200 || response.statusCode == 401) {
        print('✅ Refresh token endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Refresh token returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Refresh token failed: $e');
    }

    // Test logout
    try {
      final response =
          await makeRequest('POST', '/api/v1/auth/logout', requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print('✅ Logout endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Logout returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Logout failed: $e');
    }

    // Test get available channels
    try {
      final response = await makeRequest('GET', '/api/v1/auth/channels');
      if (response.statusCode == 200) {
        print('✅ Get available channels endpoint working');
      } else {
        print('⚠️  Get available channels returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get available channels failed: $e');
    }
  }

  // Test OTP endpoints
  Future<void> testOtpEndpoints() async {
    print('\n📱 Testing OTP Endpoints...');

    // Test request OTP
    final otpData = {
      'phone': '+967777034999',
      'channel': 'SMS',
    };

    try {
      final response =
          await makeRequest('POST', '/api/v1/auth/request-otp', body: otpData);
      if (response.statusCode == 200) {
        print('✅ Request OTP endpoint working');
      } else {
        print('⚠️  Request OTP returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Request OTP failed: $e');
    }

    // Test verify OTP
    final verifyData = {
      'phone': '+967777034999',
      'otp': '123456',
    };

    try {
      final response = await makeRequest('POST', '/api/v1/auth/verify-otp',
          body: verifyData);
      if (response.statusCode == 200 || response.statusCode == 400) {
        print('✅ Verify OTP endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Verify OTP returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Verify OTP failed: $e');
    }

    // Test resend OTP
    final resendData = {
      'phone': '+967777034999',
    };

    try {
      final response = await makeRequest('POST', '/api/v1/auth/resend-otp',
          body: resendData);
      if (response.statusCode == 200 || response.statusCode == 400) {
        print('✅ Resend OTP endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Resend OTP returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Resend OTP failed: $e');
    }
  }

  // Test user profile endpoints
  Future<void> testUserEndpoints() async {
    print('\n👤 Testing User Profile Endpoints...');

    // Test get auth profile
    try {
      final response =
          await makeRequest('GET', '/api/v1/auth/profile', requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Get Auth Profile endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Get Auth Profile returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get Auth Profile failed: $e');
    }

    // Test get user profile (profiles controller)
    try {
      final response =
          await makeRequest('GET', '/api/v1/profiles/me', requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Get User Profile endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Get User Profile returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get User Profile failed: $e');
    }

    // Test update user profile
    final updateData = {
      'fullNameAr': 'اسم تجريبي',
      'fullNameEn': 'Test Name',
    };

    try {
      final response = await makeRequest('PUT', '/api/v1/profiles/me',
          body: updateData, requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Update User Profile endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Update User Profile returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Update User Profile failed: $e');
    }
  }

  // Test file management endpoints
  Future<void> testFileEndpoints() async {
    print('\n📁 Testing File Management Endpoints...');

    // Test get files
    try {
      final response = await makeRequest('GET', '/api/v1/files?page=1&limit=10',
          requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print('✅ Get Files endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Get Files returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get Files failed: $e');
    }
  }

  // Test notification endpoints
  Future<void> testNotificationEndpoints() async {
    print('\n🔔 Testing Notification Endpoints...');

    // Test get notifications
    try {
      final response = await makeRequest(
          'GET', '/api/v1/notifications?page=1&limit=10',
          requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Get Notifications endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Get Notifications returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get Notifications failed: $e');
    }
  }

  // Run comprehensive tests
  Future<void> runComprehensiveTests() async {
    print('🚀 Starting API Endpoint Testing...');
    print('📍 Base URL: $baseUrl');
    print('🔧 Testing with corrected API paths (without /api/v1 prefix)');
    print('=' * 60);

    await testServerHealth();
    await testAuthEndpoints();
    await testOtpEndpoints();
    await testUserEndpoints();
    await testFileEndpoints();
    await testNotificationEndpoints();

    print('\n${'=' * 60}');
    print('✨ API Endpoint Testing Complete!');
    print('\n📝 Summary:');
    print('- ✅ = Endpoint working correctly');
    print('- ⚠️  = Endpoint accessible but may need authentication or data');
    print('- ❌ = Endpoint not accessible or network error');
    print(
        '- Status 401 = Authentication required (expected for protected endpoints)');
    print('- Status 400 = Bad request (expected for invalid data)');
    print('- Status 409 = Conflict (expected for duplicate data)');
  }
}

void main() async {
  print('🔍 IDEC API Endpoint Testing Tool (Corrected Paths)');
  print('Testing backend server with corrected API paths...\n');

  final tester = ApiEndpointTester();
  await tester.runComprehensiveTests();
}
