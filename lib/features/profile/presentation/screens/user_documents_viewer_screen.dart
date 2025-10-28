import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/file_model.dart';
import '../../../../services/dio_service.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/smart_file_provider.dart';

/// صفحة احترافية لعرض المستندات المرفوعة من المستخدم
class UserDocumentsViewerScreen extends ConsumerStatefulWidget {
  const UserDocumentsViewerScreen({super.key});

  @override
  ConsumerState<UserDocumentsViewerScreen> createState() =>
      _UserDocumentsViewerScreenState();
}

class _UserDocumentsViewerScreenState
    extends ConsumerState<UserDocumentsViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(userDocumentsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'مستنداتي',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              ref.invalidate(userDocumentsProvider);
            },
          ),
        ],
      ),
      body: documentsAsync.when(
        data: (documents) => _buildDocumentsList(documents),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildDocumentsList(List<FileModel> documents) {
    if (documents.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return _buildDocumentCard(documents[index]);
      },
    );
  }

  Widget _buildDocumentCard(FileModel document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewDocument(document),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail or Icon
              _buildThumbnailOrIcon(document),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.displayName ?? document.originalName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFileTypeLabel(document.mimeType),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatFileSize(document.fileSize),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                color: AppColors.primary,
                onPressed: () => _viewDocument(document),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد مستندات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم برفع المستندات أولاً',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل المستندات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(userDocumentsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewDocument(FileModel document) async {
    if (mounted) {
      final isImage = document.mimeType.toLowerCase().contains('image');

      if (isImage) {
        // للصور: عرض في PhotoView
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ImageFullScreenViewer(document: document),
          ),
        );
      } else {
        // للملفات الأخرى (PDF, Word, etc): مشاركة الملف
        await _shareDocument(document);
      }
    }
  }

  Future<void> _shareDocument(FileModel document) async {
    try {
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('غير مصرح بالوصول'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // بناء رابط تنزيل الملف
      final fileUrl =
          '${ApiConstants.baseUrl}/api/v1/files/${document.id}/download?token=$token';

      // عرض خيارات المشاركة
      await Share.share(
        '${document.displayName ?? document.originalName}\n\n$fileUrl',
        subject: document.displayName ?? document.originalName,
      );

      debugPrint('✅ تم مشاركة الملف: ${document.originalName}');
    } catch (e) {
      debugPrint('❌ خطأ في مشاركة الملف: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Color _getDocumentColor(String mimeType) {
    if (mimeType.contains('image')) return Colors.blue;
    if (mimeType.contains('pdf')) return Colors.red;
    return AppColors.primary;
  }

  IconData _getDocumentIcon(String mimeType) {
    if (mimeType.contains('image')) return Icons.image_outlined;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  String _getFileTypeLabel(String mimeType) {
    if (mimeType.contains('image')) return 'صورة';
    if (mimeType.contains('pdf')) return 'ملف PDF';
    if (mimeType.contains('word')) return 'مستند Word';
    if (mimeType.contains('excel')) return 'جدول Excel';
    return mimeType;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildThumbnailOrIcon(FileModel document) {
    final isImage = document.mimeType.toLowerCase().contains('image');

    if (isImage) {
      // للصور: عرض الصورة المصغرة باستخدام Dio مع authentication
      return _ThumbnailImage(fileId: document.id);
    }

    // للملفات الأخرى: عرض الأيقونة العادية
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: _getDocumentColor(document.mimeType).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getDocumentIcon(document.mimeType),
        color: _getDocumentColor(document.mimeType),
        size: 28,
      ),
    );
  }
}

/// Widget لعرض الصورة المصغرة مع authentication
class _ThumbnailImage extends StatefulWidget {
  final String fileId;

  const _ThumbnailImage({required this.fileId});

  @override
  State<_ThumbnailImage> createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<_ThumbnailImage> {
  Uint8List? _thumbnailBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    try {
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final dio = EnhancedDioServiceV2.instance.dio;

      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/v1/files/${widget.fileId}/thumbnail',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data != null && response.data is List<int>) {
        if (mounted) {
          setState(() {
            _thumbnailBytes = Uint8List.fromList(response.data);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading thumbnail: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: null,
            ),
          ),
        ),
      );
    }

    if (_thumbnailBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _thumbnailBytes!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      );
    }

    // Fallback للأيقونة العادية
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_outlined,
        color: Colors.blue,
        size: 28,
      ),
    );
  }
}

/// عرض صورة كامل الشاشة
class _ImageFullScreenViewer extends StatefulWidget {
  final FileModel document;

  const _ImageFullScreenViewer({required this.document});

  @override
  State<_ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<_ImageFullScreenViewer> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _error = 'غير مصرح';
          _isLoading = false;
        });
        return;
      }

      final dio = EnhancedDioServiceV2.instance.dio;

      // استخدام endpoint الصحيح مع authentication
      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/v1/files/${widget.document.id}/download',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data is List<int>) {
        setState(() {
          _imageBytes = Uint8List.fromList(response.data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'فشل تحميل الصورة';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading image: $e');
      setState(() {
        _error = 'حدث خطأ أثناء تحميل الصورة';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.document.displayName ?? widget.document.originalName,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadImage,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_imageBytes == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد بيانات للصورة',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.memory(
          _imageBytes!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
