const axios = require('axios');

// Configuration
const BASE_URL = 'http://localhost:3000';
const API_V1 = `${BASE_URL}/api/v1`;

// Test data
const testUser = {
  phone: '+967771234567',
  password: 'Test123!@#',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@example.com'
};

let authToken = '';
let refreshToken = '';

// Test results storage
const testResults = {
  passed: 0,
  failed: 0,
  tests: [],
  endpointComparison: {
    flutter: {},
    server: {},
    mismatches: []
  }
};

// Helper function to make authenticated requests
const authenticatedRequest = (method, url, data = null) => {
  const config = {
    method,
    url,
    headers: authToken ? { Authorization: `Bearer ${authToken}` } : {},
  };
  
  if (data) {
    config.data = data;
  }
  
  return axios(config);
};

// Test function
async function runTest(name, testFn, category = 'general') {
  try {
    console.log(`\n🧪 Testing: ${name}`);
    const result = await testFn();
    console.log(`✅ PASSED: ${name}`);
    testResults.passed++;
    testResults.tests.push({ 
      name, 
      status: 'PASSED', 
      result, 
      category,
      timestamp: new Date().toISOString()
    });
    return result;
  } catch (error) {
    console.log(`❌ FAILED: ${name}`);
    console.log(`   Error: ${error.message}`);
    if (error.response) {
      console.log(`   Status: ${error.response.status}`);
      console.log(`   Data: ${JSON.stringify(error.response.data, null, 2)}`);
    }
    testResults.failed++;
    testResults.tests.push({ 
      name, 
      status: 'FAILED', 
      error: error.message,
      category,
      timestamp: new Date().toISOString()
    });
    return null;
  }
}

// Test endpoint existence
async function testEndpointExists(url, method = 'GET', expectedStatus = [200, 401, 404]) {
  try {
    const response = await axios({
      method,
      url,
      validateStatus: () => true // Don't throw on any status
    });
    
    return {
      exists: true,
      status: response.status,
      accessible: expectedStatus.includes(response.status)
    };
  } catch (error) {
    return {
      exists: false,
      error: error.message
    };
  }
}

// Main test function
async function runAllTests() {
  console.log('🚀 بدء اختبار شامل لجميع نقاط نهاية API...\n');
  console.log('='.repeat(80));
  
  // 1. Health Check Tests
  console.log('\n📊 اختبار نقاط الصحة والحالة');
  console.log('-'.repeat(50));
  
  await runTest('Health Check - Server Endpoint', async () => {
    const response = await axios.get(`${API_V1}/health`);
    if (response.status !== 200) throw new Error('Health check failed');
    if (!response.data.status || response.data.status !== 'ok') {
      throw new Error('Health status is not ok');
    }
    return response.data;
  }, 'health');

  // Test Flutter app's expected health endpoint (should fail)
  await runTest('Health Check - Flutter Expected Endpoint (Should Fail)', async () => {
    try {
      const response = await axios.get(`${BASE_URL}/api/server/health`);
      return { status: 'unexpected_success', data: response.data };
    } catch (error) {
      if (error.response && error.response.status === 404) {
        throw new Error('Endpoint not found as expected - Flutter app uses wrong path');
      }
      throw error;
    }
  }, 'health');

  // 2. Authentication Tests
  console.log('\n🔐 اختبار نقاط المصادقة');
  console.log('-'.repeat(50));

  // Test available OTP channels
  await runTest('Get Available OTP Channels', async () => {
    const response = await axios.get(`${API_V1}/auth/channels`);
    if (response.status !== 200) throw new Error('Get channels failed');
    return response.data;
  }, 'auth');

  // Test user registration
  await runTest('User Registration', async () => {
    const response = await axios.post(`${API_V1}/auth/register`, testUser);
    if (response.status !== 201) throw new Error('Registration failed');
    if (!response.data.success) throw new Error('Registration response indicates failure');
    return response.data;
  }, 'auth');

  // Test check user status
  await runTest('Check User Status', async () => {
    const response = await axios.post(`${API_V1}/auth/check-user-status`, {
      phone: testUser.phone
    });
    if (response.status !== 200) throw new Error('Check user status failed');
    return response.data;
  }, 'auth');

  // Test request OTP
  await runTest('Request OTP', async () => {
    const response = await axios.post(`${API_V1}/auth/request-otp`, {
      phoneNumber: testUser.phone
    });
    if (response.status !== 200) throw new Error('Request OTP failed');
    return response.data;
  }, 'auth');

  // Test resend OTP
  await runTest('Resend OTP', async () => {
    const response = await axios.post(`${API_V1}/auth/resend-otp`, {
      phone: testUser.phone
    });
    if (response.status !== 200) throw new Error('Resend OTP failed');
    return response.data;
  }, 'auth');

  // Test verify OTP (will fail with invalid code)
  await runTest('Verify OTP Endpoint Test', async () => {
    try {
      const response = await axios.post(`${API_V1}/auth/verify-otp`, {
        phone: testUser.phone,
        otp: '123456'
      });
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 400) {
        return { message: 'Endpoint exists, invalid code as expected' };
      }
      throw error;
    }
  }, 'auth');

  // Test login attempt
  await runTest('User Login Attempt', async () => {
    try {
      const response = await axios.post(`${API_V1}/auth/login`, {
        phone: testUser.phone,
        password: testUser.password
      });
      if (response.data.accessToken) {
        authToken = response.data.accessToken;
        refreshToken = response.data.refreshToken;
      }
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { message: 'Login failed as expected (phone not verified)' };
      }
      throw error;
    }
  }, 'auth');

  // Test refresh token
  await runTest('Refresh Token Endpoint', async () => {
    try {
      const response = await axios.post(`${API_V1}/auth/refresh`, {
        refreshToken: refreshToken || 'invalid-token'
      });
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { message: 'Endpoint exists, invalid token as expected' };
      }
      throw error;
    }
  }, 'auth');

  // 3. Profile Tests
  console.log('\n👤 اختبار نقاط الملف الشخصي');
  console.log('-'.repeat(50));

  // Test get profile (server endpoint)
  await runTest('Get User Profile - Server Endpoint', async () => {
    try {
      const response = await authenticatedRequest('GET', `${API_V1}/auth/profile`);
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { message: 'Endpoint exists, authentication required as expected' };
      }
      throw error;
    }
  }, 'profile');

  // Test Flutter app's expected profile endpoint (should fail)
  await runTest('Get User Profile - Flutter Expected Endpoint (Should Fail)', async () => {
    try {
      const response = await axios.get(`${BASE_URL}/api/user/profile`);
      return { status: 'unexpected_success', data: response.data };
    } catch (error) {
      if (error.response && error.response.status === 404) {
        throw new Error('Endpoint not found as expected - Flutter app uses wrong path');
      }
      throw error;
    }
  }, 'profile');

  // 4. File Management Tests
  console.log('\n📁 اختبار نقاط إدارة الملفات');
  console.log('-'.repeat(50));

  // Test files endpoint (server)
  await runTest('Files Endpoint - Server', async () => {
    try {
      const response = await axios.get(`${API_V1}/files`);
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { message: 'Endpoint exists, authentication required as expected' };
      }
      throw error;
    }
  }, 'files');

  // Test Flutter app's expected files endpoint (should fail)
  await runTest('Files Endpoint - Flutter Expected (Should Fail)', async () => {
    try {
      const response = await axios.get(`${BASE_URL}/api/files`);
      return { status: 'unexpected_success', data: response.data };
    } catch (error) {
      if (error.response && error.response.status === 404) {
        throw new Error('Endpoint not found as expected - Flutter app uses wrong path');
      }
      throw error;
    }
  }, 'files');

  // 5. Notification Tests
  console.log('\n🔔 اختبار نقاط الإشعارات');
  console.log('-'.repeat(50));

  // Test notifications endpoint (server)
  await runTest('Notifications Endpoint - Server', async () => {
    try {
      const response = await axios.get(`${API_V1}/notifications`);
      return response.data;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { message: 'Endpoint exists, authentication required as expected' };
      }
      throw error;
    }
  }, 'notifications');

  // Test Flutter app's expected notifications endpoint (should fail)
  await runTest('Notifications Endpoint - Flutter Expected (Should Fail)', async () => {
    try {
      const response = await axios.get(`${BASE_URL}/api/notifications`);
      return { status: 'unexpected_success', data: response.data };
    } catch (error) {
      if (error.response && error.response.status === 404) {
        throw new Error('Endpoint not found as expected - Flutter app uses wrong path');
      }
      throw error;
    }
  }, 'notifications');

  // 6. Users Management Tests
  console.log('\n👥 اختبار نقاط إدارة المستخدمين');
  console.log('-'.repeat(50));

  await runTest('Get All Users', async () => {
    const response = await axios.get(`${API_V1}/users`);
    if (response.status !== 200) throw new Error('Get users failed');
    return response.data;
  }, 'users');

  // 7. Endpoint Comparison Analysis
  console.log('\n🔍 تحليل مقارنة نقاط النهاية');
  console.log('-'.repeat(50));

  const endpointMismatches = [
    {
      flutter: '/api/server/health',
      server: '/health',
      description: 'Health check endpoint'
    },
    {
      flutter: '/api/auth/register',
      server: '/api/v1/auth/register',
      description: 'User registration'
    },
    {
      flutter: '/api/auth/login',
      server: '/api/v1/auth/login',
      description: 'User login'
    },
    {
      flutter: '/api/auth/otp/send',
      server: '/api/v1/auth/request-otp',
      description: 'Send OTP'
    },
    {
      flutter: '/api/auth/otp/verify',
      server: '/api/v1/auth/verify-otp',
      description: 'Verify OTP'
    },
    {
      flutter: '/api/user/profile',
      server: '/api/v1/auth/profile',
      description: 'User profile'
    },
    {
      flutter: '/api/files/*',
      server: '/api/v1/files/*',
      description: 'File management'
    },
    {
      flutter: '/api/notifications',
      server: '/api/v1/notifications',
      description: 'Notifications'
    }
  ];

  testResults.endpointComparison.mismatches = endpointMismatches;

  // Test each mismatch
  for (const mismatch of endpointMismatches) {
    await runTest(`Endpoint Mismatch Analysis: ${mismatch.description}`, async () => {
      const flutterResult = await testEndpointExists(`${BASE_URL}${mismatch.flutter}`);
      const serverResult = await testEndpointExists(`${BASE_URL}${mismatch.server}`);
      
      return {
        flutter: flutterResult,
        server: serverResult,
        mismatch: !flutterResult.exists && serverResult.exists
      };
    }, 'comparison');
  }

  // Generate final report
  console.log('\n' + '='.repeat(80));
  console.log('📊 ملخص نتائج الاختبار الشامل');
  console.log('='.repeat(80));
  console.log(`✅ نجح: ${testResults.passed}`);
  console.log(`❌ فشل: ${testResults.failed}`);
  console.log(`📈 معدل النجاح: ${((testResults.passed / (testResults.passed + testResults.failed)) * 100).toFixed(1)}%`);
  
  console.log('\n📋 النتائج التفصيلية حسب الفئة:');
  const categories = {};
  testResults.tests.forEach(test => {
    if (!categories[test.category]) {
      categories[test.category] = { passed: 0, failed: 0 };
    }
    categories[test.category][test.status === 'PASSED' ? 'passed' : 'failed']++;
  });

  Object.entries(categories).forEach(([category, stats]) => {
    const total = stats.passed + stats.failed;
    const percentage = ((stats.passed / total) * 100).toFixed(1);
    console.log(`  ${category}: ${stats.passed}/${total} (${percentage}%)`);
  });

  console.log('\n🚨 المشاكل المحددة في نقاط النهاية:');
  console.log('-'.repeat(50));
  endpointMismatches.forEach((mismatch, index) => {
    console.log(`${index + 1}. ${mismatch.description}`);
    console.log(`   Flutter: ${mismatch.flutter}`);
    console.log(`   Server:  ${mismatch.server}`);
    console.log('');
  });

  console.log('\n💡 التوصيات:');
  console.log('-'.repeat(50));
  console.log('1. تحديث ملف api_constants.dart لاستخدام البادئة /api/v1');
  console.log('2. تحديث ملف api_service.dart لاستخدام المسارات الصحيحة');
  console.log('3. تحديث مسار الملف الشخصي من /api/user/profile إلى /api/v1/auth/profile');
  console.log('4. تحديث مسارات OTP لتتطابق مع الخادم');
  console.log('5. إضافة البادئة /api/v1 لجميع نقاط النهاية');

  // Save results to file
  const reportData = {
    timestamp: new Date().toISOString(),
    summary: {
      passed: testResults.passed,
      failed: testResults.failed,
      successRate: ((testResults.passed / (testResults.passed + testResults.failed)) * 100).toFixed(1)
    },
    categories,
    endpointMismatches,
    detailedResults: testResults.tests
  };

  console.log('\n📄 حفظ التقرير المفصل...');
  require('fs').writeFileSync(
    'api_test_comprehensive_report.json',
    JSON.stringify(reportData, null, 2)
  );
  console.log('✅ تم حفظ التقرير في: api_test_comprehensive_report.json');

  return reportData;
}

// Run the tests
runAllTests().catch(error => {
  console.error('❌ فشل في تشغيل مجموعة الاختبارات:', error.message);
  process.exit(1);
});