import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<void> saveBadgeBytesImpl(Uint8List bytes, String fileName) async {
  final result = await ImageGallerySaver.saveImage(
    bytes,
    quality: 95,
    name: fileName,
  );

  final success =
      (result is Map && result['isSuccess'] == true) || result == true;
  if (!success) {
    throw Exception('تعذر حفظ الصورة، تأكد من منح الأذونات للتخزين');
  }
}

