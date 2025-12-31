/**
 * مراجعة شاملة لجميع نقاط نهاية API - تطبيق IDEC Flutter
 * Comprehensive API Review Test for IDEC Flutter App
 * 
 * هذا الاختبار يقوم بمراجعة شاملة لجميع نقاط النهاية للتأكد من:
 * - صحة وسلامة البيانات المُرجعة
 * - توافق البيانات مع متطلبات الواجهة الأمامية
 * - معالجة الأخطاء والحالات الاستثنائية
 * - قياس الأداء وأوقات الاستجابة
 * 
 * تحديث: تم تطوير الاختبار ليشمل جميع النقاط المطلوبة
 */

const axios = require('axios');
const fs = require('fs');

// إعدادات الاختبار
const BASE_URL = 'http://localhost:3000';
const TEST_RESULTS = {
    timestamp: new Date().toISOString(),
    server_status: null,
    endpoints: {},
    performance: {},
    data_validation: {},
    error_handling: {},
    summary: {
        total_endpoints: 0,
        successful: 0,
        failed: 0,
        warnings: 0,
        success_rate: 0
    }
};

// بيانات اختبار
const TEST_DATA = {
    user: {
        phone: '+967771234567',
        password: 'Test123456',
        confirmPassword: 'Test123456',
        name: 'مستخدم اختبار',
        email: 'test@example.com'
    },
    invalidUser: {
        phone: '+967999999999',
        password: 'wrongpassword'
    }
};

// دالة لقياس وقت الاستجابة
async function measureResponseTime(testFunction) {
    const startTime = Date.now();
    try {
        const result = await testFunction();
        const responseTime = Date.now() - startTime;
        return { result, responseTime, success: true };
    } catch (error) {
        const responseTime = Date.now() - startTime;
        return { error, responseTime, success: false };
    }
}

// دالة للتحقق من صحة البيانات
function validateDataStructure(data, expectedFields, endpointName) {
    const validation = {
        endpoint: endpointName,
        valid: true,
        missing_fields: [],
        extra_fields: [],
        type_mismatches: [],
        recommendations: []
    };

    if (!data || typeof data !== 'object') {
        validation.valid = false;
        validation.recommendations.push('البيانات المُرجعة يجب أن تكون كائن JSON صحيح');
        return validation;
    }

    // فحص الحقول المطلوبة
    expectedFields.required?.forEach(field => {
        if (!(field in data)) {
            validation.missing_fields.push(field);
            validation.valid = false;
        }
    });

    // فحص أنواع البيانات
    expectedFields.types?.forEach(({ field, type }) => {
        if (field in data && typeof data[field] !== type) {
            validation.type_mismatches.push({
                field,
                expected: type,
                actual: typeof data[field]
            });
            validation.valid = false;
        }
    });

    return validation;
}

// اختبار حالة الخادم
async function testServerHealth() {
    console.log('🔍 اختبار حالة الخادم...');
    
    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.get(`${BASE_URL}/health`);
    });

    const testResult = {
        endpoint: '/health',
        method: 'GET',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['status', 'timestamp', 'uptime', 'version', 'services'],
            types: [
                { field: 'status', type: 'string' },
                { field: 'timestamp', type: 'string' },
                { field: 'uptime', type: 'number' },
                { field: 'version', type: 'string' }
            ]
        };

        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'Health Check');
        
        if (result.data.status === 'ok') {
            console.log('✅ الخادم يعمل بشكل صحيح');
            TEST_RESULTS.server_status = 'healthy';
        } else {
            console.log('⚠️ الخادم يعمل لكن هناك مشاكل');
            testResult.recommendations.push('فحص حالة الخدمات الفرعية');
        }
    } else {
        console.log('❌ فشل في الاتصال بالخادم');
        TEST_RESULTS.server_status = 'unhealthy';
        testResult.recommendations.push('التأكد من تشغيل الخادم على المنفذ 3000');
    }

    TEST_RESULTS.endpoints['health_check'] = testResult;
    return testResult;
}

// اختبار نقاط نهاية المصادقة
async function testAuthenticationEndpoints() {
    console.log('🔐 اختبار نقاط نهاية المصادقة...');

    // اختبار قنوات OTP
    await testOtpChannels();
    
    // اختبار تسجيل المستخدم
    await testUserRegistration();
    
    // اختبار تسجيل الدخول
    await testUserLogin();
    
    // اختبار طلب OTP
    await testRequestOtp();
    
    // اختبار التحقق من OTP
    await testVerifyOtp();
}

async function testOtpChannels() {
    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.get(`${BASE_URL}/api/v1/auth/channels`);
    });

    const testResult = {
        endpoint: '/api/v1/auth/channels',
        method: 'GET',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['channels'],
            types: [{ field: 'channels', type: 'object' }]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'OTP Channels');
        console.log('✅ قنوات OTP تعمل بشكل صحيح');
    } else {
        console.log('❌ فشل في الحصول على قنوات OTP');
        testResult.recommendations.push('التحقق من إعدادات قنوات OTP في الخادم');
    }

    TEST_RESULTS.endpoints['otp_channels'] = testResult;
}

async function testUserRegistration() {
    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.post(`${BASE_URL}/api/v1/auth/register`, TEST_DATA.user);
    });

    const testResult = {
        endpoint: '/api/v1/auth/register',
        method: 'POST',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['message'],
            types: [{ field: 'message', type: 'string' }]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'User Registration');
        console.log('✅ تسجيل المستخدم يعمل بشكل صحيح');
        
        // حفظ بيانات المستخدم للاختبارات اللاحقة
        if (result.data.otpCode) {
            TEST_DATA.user.otpCode = result.data.otpCode;
        }
    } else {
        console.log('❌ فشل في تسجيل المستخدم');
        if (error?.response?.status === 400) {
            testResult.recommendations.push('التحقق من صحة البيانات المرسلة');
        } else if (error?.response?.status === 409) {
            testResult.recommendations.push('المستخدم مسجل مسبقاً - هذا طبيعي في الاختبارات');
            testResult.success = true; // اعتبار هذا نجاح جزئي
        }
    }

    TEST_RESULTS.endpoints['user_registration'] = testResult;
}

async function testUserLogin() {
    const loginData = {
        phone: TEST_DATA.user.phone,
        password: TEST_DATA.user.password
    };

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.post(`${BASE_URL}/api/v1/auth/login`, loginData);
    });

    const testResult = {
        endpoint: '/api/v1/auth/login',
        method: 'POST',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['access_token', 'refresh_token', 'user'],
            types: [
                { field: 'access_token', type: 'string' },
                { field: 'refresh_token', type: 'string' },
                { field: 'user', type: 'object' }
            ]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'User Login');
        console.log('✅ تسجيل الدخول يعمل بشكل صحيح');
        
        // حفظ التوكن للاختبارات اللاحقة
        TEST_DATA.accessToken = result.data.access_token;
    } else {
        console.log('❌ فشل في تسجيل الدخول');
        if (error?.response?.status === 401) {
            testResult.recommendations.push('قد يحتاج المستخدم إلى تفعيل رقم الهاتف أولاً');
        }
    }

    TEST_RESULTS.endpoints['user_login'] = testResult;
}

async function testRequestOtp() {
    const otpData = { phone: TEST_DATA.user.phone };

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.post(`${BASE_URL}/api/v1/auth/request-otp`, otpData);
    });

    const testResult = {
        endpoint: '/api/v1/auth/request-otp',
        method: 'POST',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['message'],
            types: [{ field: 'message', type: 'string' }]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'Request OTP');
        console.log('✅ طلب OTP يعمل بشكل صحيح');
    } else {
        console.log('❌ فشل في طلب OTP');
        testResult.recommendations.push('التحقق من صحة رقم الهاتف وإعدادات OTP');
    }

    TEST_RESULTS.endpoints['request_otp'] = testResult;
}

async function testVerifyOtp() {
    if (!TEST_DATA.user.otpCode) {
        console.log('⚠️ لا يوجد رمز OTP للاختبار');
        return;
    }

    const verifyData = {
        phone: TEST_DATA.user.phone,
        otp: TEST_DATA.user.otpCode
    };

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.post(`${BASE_URL}/api/v1/auth/verify-otp`, verifyData);
    });

    const testResult = {
        endpoint: '/api/v1/auth/verify-otp',
        method: 'POST',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['message'],
            types: [{ field: 'message', type: 'string' }]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'Verify OTP');
        console.log('✅ التحقق من OTP يعمل بشكل صحيح');
    } else {
        console.log('❌ فشل في التحقق من OTP');
        testResult.recommendations.push('قد يكون رمز OTP منتهي الصلاحية أو غير صحيح');
    }

    TEST_RESULTS.endpoints['verify_otp'] = testResult;
}

// اختبار نقاط نهاية الملف الشخصي
async function testProfileEndpoints() {
    console.log('👤 اختبار نقاط نهاية الملف الشخصي...');

    if (!TEST_DATA.accessToken) {
        console.log('⚠️ لا يوجد توكن وصول - تخطي اختبارات الملف الشخصي');
        return;
    }

    const headers = {
        'Authorization': `Bearer ${TEST_DATA.accessToken}`,
        'Content-Type': 'application/json'
    };

    // اختبار الحصول على الملف الشخصي
    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.get(`${BASE_URL}/api/v1/auth/profile`, { headers });
    });

    const testResult = {
        endpoint: '/api/v1/auth/profile',
        method: 'GET',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['id', 'phone', 'name'],
            types: [
                { field: 'id', type: 'string' },
                { field: 'phone', type: 'string' },
                { field: 'name', type: 'string' }
            ]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'User Profile');
        console.log('✅ الحصول على الملف الشخصي يعمل بشكل صحيح');
    } else {
        console.log('❌ فشل في الحصول على الملف الشخصي');
        if (error?.response?.status === 401) {
            testResult.recommendations.push('التوكن قد يكون منتهي الصلاحية أو غير صحيح');
        }
    }

    TEST_RESULTS.endpoints['user_profile'] = testResult;
}

// اختبار نقاط نهاية الملفات
async function testFileEndpoints() {
    console.log('📁 اختبار نقاط نهاية الملفات...');

    // اختبار طلب رفع ملف
    const uploadRequest = {
        fileName: 'test-document.pdf',
        fileSize: 1024000,
        mimeType: 'application/pdf'
    };

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        const headers = TEST_DATA.accessToken ? 
            { 'Authorization': `Bearer ${TEST_DATA.accessToken}` } : {};
        return await axios.post(`${BASE_URL}/api/v1/files/upload/request`, uploadRequest, { headers });
    });

    const testResult = {
        endpoint: '/api/v1/files/upload/request',
        method: 'POST',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: ['uploadUrl', 'fileId'],
            types: [
                { field: 'uploadUrl', type: 'string' },
                { field: 'fileId', type: 'string' }
            ]
        };
        testResult.data_validation = validateDataStructure(result.data, expectedFields, 'File Upload Request');
        console.log('✅ طلب رفع الملف يعمل بشكل صحيح');
    } else {
        console.log('❌ فشل في طلب رفع الملف');
        if (error?.response?.status === 401) {
            testResult.recommendations.push('يتطلب مصادقة صحيحة');
        }
    }

    TEST_RESULTS.endpoints['file_upload_request'] = testResult;
}

// اختبار نقاط نهاية الإشعارات
async function testNotificationEndpoints() {
    console.log('🔔 اختبار نقاط نهاية الإشعارات...');

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        const headers = TEST_DATA.accessToken ? 
            { 'Authorization': `Bearer ${TEST_DATA.accessToken}` } : {};
        return await axios.get(`${BASE_URL}/api/v1/notifications?page=1&limit=10`, { headers });
    });

    const testResult = {
        endpoint: '/api/v1/notifications',
        method: 'GET',
        success,
        response_time: responseTime,
        status_code: success ? result.status : error?.response?.status || 0,
        data_validation: null,
        recommendations: []
    };

    if (success) {
        const expectedFields = {
            required: [],
            types: []
        };
        
        if (Array.isArray(result.data)) {
            testResult.data_validation = { valid: true, endpoint: 'Notifications' };
            console.log('✅ الحصول على الإشعارات يعمل بشكل صحيح');
        } else {
            testResult.data_validation = { valid: false, endpoint: 'Notifications' };
            testResult.recommendations.push('البيانات المُرجعة يجب أن تكون مصفوفة');
        }
    } else {
        console.log('❌ فشل في الحصول على الإشعارات');
        if (error?.response?.status === 401) {
            testResult.recommendations.push('يتطلب مصادقة صحيحة');
        }
    }

    TEST_RESULTS.endpoints['notifications'] = testResult;
}

// اختبار معالجة الأخطاء
async function testErrorHandling() {
    console.log('⚠️ اختبار معالجة الأخطاء...');

    // اختبار نقطة نهاية غير موجودة
    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.get(`${BASE_URL}/api/v1/nonexistent-endpoint`);
    });

    const testResult = {
        endpoint: '/api/v1/nonexistent-endpoint',
        method: 'GET',
        success: false,
        response_time: responseTime,
        status_code: error?.response?.status || 0,
        error_handling: {
            returns_proper_error: false,
            error_message_clear: false,
            status_code_appropriate: false
        },
        recommendations: []
    };

    if (error?.response?.status === 404) {
        testResult.error_handling.status_code_appropriate = true;
        console.log('✅ رمز الحالة 404 صحيح للنقاط غير الموجودة');
    }

    if (error?.response?.data?.message) {
        testResult.error_handling.error_message_clear = true;
        console.log('✅ رسالة الخطأ واضحة ومفيدة');
    }

    TEST_RESULTS.endpoints['error_handling_404'] = testResult;

    // اختبار بيانات غير صحيحة
    await testInvalidDataHandling();
}

async function testInvalidDataHandling() {
    const invalidLoginData = {
        phone: 'invalid-phone',
        password: ''
    };

    const { result, responseTime, success, error } = await measureResponseTime(async () => {
        return await axios.post(`${BASE_URL}/api/v1/auth/login`, invalidLoginData);
    });

    const testResult = {
        endpoint: '/api/v1/auth/login (invalid data)',
        method: 'POST',
        success: false,
        response_time: responseTime,
        status_code: error?.response?.status || 0,
        error_handling: {
            validates_input: false,
            returns_validation_errors: false,
            status_code_appropriate: false
        },
        recommendations: []
    };

    if (error?.response?.status === 400) {
        testResult.error_handling.status_code_appropriate = true;
        testResult.error_handling.validates_input = true;
        console.log('✅ التحقق من صحة البيانات يعمل بشكل صحيح');
    }

    if (error?.response?.data?.message || error?.response?.data?.errors) {
        testResult.error_handling.returns_validation_errors = true;
        console.log('✅ رسائل أخطاء التحقق واضحة');
    }

    TEST_RESULTS.endpoints['invalid_data_handling'] = testResult;
}

// حساب الإحصائيات النهائية
function calculateSummary() {
    const endpoints = Object.values(TEST_RESULTS.endpoints);
    TEST_RESULTS.summary.total_endpoints = endpoints.length;
    
    endpoints.forEach(endpoint => {
        if (endpoint.success) {
            TEST_RESULTS.summary.successful++;
        } else {
            TEST_RESULTS.summary.failed++;
        }
        
        if (endpoint.recommendations && endpoint.recommendations.length > 0) {
            TEST_RESULTS.summary.warnings++;
        }
    });

    TEST_RESULTS.summary.success_rate = 
        (TEST_RESULTS.summary.successful / TEST_RESULTS.summary.total_endpoints * 100).toFixed(1);

    // حساب متوسط وقت الاستجابة
    const responseTimes = endpoints.map(e => e.response_time).filter(t => t > 0);
    TEST_RESULTS.performance.average_response_time = 
        responseTimes.length > 0 ? 
        (responseTimes.reduce((a, b) => a + b, 0) / responseTimes.length).toFixed(2) : 0;
    
    TEST_RESULTS.performance.fastest_response = Math.min(...responseTimes);
    TEST_RESULTS.performance.slowest_response = Math.max(...responseTimes);
}

// تشغيل جميع الاختبارات
async function runComprehensiveAPIReview() {
    console.log('🚀 بدء المراجعة الشاملة لنقاط نهاية API...\n');

    try {
        // اختبار حالة الخادم
        await testServerHealth();
        
        if (TEST_RESULTS.server_status === 'healthy') {
            // اختبار نقاط نهاية المصادقة
            await testAuthenticationEndpoints();
            
            // اختبار نقاط نهاية الملف الشخصي
            await testProfileEndpoints();
            
            // اختبار نقاط نهاية الملفات
            await testFileEndpoints();
            
            // اختبار نقاط نهاية الإشعارات
            await testNotificationEndpoints();
            
            // اختبار معالجة الأخطاء
            await testErrorHandling();
        } else {
            console.log('❌ الخادم غير متاح - تم إيقاف الاختبارات');
        }

        // حساب الإحصائيات النهائية
        calculateSummary();

        // حفظ النتائج
        fs.writeFileSync(
            'comprehensive_api_review_results.json', 
            JSON.stringify(TEST_RESULTS, null, 2)
        );

        // طباعة الملخص
        console.log('\n📊 ملخص نتائج المراجعة الشاملة:');
        console.log(`إجمالي النقاط المختبرة: ${TEST_RESULTS.summary.total_endpoints}`);
        console.log(`النقاط الناجحة: ${TEST_RESULTS.summary.successful}`);
        console.log(`النقاط الفاشلة: ${TEST_RESULTS.summary.failed}`);
        console.log(`التحذيرات: ${TEST_RESULTS.summary.warnings}`);
        console.log(`معدل النجاح: ${TEST_RESULTS.summary.success_rate}%`);
        console.log(`متوسط وقت الاستجابة: ${TEST_RESULTS.performance.average_response_time}ms`);

        console.log('\n✅ تم حفظ النتائج التفصيلية في: comprehensive_api_review_results.json');

    } catch (error) {
        console.error('❌ خطأ في تشغيل المراجعة الشاملة:', error.message);
    }
}

// تشغيل الاختبار
if (require.main === module) {
    runComprehensiveAPIReview();
}

module.exports = {
    runComprehensiveAPIReview,
    TEST_RESULTS
};