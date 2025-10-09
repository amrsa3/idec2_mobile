import 'package:flutter/material.dart';

import '../../models/profile_rule_model.dart';

/// شريط حالة التوثيق
class VerificationStatusBanner extends StatelessWidget {
  final ProfileStatus status;
  final String? rejectionReason;

  const VerificationStatusBanner({
    super.key,
    required this.status,
    this.rejectionReason,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

    return Container(
      padding: const EdgeInsets.all(16),
      color: statusInfo.color.withOpacity(0.1),
      child: Row(
        children: [
          Icon(statusInfo.icon, color: statusInfo.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusInfo.title,
                  style: TextStyle(
                    color: statusInfo.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (rejectionReason != null &&
                    status == ProfileStatus.rejected) ...[
                  const SizedBox(height: 4),
                  Text(
                    rejectionReason!,
                    style: TextStyle(
                      color: statusInfo.color.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo() {
    switch (status) {
      case ProfileStatus.unverified:
        return _StatusInfo(
          title: 'الملف الشخصي غير موثق',
          icon: Icons.info_outline,
          color: Colors.grey,
        );
      case ProfileStatus.pendingVerification:
        return _StatusInfo(
          title: 'الملف الشخصي قيد المراجعة',
          icon: Icons.hourglass_empty,
          color: Colors.orange,
        );
      case ProfileStatus.verified:
        return _StatusInfo(
          title: 'الملف الشخصي موثق',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case ProfileStatus.rejected:
        return _StatusInfo(
          title: 'الملف الشخصي مرفوض',
          icon: Icons.cancel,
          color: Colors.red,
        );
    }
  }
}

class _StatusInfo {
  final String title;
  final IconData icon;
  final Color color;

  _StatusInfo({
    required this.title,
    required this.icon,
    required this.color,
  });
}
