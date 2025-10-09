import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';

/// خدمة اختيار الصور من المعرض أو الكاميرا
class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// عرض حوار اختيار مصدر الصورة (معرض أو كاميرا)
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.selectImageSource ?? 'اختر مصدر الصورة',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: Text(localizations.gallery ?? 'المعرض'),
                onTap: () {
                  Navigator.of(context).pop('gallery');
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: Text(localizations.camera ?? 'الكاميرا'),
                onTap: () {
                  Navigator.of(context).pop('camera');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel ?? 'إلغاء'),
            ),
          ],
        );
      },
    );

    if (result == null) return null;

    if (result == 'gallery') {
      return await pickFromGallery();
    } else if (result == 'camera') {
      return await pickFromCamera();
    }

    return null;
  }

  /// اختيار صورة من المعرض
  static Future<File?> pickFromGallery() async {
    try {
      // طلب إذن الوصول للمعرض
      PermissionStatus permission;
      if (Platform.isAndroid) {
        // للأندرويد 13+ نستخدم photos، وللإصدارات الأقدم نستخدم storage
        final androidInfo = await Permission.photos.status;
        if (androidInfo == PermissionStatus.permanentlyDenied) {
          permission = await Permission.storage.request();
        } else {
          permission = await Permission.photos.request();
        }
      } else {
        // لـ iOS
        permission = await Permission.photos.request();
      }
      
      if (!permission.isGranted) {
        debugPrint('Gallery permission denied. Status: $permission');
        return null;
      }

      debugPrint('Gallery permission granted. Attempting to pick image...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('Image picked successfully from gallery: ${image.path}');
        return File(image.path);
      } else {
        debugPrint('No image selected from gallery');
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// اختيار صورة من الكاميرا
  static Future<File?> pickFromCamera() async {
    try {
      // طلب إذن الوصول للكاميرا
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        debugPrint('Camera permission denied. Status: $permission');
        return null;
      }

      debugPrint('Camera permission granted. Attempting to take photo...');

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('Photo taken successfully: ${image.path}');
        return File(image.path);
      } else {
        debugPrint('No photo taken');
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// التحقق من صحة ملف الصورة
  static bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  /// التحقق من حجم الملف (الحد الأقصى 5 ميجابايت)
  static bool isValidFileSize(File file, {int maxSizeInMB = 5}) {
    final fileSizeInBytes = file.lengthSync();
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  /// التحقق من جميع شروط الملف
  static String? validateImageFile(File file, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (!isValidImageFile(file)) {
      return localizations.invalidImageFormat ?? 'صيغة الصورة غير صحيحة. يرجى اختيار صورة بصيغة JPG أو PNG';
    }
    
    if (!isValidFileSize(file)) {
      return localizations.imageTooLarge ?? 'حجم الصورة كبير جداً. الحد الأقصى 5 ميجابايت';
    }
    
    return null;
  }
}