# 📄 صفحة عرض المستندات الاحترافية

صفحة احترافية لعرض جميع المستندات التي رفعها المستخدم.

## 📂 الموقع

```
mobile-app/lib/features/profile/presentation/screens/
└── user_documents_viewer_screen.dart
```

## 🎨 الميزات

- ✨ **تصميم احترافي**: تصميم نظيف وأنيق
- 🔍 **عرض مصنف**: فلترة حسب نوع الملف (صور، PDF، مرفقات)
- 📊 **معلومات تفصيلية**: اسم الملف، النوع، الحجم، تاريخ الرفع
- 🔄 **تحديث تلقائي**: زر لتحديث القائمة
- 👁️ **معاينة سريعة**: اضغط على أي مستند لرؤية تفاصيله
- 📱 **متجاوبة**: تعمل على جميع الأجهزة

## 🚀 الاستخدام

### 1. استيراد الصفحة

```dart
import 'package:idec/features/profile/presentation/screens/user_documents_viewer_screen.dart';
```

### 2. فتح الصفحة

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UserDocumentsViewerScreen(),
  ),
);

// أو مع GoRouter:
context.push('/documents');
```

## 📋 الشاشة

### القائمة العلوية (الفلترة)

- **الكل**: عرض جميع المستندات
- **صور**: عرض الصور فقط
- **مستندات PDF**: عرض ملفات PDF فقط
- **مرفقات**: عرض المرفقات الأخرى

### بطاقة المستند

كل مستند يعرض:

- 🎨 **أيقونة ملونة** حسب نوع الملف
- 📝 **اسم الملف**
- 📄 **نوع الملف** (صورة، PDF، ...)
- 💾 **حجم الملف**
- 👁️ **زر المعاينة**

### معاينة المستند

عند الضغط على المستند:

- عرض معلومات تفصيلية
- إمكانية فتح الملف
- أو إغلاق المعاينة

## 💻 مثال كامل

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الصفحة الرئيسية')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserDocumentsViewerScreen(),
              ),
            );
          },
          child: Text('عرض مستنداتي'),
        ),
      ),
    );
  }
}
```

## 🎨 الألوان حسب نوع الملف

| نوع الملف | اللون        | الأيقونة                           |
| --------- | ------------ | ---------------------------------- |
| صورة      | 🔵 أزرق      | `Icons.image_outlined`             |
| PDF       | 🔴 أحمر      | `Icons.picture_as_pdf_outlined`    |
| أخرى      | 🟦 الافتراضي | `Icons.insert_drive_file_outlined` |

## 📊 البيانات المعروضة

### في القائمة:

1. اسم الملف (displayName أو originalName)
2. نوع الملف (صورة، PDF، ...)
3. حجم الملف (KB أو MB)

### في المعاينة:

1. اسم الملف
2. نوع الملف
3. حجم الملف
4. تاريخ الرفع

## ⚙️ Provider المستخدم

```dart
// في smart_file_provider.dart
final userDocumentsProvider = FutureProvider<List<FileModel>>((ref) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  final categorizedFiles = await smartFileService.getAllFilesCategorized();

  List<FileModel> allDocuments = [];
  categorizedFiles.forEach((category, files) {
    allDocuments.addAll(files);
  });

  return allDocuments;
});
```

## 🎯 حالات الشاشة

### 1. التحميل

```dart
CircularProgressIndicator()
```

### 2. القائمة الفارغة

- أيقونة ملفات
- رسالة "لا توجد مستندات"

### 3. الخطأ

- أيقونة خطأ
- رسالة الخطأ
- زر "إعادة المحاولة"

### 4. نجاح

- قائمة المستندات
- فلترة

## 💡 نصائح

- ✅ استخدم للاستعراض فقط (View only)
- ✅ لا تستخدم لتعديل أو حذف الملفات
- ✅ الصفحة تقرأ البيانات من Provider تلقائياً
- ✅ تحديث البيانات بالضغط على زر Refresh

## 📱 مثال على الانتقال

```dart
// في ProfileMainScreen أو أي صفحة
ListTile(
  leading: Icon(Icons.folder),
  title: Text('مستنداتي'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserDocumentsViewerScreen(),
      ),
    );
  },
)
```

---

**صفحة احترافية وأنيقة لعرض مستندات المستخدم! 📄✨**
