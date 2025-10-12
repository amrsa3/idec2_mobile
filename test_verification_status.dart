import 'dart:convert';
import 'lib/models/profile_model.dart';

void main() {
  print('🧪 اختبار تطابق حالة التوثيق');
  
  // محاكاة البيانات من API
  final apiResponse = {
    'id': 'cmgm71k1w0001f01t0pibl7is',
    'userId': 'cmgm71k1w0000f01t0pcw51ou',
    'fullNameAr': 'أحمد محمد علي المحدث',
    'fullNameEn': 'Ahmed Mohammed Ali Updated',
    'status': 'PENDING_VERIFICATION', // هذا ما يرسله API
    'completion_percentage': 85.0,
    'documents': [],
  };
  
  print('📡 البيانات من API:');
  print('   status: ${apiResponse['status']}');
  
  try {
    // تحويل البيانات إلى ProfileModel
    final profile = ProfileModel.fromJson(apiResponse);
    
    print('📱 البيانات في التطبيق:');
    print('   verificationStatus: ${profile.verificationStatus}');
    print('   displayName: ${profile.verificationStatus.displayName}');
    print('   color: ${profile.verificationStatus.color}');
    
    // التحقق من التطابق الصحيح
    if (profile.verificationStatus == VerificationStatus.underReview) {
      print('✅ نجح الإصلاح! حالة PENDING_VERIFICATION تظهر كـ underReview');
    } else {
      print('❌ فشل الإصلاح! حالة PENDING_VERIFICATION لا تظهر بشكل صحيح');
      print('   القيمة الحالية: ${profile.verificationStatus}');
    }
    
  } catch (e) {
    print('❌ خطأ في تحويل البيانات: $e');
  }
}