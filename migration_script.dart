import 'dart:io';

/// سكريبت الترحيل التلقائي لتحديث جميع المراجع من النظام القديم إلى الجديد
/// Automatic migration script to update all references from old system to new
class MigrationScript {
  static const Map<String, String> _importReplacements = {
    "import '../../../providers/auth_provider.dart';": "import '../../../providers/enhanced_auth_provider.dart';",
    "import '../../providers/auth_provider.dart';": "import '../../providers/enhanced_auth_provider.dart';",
    "import '../../../../providers/auth_provider.dart';": "import '../../../../providers/enhanced_auth_provider.dart';",
    "import 'providers/auth_provider.dart';": "import 'providers/enhanced_auth_provider.dart';",
    "import '../providers/auth_provider.dart';": "import '../providers/enhanced_auth_provider.dart';",
    
    "import '../../../services/dio_service.dart';": "import '../../../services/enhanced_dio_service_v2.dart';",
    "import '../../services/dio_service.dart';": "import '../../services/enhanced_dio_service_v2.dart';",
    "import 'services/dio_service.dart';": "import 'services/enhanced_dio_service_v2.dart';",
    "import '../services/dio_service.dart';": "import '../services/enhanced_dio_service_v2.dart';",
    
    "import '../../../services/token_manager.dart';": "import '../../../services/unified_token_manager.dart';",
    "import '../../services/token_manager.dart';": "import '../../services/unified_token_manager.dart';",
    "import 'services/token_manager.dart';": "import 'services/unified_token_manager.dart';",
    "import '../services/token_manager.dart';": "import '../services/unified_token_manager.dart';",
    
    "import '../../../services/session_manager.dart';": "import '../../../services/enhanced_session_manager.dart';",
    "import '../../services/session_manager.dart';": "import '../../services/enhanced_session_manager.dart';",
    "import 'services/session_manager.dart';": "import 'services/enhanced_session_manager.dart';",
    "import '../services/session_manager.dart';": "import '../services/enhanced_session_manager.dart';",
  };

  static const Map<String, String> _codeReplacements = {
    // AuthProvider references
    "authProvider": "enhancedAuthProvider",
    "ref.watch(authProvider)": "ref.watch(enhancedAuthProvider)",
    "ref.read(authProvider)": "ref.read(enhancedAuthProvider)",
    "ref.listen(authProvider": "ref.listen(enhancedAuthProvider",
    
    // DioService references
    "DioService.instance": "EnhancedDioServiceV2.instance",
    "DioService()": "EnhancedDioServiceV2.instance",
    
    // TokenManager references
    "TokenManager.instance": "UnifiedTokenManager.instance",
    "TokenManager()": "UnifiedTokenManager.instance",
    
    // SessionManager references
    "SessionManager.instance": "EnhancedSessionManager.instance",
    "SessionManager()": "EnhancedSessionManager.instance",
  };

  static Future<void> migrateProject() async {
    print('🚀 بدء عملية الترحيل التلقائي...');
    print('🚀 Starting automatic migration...');
    
    final libDir = Directory('lib');
    if (!await libDir.exists()) {
      print('❌ مجلد lib غير موجود');
      print('❌ lib directory not found');
      return;
    }

    await _migrateDirectory(libDir);
    
    print('✅ تم الانتهاء من عملية الترحيل بنجاح');
    print('✅ Migration completed successfully');
  }

  static Future<void> _migrateDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _migrateFile(entity);
      }
    }
  }

  static Future<void> _migrateFile(File file) async {
    try {
      String content = await file.readAsString();
      String originalContent = content;
      
      // Replace imports
      for (final entry in _importReplacements.entries) {
        content = content.replaceAll(entry.key, entry.value);
      }
      
      // Replace code references
      for (final entry in _codeReplacements.entries) {
        content = content.replaceAll(entry.key, entry.value);
      }
      
      // Only write if content changed
      if (content != originalContent) {
        await file.writeAsString(content);
        print('✅ تم تحديث: ${file.path}');
        print('✅ Updated: ${file.path}');
      }
    } catch (e) {
      print('❌ خطأ في تحديث ${file.path}: $e');
      print('❌ Error updating ${file.path}: $e');
    }
  }

  static Future<void> validateMigration() async {
    print('🔍 التحقق من صحة الترحيل...');
    print('🔍 Validating migration...');
    
    final libDir = Directory('lib');
    if (!await libDir.exists()) {
      print('❌ مجلد lib غير موجود');
      return;
    }

    List<String> oldReferences = [];
    
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = await entity.readAsString();
        
        // Check for old imports
        if (content.contains("import '../../../providers/auth_provider.dart';") ||
            content.contains("import '../../providers/auth_provider.dart';") ||
            content.contains("import 'providers/auth_provider.dart';") ||
            content.contains("import '../providers/auth_provider.dart';")) {
          oldReferences.add('${entity.path}: Old auth_provider import found');
        }
        
        if (content.contains("import '../../../services/dio_service.dart';") ||
            content.contains("import '../../services/dio_service.dart';") ||
            content.contains("import 'services/dio_service.dart';") ||
            content.contains("import '../services/dio_service.dart';")) {
          oldReferences.add('${entity.path}: Old dio_service import found');
        }
        
        if (content.contains("import '../../../services/token_manager.dart';") ||
            content.contains("import '../../services/token_manager.dart';") ||
            content.contains("import 'services/token_manager.dart';") ||
            content.contains("import '../services/token_manager.dart';")) {
          oldReferences.add('${entity.path}: Old token_manager import found');
        }
      }
    }
    
    if (oldReferences.isEmpty) {
      print('✅ لم يتم العثور على مراجع قديمة');
      print('✅ No old references found');
    } else {
      print('⚠️ تم العثور على مراجع قديمة:');
      print('⚠️ Old references found:');
      for (final ref in oldReferences) {
        print('  - $ref');
      }
    }
  }
}

void main() async {
  await MigrationScript.migrateProject();
  await MigrationScript.validateMigration();
}