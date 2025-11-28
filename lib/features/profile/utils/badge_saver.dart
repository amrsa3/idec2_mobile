import 'dart:typed_data';

import 'badge_saver_io.dart'
    if (dart.library.html) 'badge_saver_web.dart';

Future<void> saveBadgeBytes(Uint8List bytes, String fileName) {
  return saveBadgeBytesImpl(bytes, fileName);
}

