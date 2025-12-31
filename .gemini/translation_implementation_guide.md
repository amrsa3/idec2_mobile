# دليل تطبيق الترجمات الشامل

## الخطوة 1: إضافة الترجمات إلى app_en.arb

### الموقع:
`/lib/l10n/app_en.arb`

### الطريقة:
1. افتح ملف `app_en.arb`
2. انسخ محتوى ملف `.gemini/translations_to_add.json`
3. الصق المحتوى **قبل** القوس الأخير `}` في `app_en.arb`
4. تأكد من إضافة فاصلة `,` بعد آخر عنصر موجود

---

## الخطوة 2: تحديث الصفحات

### القاعدة العامة:
استبدل جميع النصوص العربية الثابتة بـ `l10n.keyName`

### مثال:
```dart
// قبل
Text('مستنداتي')

// بعد
Text(l10n.myDocuments)
```

---

## الصفحات التي تحتاج تحديث:

### 1. صفحة مستنداتي
**الملف**: `/lib/features/profile/presentation/screens/user_documents_viewer_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'مستنداتي' → l10n.myDocuments
'لا توجد مستندات' → l10n.noDocuments
'تحميل...' → l10n.loading
'حدث خطأ' → l10n.errorOccurred
```

---

### 2. صفحة الملف الشخصي
**الملف**: `/lib/features/profile/presentation/screens/profile_main_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الملف الشخصي' → l10n.myProfile
'المعلومات الشخصية' → l10n.personalInfo
'الاسم الكامل' → l10n.fullNameAr
'البريد الإلكتروني' → l10n.email
'رقم الهاتف' → l10n.phoneNumber
'المحافظة' → l10n.governorate
'المؤهل' → l10n.qualification
'سنة التخرج' → l10n.graduationYear
'التخصص' → l10n.specialization
```

---

### 3. صفحة تعديل الملف الشخصي
**الملف**: `/lib/features/profile/presentation/screens/profile_edit_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'تعديل الملف الشخصي' → l10n.editProfile
'حفظ التغييرات' → l10n.saveChanges
'إلغاء' → l10n.cancel
```

---

### 4. صفحة الدورات
**الملف**: `/lib/features/courses/presentation/courses_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الدورات' → l10n.courses
'جميع الدورات' → l10n.allCourses
'دوراتي' → l10n.myCourses
'الدورات المتاحة' → l10n.availableCourses
'بحث عن دورة' → l10n.searchCourses
'لا توجد دورات' → l10n.noCourses
'مجاناً' → l10n.free
'مقعد' → l10n.seats
'ساعة' → l10n.hours
'التسجيل مفتوح' → l10n.registrationOpen
'التسجيل مغلق' → l10n.registrationClosed
'ممتلئ' → l10n.fullyBooked
```

---

### 5. صفحة تفاصيل الدورة
**الملف**: `/lib/features/schedule/presentation/event_details_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'تفاصيل الدورة' → l10n.courseDetails
'الوصف' → l10n.description
'المتطلبات' → l10n.requirements (أضف إلى app_en.arb: "requirements": "Requirements")
'المدرب' → l10n.courseInstructor
'المدة' → l10n.courseDuration
'المستوى' → l10n.courseLevel
'السعة' → l10n.courseCapacity
'المكان' → l10n.courseLocation
'التاريخ' → l10n.date
'الوقت' → l10n.time
'السعر' → l10n.price
'التسجيل' → l10n.registerForCourse
'شهادة معتمدة' → l10n.certificate (أضف: "certificate": "Certificate")
```

---

### 6. صفحة المتحدثون
**الملف**: `/lib/features/speakers/presentation/speakers_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'المتحدثون' → l10n.speakers
'جميع المتحدثون' → l10n.allSpeakers
'بحث عن متحدث' → l10n.searchSpeakers
'لا يوجد متحدثون' → l10n.noSpeakers
```

---

### 7. صفحة تفاصيل المتحدث
**الملف**: `/lib/features/speakers/presentation/speaker_details_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'تفاصيل المتحدث' → l10n.speakerDetails
'السيرة الذاتية' → l10n.speakerBio
'الجلسات' → l10n.speakerSessions
```

---

### 8. صفحة الجلسات
**الملف**: `/lib/features/sessions/presentation/sessions_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الجلسات' → l10n.sessions
'جميع الجلسات' → l10n.allSessions
'جلساتي' → l10n.mySessions
'الجلسات القادمة' → l10n.upcomingSessions
'الجلسات السابقة' → l10n.pastSessions
'لا توجد جلسات' → l10n.noSessions
'مباشر' → l10n.live
'قادم' → l10n.upcoming
'انتهى' → l10n.ended
```

---

### 9. صفحة الأخبار
**الملف**: `/lib/features/news/presentation/screens/news_list_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الأخبار' → l10n.news
'آخر الأخبار' → l10n.latestNews
'بحث في الأخبار' → l10n.searchNews
'لا توجد أخبار' → l10n.noNews
'اقرأ المزيد' → l10n.readMore
```

---

### 10. صفحة معرض الصور
**الملف**: `/lib/features/gallery/presentation/gallery_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'معرض الصور' → l10n.photoGallery
'الألبومات' → l10n.albums
'جميع الصور' → l10n.allPhotos
'لا توجد صور' → l10n.noPhotos
'صورة' → l10n.photos
```

---

### 11. صفحة اشتراكاتي
**الملف**: `/lib/features/registrations/presentation/my_registrations_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'اشتراكاتي' → l10n.myRegistrations
'نشط' → l10n.activeRegistrations
'قيد الانتظار' → l10n.pendingRegistrations
'مكتمل' → l10n.completedRegistrations
'ملغي' → l10n.cancelledRegistrations
'لا توجد اشتراكات' → l10n.noRegistrations
```

---

### 12. صفحة تفاصيل الاشتراك
**الملف**: `/lib/features/registrations/presentation/registration_detail_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'تفاصيل الاشتراك' → l10n.registrationDetails
'تاريخ الاشتراك' → l10n.registrationDate
'حالة الاشتراك' → l10n.registrationStatus
'حالة الدفع' → l10n.paymentStatus
'طريقة الدفع' → l10n.paymentMethod
'تاريخ الدفع' → l10n.paymentDate
'المبلغ الإجمالي' → l10n.totalAmount
'المبلغ المدفوع' → l10n.paidAmount
'المبلغ المتبقي' → l10n.remainingAmount
'عرض الإيصال' → l10n.viewReceipt
'تحميل الإيصال' → l10n.downloadReceipt
'إلغاء الاشتراك' → l10n.cancelRegistration
```

---

### 13. صفحة الإشعارات
**الملف**: `/lib/features/notifications/presentation/notifications_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الإشعارات' → l10n.notifications
'الكل' → l10n.allNotifications
'غير مقروء' → l10n.unreadNotifications
'مقروء' → l10n.readNotifications
'تحديد كمقروء' → l10n.markAsRead
'تحديد الكل كمقروء' → l10n.markAllAsRead
'حذف' → l10n.delete
'لا توجد إشعارات' → l10n.noNotifications
```

---

### 14. الصفحة الرئيسية
**الملف**: `/lib/features/home/presentation/home_screen.dart`

**النصوص المطلوب استبدالها**:
```dart
'الرئيسية' → l10n.home
'مرحباً' → l10n.welcome
'الإجراءات السريعة' → l10n.quickActions
'عرض الكل' → l10n.viewAll
'التحديثات الأخيرة' → l10n.recentUpdates
```

---

### 15. شريط القائمة السفلي
**الملف**: `/lib/features/main/widgets/app_bottom_navigation_bar.dart`

**النصوص المطلوب استبدالها**:
```dart
'الرئيسية' → l10n.home
'الجدول' → l10n.schedule
'الدورات' → l10n.courses
'المتحدثون' → l10n.speakers
'الملف الشخصي' → l10n.profile
```

---

### 16. نافذة Loading
**الملف**: `/lib/shared/widgets/professional_loading_overlay.dart`

**النصوص المطلوب استبدالها**:
```dart
'جاري التحميل...' → l10n.loading
'الرجاء الانتظار' → l10n.pleaseWait
```

---

## الخطوة 3: إضافة l10n إلى كل صفحة

### تأكد من وجود:
```dart
import '../../l10n/app_localizations.dart';

// في build method:
final l10n = AppLocalizations.of(context);
```

---

## الخطوة 4: الاختبار

1. قم بتشغيل التطبيق
2. غيّر اللغة من الإعدادات
3. تأكد من ظهور النصوص بشكل صحيح بالعربية والإنجليزية
4. تحقق من جميع الصفحات

---

## ملاحظات مهمة:

1. **RTL/LTR**: التطبيق يدعم RTL/LTR تلقائياً
2. **الخطوط**: تأكد من استخدام خط يدعم العربية والإنجليزية
3. **التنسيق**: بعض النصوص قد تحتاج تعديل في التنسيق
4. **الاختبار**: اختبر كل صفحة بعد التعديل

---

## الترجمات الإضافية المطلوبة:

أضف هذه الترجمات إلى `app_en.arb`:

```json
"requirements": "Requirements",
"certificate": "Certificate",
"certified": "Certified",
"instructor": "Instructor",
"duration": "Duration",
"level": "Level",
"capacity": "Capacity",
"available": "Available",
"notAvailable": "Not Available"
```

---

## الخلاصة:

- ✅ جميع الترجمات جاهزة في `.gemini/translations_to_add.json`
- ✅ الدليل الشامل جاهز لكل صفحة
- ⏳ التطبيق يحتاج تنفيذ يدوي لكل صفحة

**الوقت المقدر**: 2-3 ساعات لتطبيق جميع التغييرات
