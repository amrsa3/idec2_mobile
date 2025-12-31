# 🗺️ خريطة استخدام وتبعيات نظام المصادقة

**تاريخ الإنشاء:** 29 ديسمبر 2025  
**الغرض:** توثيق جميع نقاط الاستدعاء لتسهيل عملية الترحيل

---

## 📊 ملخص الاستخدام

| المكون                            | إجمالي الاستخدامات | الملفات المستخدمة |
| --------------------------------- | ------------------ | ----------------- |
| `compatibleAuthProvider`          | 19                 | انظر القسم أدناه  |
| `CompatibleAuthService.instance`  | 10+                | انظر القسم أدناه  |
| `enhancedAuthProvider`            | 11                 | انظر القسم أدناه  |
| `UnifiedTokenManager.instance`    | 15+                | انظر القسم أدناه  |
| `EnhancedSessionManager.instance` | 10+                | انظر القسم أدناه  |
| `AuthFacade.instance`             | 0                  | غير مستخدم عملياً |

---

## 📁 تفاصيل الاستخدام

### 1️⃣ `compatibleAuthProvider` (19 ملف)

#### شاشات المصادقة:

| الملف                                                     | نوع الاستخدام                         |
| --------------------------------------------------------- | ------------------------------------- |
| `features/auth/presentation/login_screen.dart`            | `ref.watch()` و `ref.read().notifier` |
| `features/auth/presentation/register_screen.dart`         | `ref.watch()` و `ref.read().notifier` |
| `features/auth/presentation/otp_verification_screen.dart` | `ref.watch()` و `ref.read().notifier` |
| `features/auth/presentation/forgot_password_screen.dart`  | `ref.read().notifier`                 |
| `features/auth/presentation/reset_password_screen.dart`   | `ref.read().notifier`                 |

#### شاشات الملف الشخصي:

| الملف                                                                     | نوع الاستخدام                 |
| ------------------------------------------------------------------------- | ----------------------------- |
| `features/profile/presentation/screens/profile_main_screen.dart`          | `ref.watch()` للحصول على user |
| `features/profile/presentation/screens/user_documents_viewer_screen.dart` | `ref.watch()`                 |
| `features/profile/providers/profile_provider.dart`                        | import و استخدام              |

#### شاشات الرئيسية:

| الملف                                             | نوع الاستخدام |
| ------------------------------------------------- | ------------- |
| `features/home/presentation/home_screen_new.dart` | `ref.watch()` |
| `features/home/presentation/home_screen_old.dart` | `ref.watch()` |

#### شاشات أخرى:

| الملف                                                           | نوع الاستخدام |
| --------------------------------------------------------------- | ------------- |
| `features/language/presentation/language_selection_screen.dart` | `ref.watch()` |
| `features/chat/chat_wrapper_page.dart`                          | `ref.watch()` |

#### الخدمات والـ Widgets:

| الملف                                                    | نوع الاستخدام  |
| -------------------------------------------------------- | -------------- |
| `shared/widgets/profile_side_drawer.dart`                | `ref.watch()`  |
| `shared/widgets/verification_notification_banner.dart`   | `ref.watch()`  |
| `shared/services/verification_notification_service.dart` | `ref.read()`   |
| `services/push_notification_service.dart`                | `ref.read()`   |
| `core/router/app_router.dart`                            | redirect logic |

---

### 2️⃣ `CompatibleAuthService.instance` (10+ ملف)

| الملف                                                                     | نوع الاستخدام                  |
| ------------------------------------------------------------------------- | ------------------------------ |
| `services/compatible_auth_service.dart`                                   | التعريف الأصلي                 |
| `services/auth_facade.dart`                                               | `_compatAuth` delegate         |
| `services/lazy_loading_service.dart`                                      | للتحقق من المصادقة             |
| `features/profile/services/profile_service.dart`                          | 6 استخدامات للحصول على user ID |
| `features/profile/providers/smart_file_provider.dart`                     | للتحقق من المصادقة             |
| `features/profile/presentation/screens/user_documents_viewer_screen.dart` | استخدام مباشر                  |

---

### 3️⃣ `enhancedAuthProvider` (11 ملف)

| الملف                                                      | نوع الاستخدام                        | ملاحظات                     |
| ---------------------------------------------------------- | ------------------------------------ | --------------------------- |
| `main.dart`                                                | `ref.watch()` و `ref.listenManual()` | **حرج** - يجب ترحيله بعناية |
| `features/splash/presentation/splash_screen.dart`          | التحقق من حالة المصادقة              |                             |
| `features/home/presentation/home_screen_new.dart`          | `ref.watch()`                        |                             |
| `features/home/presentation/home_screen_old.dart`          | `ref.watch()`                        |                             |
| `features/schedule/presentation/event_details_screen.dart` | `ref.watch()`                        |                             |
| `features/profile/providers/profile_provider.dart`         | اشتقاق الحالة                        |                             |
| `shared/widgets/app_drawer.dart`                           | `ref.watch()`                        |                             |
| `services/push_notification_service.dart`                  | `ref.read()`                         |                             |
| `providers/enhanced_auth_provider.dart`                    | التعريف الأصلي                       |                             |
| `providers/enhanced_auth_provider_v2.dart`                 | التعريف البديل                       |                             |

---

### 4️⃣ `UnifiedTokenManager.instance` (15+ ملف)

| الملف                                        | نوع الاستخدام                                   |
| -------------------------------------------- | ----------------------------------------------- |
| `services/unified_token_manager.dart`        | التعريف الأصلي                                  |
| `services/compatible_auth_service.dart`      | إدارة التوكنات الرئيسية                         |
| `services/auth_service.dart`                 | `saveTokens()`, `logout()`, `hasValidSession()` |
| `services/auth_facade.dart`                  | delegate                                        |
| `services/enhanced_dio_service_v2.dart`      | للحصول على access token                         |
| `services/enhanced_session_manager.dart`     | تكامل الجلسات                                   |
| `services/enhanced_token_interceptor.dart`   | interceptor للـ headers                         |
| `services/silent_token_refresh_service.dart` | تجديد صامت                                      |
| `services/payment_service.dart`              | authentication header                           |
| `services/migration_service.dart`            | ترحيل التوكنات                                  |
| `services/system_test_service.dart`          | اختبار النظام                                   |
| `providers/web_auth_provider.dart`           | للويب                                           |
| `features/chat/chat_wrapper_page.dart`       | للحصول على توكن للـ chat                        |

---

### 5️⃣ `EnhancedSessionManager.instance` (10+ ملف)

| الملف                                        | نوع الاستخدام                                  |
| -------------------------------------------- | ---------------------------------------------- |
| `services/enhanced_session_manager.dart`     | التعريف الأصلي                                 |
| `main.dart`                                  | `sessionExpiredStream` للاستماع لانتهاء الجلسة |
| `services/auth_service.dart`                 | `endSession()`                                 |
| `services/auth_facade.dart`                  | delegate                                       |
| `services/enhanced_dio_service_v2.dart`      | تحديث النشاط                                   |
| `services/enhanced_token_interceptor.dart`   | تكامل الجلسات                                  |
| `services/silent_token_refresh_service.dart` | تكامل                                          |
| `services/migration_service.dart`            | ترحيل الجلسات                                  |
| `services/system_test_service.dart`          | اختبار النظام                                  |
| `providers/web_auth_provider.dart`           | للويب                                          |

---

## 🔗 رسم بياني للتبعيات

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
├─────────────────────────────────────────────────────────────────────┤
│  login_screen.dart ──────────┐                                       │
│  register_screen.dart ───────┤                                       │
│  otp_verification_screen.dart┼──► compatibleAuthProvider            │
│  forgot_password_screen.dart ┤                                       │
│  reset_password_screen.dart ─┘                                       │
│                                                                      │
│  profile_main_screen.dart ───┐                                       │
│  home_screen_new.dart ───────┼──► compatibleAuthProvider +          │
│  home_screen_old.dart ───────┘    enhancedAuthProvider              │
│                                                                      │
│  main.dart ──────────────────────► enhancedAuthProvider +           │
│                                    EnhancedSessionManager           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         PROVIDER LAYER                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  compatibleAuthProvider ─────────► CompatibleAuthNotifier           │
│          │                                   │                       │
│          │                                   ▼                       │
│          │                         CompatibleAuthService.instance   │
│          │                                   │                       │
│          ▼                                   │                       │
│  enhancedAuthProvider ──► AuthState (freezed)                       │
│          │                                   │                       │
│          │                                   │                       │
└──────────┼───────────────────────────────────┼──────────────────────┘
           │                                   │
           ▼                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         SERVICE LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  CompatibleAuthService ─────┬────► UnifiedTokenManager              │
│          │                  │              │                         │
│          │                  │              ├──► PlatformStorageService│
│          │                  │              │                         │
│          │                  └────► EnhancedSessionManager           │
│          │                                 │                         │
│          │                                 ├──► connectivity        │
│          │                                 │                         │
│          ▼                                 ▼                         │
│  EnhancedDioServiceV2 ◄────────── enhanced_token_interceptor        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 خطة الترحيل المقترحة

### الترتيب حسب الأولوية والتبعيات:

#### المرحلة 1: إنشاء البنية الجديدة (لا تبعيات)

```
lib/core/auth/
├── auth_state.dart           # freezed states
├── auth_exceptions.dart      # custom exceptions
├── auth_repository.dart      # API only
├── token_manager.dart        # wrapper for UnifiedTokenManager
└── session_manager.dart      # wrapper for EnhancedSessionManager
```

#### المرحلة 2: إنشاء الخدمة الموحدة

```
lib/core/auth/
└── auth_service.dart         # uses auth_repository + token_manager
```

#### المرحلة 3: إنشاء المُزود الموحد

```
lib/core/auth/
└── auth_provider.dart        # StateNotifierProvider
```

#### المرحلة 4: طبقة التوافق

```
lib/core/auth/
└── auth_compat.dart          # compatibility layer for migration
```

#### المرحلة 5: ترحيل تدريجي للشاشات

1. شاشات العرض فقط (home_screen, profile_main_screen)
2. شاشات المصادقة (login, register, otp)
3. الخدمات الحساسة (main.dart, app_router)

---

## ⚠️ نقاط حرجة يجب مراعاتها

### نقاط التكامل الحساسة:

| الملف                             | السبب                       | الخطر    |
| --------------------------------- | --------------------------- | -------- |
| `main.dart`                       | نقطة الدخول، استماع للجلسات | 🔴 عالي  |
| `app_router.dart`                 | توجيه المصادقة              | 🔴 عالي  |
| `enhanced_token_interceptor.dart` | كل طلبات API                | 🔴 عالي  |
| `push_notification_service.dart`  | ربط FCM بالمستخدم           | 🟡 متوسط |
| `profile_service.dart`            | 6 استخدامات مباشرة          | 🟡 متوسط |

### التبعيات الدائرية المحتملة:

- `CompatibleAuthService` → `UnifiedTokenManager` → `EnhancedSessionManager`
- `EnhancedDioServiceV2` → `UnifiedTokenManager` (للـ token)
- `enhanced_token_interceptor` → `UnifiedTokenManager` +
  `EnhancedSessionManager`

### الاعتبارات الخاصة بالمنصات:

- **الويب**: يستخدم `web_auth_provider.dart` بشكل إضافي
- **المحمول**: يعتمد على `flutter_secure_storage`

---

## 📋 قائمة فحص ما قبل الترحيل

- [ ] التأكد من وجود جميع الاختبارات
- [ ] التأكد من عمل جميع العمليات الحالية
- [ ] توثيق السلوك المتوقع لكل عملية
- [ ] إنشاء نسخة احتياطية

---

_تم إنشاء هذا الملف في 29 ديسمبر 2025_
