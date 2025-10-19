import 'package:flutter/material.dart';


import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/models.dart';

class VerificationStatusBadge extends StatelessWidget {
  final VerificationStatus status;
  final bool showIcon;
  final double? fontSize;

  const VerificationStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getIcon(),
              color: _getTextColor(),
              size: fontSize != null ? fontSize! + 2 : 18,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            status.displayName,
            style: (fontSize != null 
                ? AppTextStyles.bodyMedium.copyWith(fontSize: fontSize)
                : AppTextStyles.bodyMedium
            ).copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green.withValues(alpha: 0.1);
      case VerificationStatus.underReview:
        return Colors.orange.withValues(alpha: 0.1);
      case VerificationStatus.rejected:
        return Colors.red.withValues(alpha: 0.1);
      case VerificationStatus.unverified:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green.withValues(alpha: 0.3);
      case VerificationStatus.underReview:
        return Colors.orange.withValues(alpha: 0.3);
      case VerificationStatus.rejected:
        return Colors.red.withValues(alpha: 0.3);
      case VerificationStatus.unverified:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green[700]!;
      case VerificationStatus.underReview:
        return Colors.orange[700]!;
      case VerificationStatus.rejected:
        return Colors.red[700]!;
      case VerificationStatus.unverified:
        return Colors.grey[700]!;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case VerificationStatus.verified:
        return Icons.verified;
      case VerificationStatus.underReview:
        return Icons.schedule;
      case VerificationStatus.rejected:
        return Icons.cancel;
      case VerificationStatus.unverified:
        return Icons.help_outline;
    }
  }
}

class VerificationStatusCard extends StatelessWidget {
  final VerificationStatus status;
  final String? rejectionReason;
  final DateTime? lastUpdated;

  const VerificationStatusCard({
    super.key,
    required this.status,
    this.rejectionReason,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIcon(),
                color: _getTextColor(),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  status.displayName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: _getTextColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getDescription(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: _getTextColor().withValues(alpha: 0.8),
            ),
          ),
          if (rejectionReason != null && status == VerificationStatus.rejected) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سبب الرفض:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rejectionReason!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (lastUpdated != null) ...[
            const SizedBox(height: 8),
            Text(
              'آخر تحديث: ${_formatDate(lastUpdated!)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: _getTextColor().withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getDescription() {
    switch (status) {
      case VerificationStatus.verified:
        return 'تم توثيق حسابك بنجاح. يمكنك الآن الاشتراك في المؤتمر والفعاليات المصاحبة.';
      case VerificationStatus.underReview:
        return 'طلب التوثيق قيد المراجعة. سيتم إشعارك عند اكتمال المراجعة.';
      case VerificationStatus.rejected:
        return 'تم رفض طلب التوثيق. يرجى مراجعة الأسباب أدناه وتصحيح البيانات.';
      case VerificationStatus.unverified:
        return 'لم يتم توثيق حسابك بعد. يرجى إكمال البيانات المطلوبة وإرسال طلب التوثيق.';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getBackgroundColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green.withValues(alpha: 0.05);
      case VerificationStatus.underReview:
        return Colors.orange.withValues(alpha: 0.05);
      case VerificationStatus.rejected:
        return Colors.red.withValues(alpha: 0.05);
      case VerificationStatus.unverified:
        return Colors.grey.withValues(alpha: 0.05);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green.withValues(alpha: 0.2);
      case VerificationStatus.underReview:
        return Colors.orange.withValues(alpha: 0.2);
      case VerificationStatus.rejected:
        return Colors.red.withValues(alpha: 0.2);
      case VerificationStatus.unverified:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green[700]!;
      case VerificationStatus.underReview:
        return Colors.orange[700]!;
      case VerificationStatus.rejected:
        return Colors.red[700]!;
      case VerificationStatus.unverified:
        return Colors.grey[700]!;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case VerificationStatus.verified:
        return Icons.verified;
      case VerificationStatus.underReview:
        return Icons.schedule;
      case VerificationStatus.rejected:
        return Icons.cancel;
      case VerificationStatus.unverified:
        return Icons.help_outline;
    }
  }
}
