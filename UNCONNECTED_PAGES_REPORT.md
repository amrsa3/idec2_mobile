# تقرير الصفحات غير المربوطة بالنظام - تطبيق الموبايل

## تاريخ التقرير
تم إنشاء هذا التقرير في: $(date)

---

## 📋 ملخص تنفيذي

تم فحص تطبيق الموبايل بالكامل وتحديد الصفحات التي **لا تعمل** أو **غير مربوطة** بالخادم (Backend API). التقرير التالي يوضح حالة كل صفحة.

---

## ✅ الصفحات المربوطة والعاملة

### 1. الصفحات الرئيسية
- ✅ **Home Screen** (`home_screen_new.dart`)
  - **الحالة**: مربوطة بالكامل
  - **الخدمات المستخدمة**: `ConferenceService`, `CompatibleAuthService`
  - **الوظائف**: عرض المؤتمرات النشطة، معلومات المستخدم

- ✅ **Profile Main Screen** (`profile_main_screen.dart`)
  - **الحالة**: مربوطة بالكامل
  - **الخدمات المستخدمة**: `ProfileService`, `ProfileProvider`
  - **الوظائف**: عرض وتعديل الملف الشخصي، إدارة الوثائق

### 2. صفحات المصادقة
- ✅ **Login Screen** - مربوطة بـ `CompatibleAuthService`
- ✅ **Register Screen** - مربوطة بـ `CompatibleAuthService`
- ✅ **OTP Verification Screen** - مربوطة بـ `CompatibleAuthService`
- ✅ **Forgot Password Screen** - مربوطة بـ `CompatibleAuthService`
- ✅ **Reset Password Screen** - مربوطة بـ `CompatibleAuthService`

### 3. صفحات التسجيلات
- ✅ **My Registrations Screen** (`my_registrations_screen.dart`)
  - **الحالة**: مربوطة بالكامل
  - **الخدمات المستخدمة**: `RegistrationService`
  - **API Endpoint**: `/api/v1/events/registrations/my-registrations`

- ✅ **Registration Detail Screen** - مربوطة بـ `RegistrationService`
- ✅ **Invoice Receipt Screen** - مربوطة بـ `InvoiceService`

### 4. صفحات أخرى
- ✅ **Notifications Screen** - مربوطة بـ `NotificationService`
- ✅ **Document Management Screen** - مربوطة بـ `FileService`

---

## ❌ الصفحات غير المربوطة أو غير العاملة

### 1. 🎨 صفحة معرض الصور (Gallery Screen)
**الملف**: `lib/features/gallery/presentation/gallery_screen.dart`

**الحالة**: ❌ **غير مربوطة - بيانات وهمية**

**المشاكل**:
- يستخدم بيانات وهمية (Hardcoded Data) في `_albums` list
- لا يوجد استدعاء لـ API
- لا يوجد `GalleryService` أو أي خدمة للربط بالخادم
- الصور من `picsum.photos` (خدمة صور وهمية)

**الكود الحالي**:
```dart
final List<GalleryAlbumModel> _albums = [
  GalleryAlbumModel(
    id: '1',
    title: 'اليوم الأول',
    coverImageUrl: 'https://picsum.photos/400/300?random=1',
    // ... بيانات وهمية
  ),
  // ... المزيد من البيانات الوهمية
];
```

**الحل المطلوب**:
1. إنشاء `GalleryService` في `lib/services/gallery_service.dart`
2. إضافة API endpoints في `api_constants.dart`:
   - `GET /api/v1/gallery/albums` - للحصول على الألبومات
   - `GET /api/v1/gallery/albums/:id/photos` - للحصول على صور الألبوم
3. ربط الصفحة بالخدمة الجديدة
4. **ملاحظة**: لا يوجد API endpoint للـ Gallery في الخادم حالياً - يحتاج تطوير

---

### 2. 🏢 صفحة المعرض التجاري (Exhibition Screen)
**الملف**: `lib/features/exhibition/presentation/exhibition_screen.dart`

**الحالة**: ❌ **غير مربوطة - بيانات وهمية**

**المشاكل**:
- يستخدم بيانات وهمية في `_buildExhibitorCard`
- لا يوجد استدعاء لـ API
- لا يوجد خدمة للربط بالخادم
- الأزرار تحتوي على `TODO: Navigate to exhibitor details` (غير مكتملة)

**الكود الحالي**:
```dart
final exhibitors = [
  {'name': 'مؤسسة الأسنان المتقدمة', 'category': 'معدات', 'booth': 'A-101'},
  // ... بيانات وهمية
];
```

**الحل المطلوب**:
1. إنشاء `ExhibitionService` في `lib/services/exhibition_service.dart`
2. إضافة API endpoints في `api_constants.dart`:
   - `GET /api/v1/exhibitions/halls` - للحصول على قاعات المعرض
   - `GET /api/v1/exhibitions/exhibitors` - للحصول على المعارضين
   - `GET /api/v1/exhibitions/exhibitors/:id` - للحصول على تفاصيل معرض
3. ربط الصفحة بالخدمة الجديدة
4. **ملاحظة**: يوجد API للـ Exhibitions في الخادم (`ExhibitionsModule`) - يحتاج ربط فقط

---

### 3. 👥 صفحة المتحدثين (Speakers Screen)
**الملف**: `lib/features/speakers/presentation/speakers_screen.dart`

**الحالة**: ❌ **صفحة فارغة - "قريباً"**

**المشاكل**:
- الصفحة تعرض فقط رسالة "قريباً" (Coming Soon)
- لا يوجد أي محتوى أو وظائف
- لا يوجد استدعاء لـ API

**الكود الحالي**:
```dart
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 100),
          Text('قريباً'), // رسالة فقط
        ],
      ),
    ),
  );
}
```

**الحل المطلوب**:
1. إنشاء `SpeakerService` في `lib/services/speaker_service.dart`
2. إضافة API endpoints في `api_constants.dart`:
   - `GET /api/v1/events/speakers` - للحصول على قائمة المتحدثين
   - `GET /api/v1/events/speakers/:id` - للحصول على تفاصيل متحدث
3. تطوير واجهة المستخدم لعرض قائمة المتحدثين
4. **ملاحظة**: يوجد API للـ Speakers في الخادم (`SpeakerController`) - يحتاج تطوير الصفحة وربطها

---

### 4. 📅 صفحة الجدول الزمني (Schedule Screen)
**الملف**: `lib/features/schedule/presentation/schedule_screen.dart`

**الحالة**: ❌ **صفحة فارغة - "قريباً"**

**المشاكل**:
- الصفحة تعرض فقط رسالة "قريباً"
- لا يوجد أي محتوى أو وظائف
- لا يوجد استدعاء لـ API

**الكود الحالي**:
```dart
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          Icon(Icons.schedule_outlined, size: 100),
          Text('قريباً'), // رسالة فقط
        ],
      ),
    ),
  );
}
```

**الحل المطلوب**:
1. إنشاء `ScheduleService` في `lib/services/schedule_service.dart`
2. إضافة API endpoints في `api_constants.dart`:
   - `GET /api/v1/events/conferences/:id/sessions` - للحصول على جلسات المؤتمر
   - `GET /api/v1/events/sessions` - للحصول على جميع الجلسات
   - `GET /api/v1/events/sessions/:id` - للحصول على تفاصيل جلسة
3. تطوير واجهة المستخدم لعرض الجدول الزمني (Calendar/Timeline)
4. **ملاحظة**: يوجد API للـ Sessions في الخادم (`SessionController`) - يحتاج تطوير الصفحة وربطها

---

### 5. 🎓 صفحة الدورات (Courses Screen)
**الملف**: `lib/features/courses/presentation/courses_screen.dart`

**الحالة**: ❌ **صفحة فارغة - "قريباً"**

**المشاكل**:
- الصفحة تعرض فقط رسالة "قريباً"
- لا يوجد أي محتوى أو وظائف
- لا يوجد استدعاء لـ API

**الكود الحالي**:
```dart
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 100),
          Text('قريباً'), // رسالة فقط
        ],
      ),
    ),
  );
}
```

**الحل المطلوب**:
1. إنشاء `CourseService` في `lib/services/course_service.dart`
2. إضافة API endpoints في `api_constants.dart`:
   - `GET /api/v1/events?type=COURSE` - للحصول على الدورات
   - `GET /api/v1/events/:id` - للحصول على تفاصيل دورة
3. تطوير واجهة المستخدم لعرض قائمة الدورات
4. **ملاحظة**: يوجد API للـ Events (بما فيها الدورات) في الخادم (`EventController`) - يحتاج تطوير الصفحة وربطها

---

### 6. 📚 صفحة تفاصيل الدورة (Course Details Screen)
**الملف**: `lib/features/courses/presentation/course_details_screen.dart`

**الحالة**: ❌ **بيانات وهمية - غير مربوطة**

**المشاكل**:
- يستخدم بيانات وهمية (Hardcoded)
- لا يوجد استدعاء لـ API
- زر التسجيل لا يربط بالخادم (يغير حالة محلية فقط)
- المعلومات مثل التاريخ والوقت والمدة جميعها وهمية

**الكود الحالي**:
```dart
// بيانات وهمية في الواجهة
_buildInfoCard(icon: Icons.calendar_today, label: 'التاريخ', value: '26 أكتوبر'),
_buildInfoCard(icon: Icons.access_time, label: 'الوقت', value: '10:00 ص'),
// ... المزيد من البيانات الوهمية

// زر التسجيل لا يربط بالخادم
onPressed: () {
  setState(() {
    isRegistered = !isRegistered; // تغيير حالة محلية فقط
  });
}
```

**الحل المطلوب**:
1. ربط الصفحة بـ `CourseService` أو `EventService`
2. جلب بيانات الدورة من API باستخدام `courseId`
3. ربط زر التسجيل بـ `RegistrationService`
4. عرض بيانات حقيقية من الخادم

---

## 📊 ملخص الإحصائيات

| الفئة | العدد | النسبة |
|------|------|-------|
| **صفحات مربوطة** | 12 | 66.7% |
| **صفحات غير مربوطة** | 6 | 33.3% |
| **المجموع** | 18 | 100% |

---

## 🔧 الأولويات للإصلاح

### أولوية عالية (High Priority)
1. **صفحة المعرض التجاري (Exhibition)** - API موجود في الخادم، يحتاج ربط فقط
2. **صفحة المتحدثين (Speakers)** - API موجود في الخادم، يحتاج تطوير واجهة وربط
3. **صفحة الجدول الزمني (Schedule)** - API موجود في الخادم، يحتاج تطوير واجهة وربط
4. **صفحة الدورات (Courses)** - API موجود في الخادم، يحتاج تطوير واجهة وربط

### أولوية متوسطة (Medium Priority)
5. **صفحة تفاصيل الدورة (Course Details)** - يحتاج ربط بالخدمات الموجودة

### أولوية منخفضة (Low Priority)
6. **صفحة معرض الصور (Gallery)** - يحتاج تطوير API في الخادم أولاً

---

## 📝 التوصيات

### 1. تطوير الخدمات المفقودة
- إنشاء `GalleryService` (بعد تطوير API في الخادم)
- إنشاء `ExhibitionService`
- إنشاء `SpeakerService`
- إنشاء `ScheduleService`
- إنشاء أو توسيع `CourseService` (يمكن استخدام `EventService`)

### 2. إضافة API Endpoints في `api_constants.dart`
```dart
// Gallery endpoints (بعد تطوير API)
static const String galleryEndpoint = '/api/v1/gallery';
static const String galleryAlbumsEndpoint = '$galleryEndpoint/albums';

// Exhibition endpoints
static const String exhibitionsEndpoint = '/api/v1/exhibitions';
static const String exhibitorsEndpoint = '$exhibitionsEndpoint/exhibitors';

// Speaker endpoints
static const String speakersEndpoint = '/api/v1/events/speakers';

// Schedule/Session endpoints
static const String sessionsEndpoint = '/api/v1/events/sessions';

// Course endpoints (can use events endpoint with type filter)
static const String coursesEndpoint = '/api/v1/events?type=COURSE';
```

### 3. تطوير واجهات المستخدم
- تطوير واجهة صفحة المتحدثين مع قائمة وقدرة البحث
- تطوير واجهة صفحة الجدول الزمني مع تقويم وجدول زمني
- تطوير واجهة صفحة الدورات مع قائمة وفلترة
- تحسين واجهة صفحة تفاصيل الدورة

### 4. اختبار التكامل
- اختبار جميع الصفحات بعد الربط
- التأكد من معالجة الأخطاء
- التأكد من حالة التحميل (Loading States)
- التأكد من معالجة البيانات الفارغة (Empty States)

---

## 📌 ملاحظات إضافية

1. **API Endpoints في الخادم**:
   - ✅ Exhibitions API موجود (`/api/v1/exhibitions/*`)
   - ✅ Speakers API موجود (`/api/v1/events/speakers/*`)
   - ✅ Sessions API موجود (`/api/v1/events/sessions/*`)
   - ✅ Events API موجود (`/api/v1/events/*`) - يمكن استخدامه للدورات
   - ❌ Gallery API غير موجود - يحتاج تطوير

2. **الخدمات الموجودة**:
   - `ConferenceService` - للربط بالمؤتمرات
   - `RegistrationService` - للربط بالتسجيلات
   - `ProfileService` - للربط بالملف الشخصي
   - `NotificationService` - للربط بالإشعارات

3. **الخدمات المطلوبة**:
   - `GalleryService` (جديد)
   - `ExhibitionService` (جديد)
   - `SpeakerService` (جديد)
   - `ScheduleService` أو `SessionService` (جديد)
   - `CourseService` أو توسيع `EventService` (جديد/توسيع)

---

## ✅ الخطوات التالية

1. **المرحلة الأولى**: ربط الصفحات التي لها API جاهز في الخادم
   - Exhibition Screen
   - Speakers Screen
   - Schedule Screen
   - Courses Screen

2. **المرحلة الثانية**: تطوير API للـ Gallery في الخادم ثم ربطه

3. **المرحلة الثالثة**: اختبار شامل للتكامل

---

**تم إنشاء التقرير بواسطة**: AI Assistant  
**آخر تحديث**: $(date)

