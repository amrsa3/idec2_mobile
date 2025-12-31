const axios = require('axios');

// إعدادات الاختبار
const BASE_URL = 'http://localhost:3000';
const TIMEOUT = 10000;

// إعداد axios
const api = axios.create({
  baseURL: BASE_URL,
  timeout: TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
  }
});

// متغيرات للاختبار
let authToken = null;
let refreshToken = null;
let testUserId = null;
let testPhone = null;

// دالة مساعدة لطباعة النتائج
function logResult(testName, success, details = '') {
  const status = success ? '✅' : '❌';
  console.log(`${status} ${testName}`);
  if (details) {
    console.log(`   ${details}`);
  }
}

// دالة مساعدة لاختبار نقطة نهاية
async function testEndpoint(name, method, url, data = null, headers = {}) {
  try {
    const config = {
      method,
      url,
      headers: { ...api.defaults.headers, ...headers },
    };
    
    if (data) {
      config.data = data;
    }

    const response = await api(config);
    logResult(name, true, `Status: ${response.status}`);
    return { success: true, data: response.data, status: response.status };
  } catch (error) {
    const status = error.response?.status || 'Network Error';
    const message = error.response?.data?.message || error.message;
    logResult(name, false, `Status: ${status}, Error: ${message}`);
    return { success: false, error: message, status };
  }
}

// الاختبارات الرئيسية
async function runTests() {
  console.log('🚀 بدء اختبار نقاط النهاية المُصححة...\n');

  // 1. اختبار Health Check
  console.log('📊 اختبار Health Check:');
  await testEndpoint(
    'Health Check (Fixed Path)',
    'GET',
    '/health'
  );
  console.log('');

  // 2. اختبار OTP Channels
  console.log('📱 اختبار OTP Channels:');
  await testEndpoint(
    'Get OTP Channels',
    'GET',
    '/api/v1/auth/channels'
  );
  console.log('');

  // 3. اختبار التسجيل (بالبنية الصحيحة)
  console.log('👤 اختبار التسجيل:');
  testPhone = `+967${Math.floor(Math.random() * 900000000) + 700000000}`;
  const registerData = {
    phone: testPhone,
    password: 'TestPassword123!',
    confirmPassword: 'TestPassword123!',
    name: 'مستخدم تجريبي',
    email: `test_${Date.now()}@example.com`
  };

  const registerResult = await testEndpoint(
    'User Registration (Fixed Path)',
    'POST',
    '/api/v1/auth/register',
    registerData
  );

  if (registerResult.success) {
    testUserId = registerResult.data?.user?.id;
  }
  console.log('');

  // 4. اختبار حالة المستخدم
  console.log('🔍 اختبار حالة المستخدم:');
  await testEndpoint(
    'Check User Status',
    'GET',
    `/api/v1/auth/check-user-status?phone=${encodeURIComponent(testPhone)}`
  );
  console.log('');

  // 5. اختبار طلب OTP
  console.log('📨 اختبار طلب OTP:');
  await testEndpoint(
    'Request OTP (Fixed Path)',
    'POST',
    '/api/v1/auth/request-otp',
    {
      phone: testPhone,
      channel: 'sms'
    }
  );
  console.log('');

  // 6. اختبار إعادة إرسال OTP
  console.log('🔄 اختبار إعادة إرسال OTP:');
  await testEndpoint(
    'Resend OTP',
    'POST',
    '/api/v1/auth/resend-otp',
    {
      phone: testPhone,
      channel: 'sms'
    }
  );
  console.log('');

  // 7. اختبار التحقق من OTP (مع رمز وهمي)
  console.log('🔐 اختبار التحقق من OTP:');
  await testEndpoint(
    'Verify OTP',
    'POST',
    '/api/v1/auth/verify-otp',
    {
      phone: testPhone,
      otp: '123456'
    }
  );
  console.log('');

  // 8. اختبار تسجيل الدخول
  console.log('🔐 اختبار تسجيل الدخول:');
  const loginResult = await testEndpoint(
    'User Login (Fixed Path)',
    'POST',
    '/api/v1/auth/login',
    {
      phone: testPhone,
      password: registerData.password
    }
  );

  if (loginResult.success && loginResult.data?.accessToken) {
    authToken = loginResult.data.accessToken;
    refreshToken = loginResult.data.refreshToken;
  }
  console.log('');

  // 9. اختبار الملف الشخصي (مع التوكن)
  if (authToken) {
    console.log('👤 اختبار الملف الشخصي:');
    await testEndpoint(
      'Get User Profile (Fixed Path)',
      'GET',
      '/api/v1/auth/profile',
      null,
      { Authorization: `Bearer ${authToken}` }
    );

    await testEndpoint(
      'Update User Profile',
      'PUT',
      '/api/v1/auth/profile',
      {
        name: 'مستخدم تجريبي محدث'
      },
      { Authorization: `Bearer ${authToken}` }
    );
    console.log('');

    // 10. اختبار تحديث التوكن
    console.log('🔄 اختبار تحديث التوكن:');
    if (refreshToken) {
      await testEndpoint(
        'Refresh Token',
        'POST',
        '/api/v1/auth/refresh',
        { refresh_token: refreshToken }
      );
    }
    console.log('');

    // 11. اختبار الملفات
    console.log('📁 اختبار الملفات:');
    await testEndpoint(
      'Request File Upload (Fixed Path)',
      'POST',
      '/api/v1/files/upload/request',
      {
        fileName: 'test.jpg',
        fileSize: 1024,
        mimeType: 'image/jpeg'
      },
      { Authorization: `Bearer ${authToken}` }
    );
    console.log('');

    // 12. اختبار الإشعارات
    console.log('🔔 اختبار الإشعارات:');
    await testEndpoint(
      'Get Notifications (Fixed Path)',
      'GET',
      '/api/v1/notifications?page=1&limit=10',
      null,
      { Authorization: `Bearer ${authToken}` }
    );

    await testEndpoint(
      'Get Notification Settings',
      'GET',
      '/api/v1/notifications/settings',
      null,
      { Authorization: `Bearer ${authToken}` }
    );
    console.log('');

    // 13. اختبار تسجيل الخروج
    console.log('🚪 اختبار تسجيل الخروج:');
    await testEndpoint(
      'User Logout (Fixed Path)',
      'POST',
      '/api/v1/auth/logout',
      {},
      { Authorization: `Bearer ${authToken}` }
    );
    console.log('');
  }

  // 14. اختبار نقاط نهاية غير صحيحة
  console.log('❌ اختبار نقاط نهاية غير صحيحة:');
  await testEndpoint(
    'Invalid Endpoint',
    'GET',
    '/api/v1/invalid-endpoint'
  );
  console.log('');

  console.log('✅ انتهى الاختبار الشامل للنقاط المُصححة!');
}

// تشغيل الاختبارات
runTests().catch(console.error);