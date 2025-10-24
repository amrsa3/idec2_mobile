import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// حالة عملية الرفع والحفظ
enum UploadState {
  preparing, // التحضير
  uploading, // رفع الملفات
  saving, // حفظ البيانات
  success, // نجح
  error, // فشل
}

/// بيانات تقدم الملف
class FileProgressData {
  final String fileName;
  final double progress;
  final bool isSuccess;
  final String? errorMessage;

  FileProgressData({
    required this.fileName,
    this.progress = 0.0,
    this.isSuccess = false,
    this.errorMessage,
  });

  FileProgressData copyWith({
    String? fileName,
    double? progress,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return FileProgressData(
      fileName: fileName ?? this.fileName,
      progress: progress ?? this.progress,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider لحالة الرفع
final uploadProgressProvider =
    StateNotifierProvider<UploadProgressNotifier, UploadProgressState>((ref) {
  return UploadProgressNotifier();
});

/// حالة تقدم الرفع
class UploadProgressState {
  final UploadState state;
  final String message;
  final double overallProgress;
  final List<FileProgressData> files;
  final String? errorMessage;
  final bool canRetry;

  UploadProgressState({
    this.state = UploadState.preparing,
    this.message = 'جاري التحضير...',
    this.overallProgress = 0.0,
    this.files = const [],
    this.errorMessage,
    this.canRetry = false,
  });

  UploadProgressState copyWith({
    UploadState? state,
    String? message,
    double? overallProgress,
    List<FileProgressData>? files,
    String? errorMessage,
    bool? canRetry,
  }) {
    return UploadProgressState(
      state: state ?? this.state,
      message: message ?? this.message,
      overallProgress: overallProgress ?? this.overallProgress,
      files: files ?? this.files,
      errorMessage: errorMessage ?? this.errorMessage,
      canRetry: canRetry ?? this.canRetry,
    );
  }
}

/// Notifier لإدارة حالة الرفع
class UploadProgressNotifier extends StateNotifier<UploadProgressState> {
  UploadProgressNotifier() : super(UploadProgressState());

  void setPreparing() {
    state = state.copyWith(
      state: UploadState.preparing,
      message: 'جاري التحضير...',
      overallProgress: 0.0,
    );
  }

  void setUploading(List<FileProgressData> files) {
    state = state.copyWith(
      state: UploadState.uploading,
      message: 'جاري رفع الملفات...',
      files: files,
    );
  }

  void updateFileProgress(int index, FileProgressData fileData) {
    final updatedFiles = List<FileProgressData>.from(state.files);
    if (index < updatedFiles.length) {
      updatedFiles[index] = fileData;
    }

    // حساب التقدم الإجمالي
    final totalProgress =
        updatedFiles.fold(0.0, (sum, file) => sum + file.progress) /
            updatedFiles.length;

    state = state.copyWith(
      files: updatedFiles,
      overallProgress: totalProgress,
    );
  }

  void setSaving() {
    state = state.copyWith(
      state: UploadState.saving,
      message: 'جاري حفظ البيانات...',
      overallProgress: 0.8, // 80% بعد رفع الملفات
    );
  }

  void setSuccess() {
    state = state.copyWith(
      state: UploadState.success,
      message: 'تم الحفظ بنجاح!',
      overallProgress: 1.0,
    );
  }

  void setError(String errorMessage, {bool canRetry = true}) {
    state = state.copyWith(
      state: UploadState.error,
      message: 'حدث خطأ أثناء الحفظ',
      errorMessage: errorMessage,
      canRetry: canRetry,
    );
  }

  void reset() {
    state = UploadProgressState();
  }
}

/// رسالة منبثقة احترافية لعرض تقدم الرفع والحفظ
class UploadProgressDialog extends ConsumerWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onSuccess;

  const UploadProgressDialog({
    super.key,
    this.onRetry,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadProgressProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(uploadState),

            // Content
            _buildContent(uploadState),

            // Actions
            _buildActions(context, ref, uploadState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UploadProgressState state) {
    Color headerColor;
    IconData headerIcon;

    switch (state.state) {
      case UploadState.preparing:
        headerColor = AppColors.primary;
        headerIcon = Icons.settings;
        break;
      case UploadState.uploading:
        headerColor = AppColors.primary;
        headerIcon = Icons.upload;
        break;
      case UploadState.saving:
        headerColor = AppColors.primary;
        headerIcon = Icons.save;
        break;
      case UploadState.success:
        headerColor = AppColors.success;
        headerIcon = Icons.check_circle;
        break;
      case UploadState.error:
        headerColor = AppColors.error;
        headerIcon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: headerColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              headerIcon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(state.state),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UploadProgressState state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // شريط التقدم الإجمالي
          _buildOverallProgress(state),

          const SizedBox(height: 20),

          // تفاصيل الملفات
          if (state.files.isNotEmpty) ...[
            _buildFilesList(state),
            const SizedBox(height: 16),
          ],

          // رسالة الخطأ
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallProgress(UploadProgressState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم الإجمالي',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(state.overallProgress * 100).toStringAsFixed(1)}%',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: state.overallProgress,
          backgroundColor: AppColors.lightGray,
          valueColor: AlwaysStoppedAnimation<Color>(
            state.state == UploadState.error
                ? AppColors.error
                : AppColors.primary,
          ),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildFilesList(UploadProgressState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل الملفات',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...state.files.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildFileItem(file),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFileItem(FileProgressData file) {
    Color iconColor;
    IconData iconData;

    if (file.isSuccess) {
      iconColor = AppColors.success;
      iconData = Icons.check_circle;
    } else if (file.errorMessage != null) {
      iconColor = AppColors.error;
      iconData = Icons.error;
    } else {
      iconColor = AppColors.primary;
      iconData = Icons.upload;
    }

    return Row(
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            file.fileName,
            style: AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        if (file.isSuccess)
          Text(
            '100%',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          )
        else if (file.errorMessage != null)
          Text(
            'فشل',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          )
        else
          Text(
            '${(file.progress * 100).toStringAsFixed(1)}%',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildActions(
      BuildContext context, WidgetRef ref, UploadProgressState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          if (state.state == UploadState.error && state.canRetry) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry?.call();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (state.state == UploadState.success) {
                  onSuccess?.call();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: state.state == UploadState.success
                    ? AppColors.success
                    : AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                state.state == UploadState.success ? 'متابعة' : 'إغلاق',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(UploadState state) {
    switch (state) {
      case UploadState.preparing:
        return 'تحضير البيانات';
      case UploadState.uploading:
        return 'رفع الملفات';
      case UploadState.saving:
        return 'حفظ البيانات';
      case UploadState.success:
        return 'تم بنجاح';
      case UploadState.error:
        return 'حدث خطأ';
    }
  }
}

/// دالة مساعدة لإظهار رسالة التقدم
Future<void> showUploadProgressDialog({
  required BuildContext context,
  required Future<void> Function() uploadFunction,
  VoidCallback? onSuccess,
}) async {
  final uploadNotifier =
      ProviderScope.containerOf(context).read(uploadProgressProvider.notifier);

  // إظهار الرسالة المنبثقة
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UploadProgressDialog(
      onRetry: () {
        showUploadProgressDialog(
          context: context,
          uploadFunction: uploadFunction,
          onSuccess: onSuccess,
        );
      },
      onSuccess: onSuccess,
    ),
  );

  try {
    // تنفيذ عملية الرفع
    await uploadFunction();
  } catch (e) {
    uploadNotifier.setError(e.toString());
  }
}
