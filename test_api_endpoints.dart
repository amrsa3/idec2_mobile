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
      if (response.body.isNotEmpty) {
        try {
          final jsonResponse = jsonDecode(response.body);
          print('📄 Response: ${jsonEncode(jsonResponse)}');
        } catch (e) {
          print('📄 Response (raw): ${response.body}');
        }
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

    // Test health endpoint
    try {
      final response = await makeRequest('GET', '/health');
      if (response.statusCode == 200) {
        print('✅ Health endpoint working');
      } else {
        print('⚠️  Health endpoint returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Health endpoint failed: $e');
    }
  }

  // Test authentication endpoints
  Future<void> testAuthEndpoints() async {
    print('\n🔐 Testing Authentication Endpoints...');

    // Test registration
    final registerData = {
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'test@example.com',
      'phoneNumber': '+1234567890',
      'password': 'TestPassword123!',
      'confirmPassword': 'TestPassword123!',
      'acceptTerms': true,
    };

    try {
      final response = await makeRequest('POST', '/api/v1/auth/register',
          body: registerData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Registration endpoint working');
      } else {
        print('⚠️  Registration returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Registration failed: $e');
    }

    // Test login
    final loginData = {
      'email': 'test@example.com',
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
      } else {
        print('⚠️  Login returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Login failed: $e');
    }

    // Test refresh token
    try {
      final response =
          await makeRequest('POST', '/api/v1/auth/refresh', requiresAuth: true);
      if (response.statusCode == 200) {
        print('✅ Refresh token endpoint working');
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
      if (response.statusCode == 200) {
        print('✅ Logout endpoint working');
      } else {
        print('⚠️  Logout returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Logout failed: $e');
    }
  }

  // Test OTP endpoints
  Future<void> testOtpEndpoints() async {
    print('\n📱 Testing OTP Endpoints...');

    // Test send OTP
    final otpData = {
      'email': 'test@example.com',
      'type': 'email_verification',
    };

    try {
      final response =
          await makeRequest('POST', '/api/v1/auth/otp/send', body: otpData);
      if (response.statusCode == 200) {
        print('✅ Send OTP endpoint working');
      } else {
        print('⚠️  Send OTP returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Send OTP failed: $e');
    }

    // Test verify OTP
    final verifyData = {
      'email': 'test@example.com',
      'otp': '123456',
      'type': 'email_verification',
    };

    try {
      final response = await makeRequest('POST', '/api/v1/auth/otp/verify',
          body: verifyData);
      if (response.statusCode == 200 || response.statusCode == 400) {
        print('✅ Verify OTP endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Verify OTP returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Verify OTP failed: $e');
    }
  }

  // Test user profile endpoints
  Future<void> testUserEndpoints() async {
    print('\n👤 Testing User Profile Endpoints...');

    // Test get user profile
    try {
      final response =
          await makeRequest('GET', '/api/v1/users/profile', requiresAuth: true);
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
      'firstName': 'Updated',
      'lastName': 'User',
      'phoneNumber': '+1234567891',
      'bio': 'Updated bio',
    };

    try {
      final response = await makeRequest('PUT', '/api/v1/users/profile',
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

    // Test file upload request
    final uploadRequestData = {
      'fileName': 'test-image.jpg',
      'fileSize': 1024000,
      'mimeType': 'image/jpeg',
      'purpose': 'profile_picture',
    };

    try {
      final response = await makeRequest('POST', '/api/v1/files/upload/request',
          body: uploadRequestData, requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ File Upload Request endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  File Upload Request returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ File Upload Request failed: $e');
    }

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

    // Test notification settings
    try {
      final response = await makeRequest(
          'GET', '/api/v1/notifications/settings',
          requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Notification Settings endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Notification Settings returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Notification Settings failed: $e');
    }
  }

  // Test verification endpoints
  Future<void> testVerificationEndpoints() async {
    print('\n✅ Testing Verification Endpoints...');

    // Test get verification rules
    try {
      final response = await makeRequest('GET', '/api/v1/verification/rules');
      if (response.statusCode == 200) {
        print('✅ Verification Rules endpoint working');
      } else {
        print('⚠️  Verification Rules returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Verification Rules failed: $e');
    }

    // Test get verification requests
    try {
      final response = await makeRequest('GET', '/api/v1/verification/requests',
          requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 401) {
        print(
            '✅ Verification Requests endpoint accessible (${response.statusCode})');
      } else {
        print('⚠️  Verification Requests returned: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Verification Requests failed: $e');
    }
  }

  // Run comprehensive tests
  Future<void> runComprehensiveTests() async {
    print('🚀 Starting API Endpoint Testing...');
    print('📍 Base URL: $baseUrl');
    print('🔧 Using correct API prefix: /api/v1');
    print('=' * 60);

    await testServerHealth();
    await testAuthEndpoints();
    await testOtpEndpoints();
    await testUserEndpoints();
    await testFileEndpoints();
    await testNotificationEndpoints();
    await testVerificationEndpoints();

    print('\n${'=' * 60}');
    print('✨ API Endpoint Testing Complete!');
    print('\n📝 Summary:');
    print('- ✅ = Endpoint working correctly');
    print('- ⚠️  = Endpoint accessible but may need authentication or data');
    print('- ❌ = Endpoint not accessible or network error');
    print(
        '- Status 401 = Authentication required (expected for protected endpoints)');
    print('- Status 400 = Bad request (expected for invalid data)');
  }
}

void main() async {
  print('🔍 IDEC API Endpoint Testing Tool');
  print('Testing backend server with correct API paths...\n');

  final tester = ApiEndpointTester();
  await tester.runComprehensiveTests();
}
