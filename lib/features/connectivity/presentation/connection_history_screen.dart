import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/connection_status.dart';
import '../../../providers/language_provider.dart';
import '../../../services/advanced_connectivity_service.dart';
import '../../../shared/widgets/custom_button.dart';

class ConnectionHistoryScreen extends ConsumerStatefulWidget {
  const ConnectionHistoryScreen({super.key});

  @override
  ConsumerState<ConnectionHistoryScreen> createState() => _ConnectionHistoryScreenState();
}

class _ConnectionHistoryScreenState extends ConsumerState<ConnectionHistoryScreen> {
  final AdvancedConnectivityService _connectivityService = AdvancedConnectivityService();
  List<ConnectionHistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = _connectivityService.getConnectionHistory();
    });
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح السجل'),
        content: const Text('هل أنت متأكد من رغبتك في مسح سجل الاتصال؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              _connectivityService.clearConnectionHistory();
              _loadHistory();
              Navigator.of(context).pop();
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRTL = ref.watch(isRTLProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'سجل الاتصال',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: AppColors.primary,
            ),
            onPressed: _loadHistory,
          ),
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear_all,
                color: AppColors.error,
              ),
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: _history.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد سجل اتصال',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض سجل الاتصال هنا بعد إجراء اختبارات الاتصال',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        return _buildHistoryCard(entry);
      },
    );
  }

  Widget _buildHistoryCard(ConnectionHistoryEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with timestamp and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimestamp(entry.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusIndicator(entry.isConnected),
              ],
            ),
            const SizedBox(height: 12),
            
            // Connection details
            _buildDetailRow(
              'جودة الاتصال',
              _getQualityText(entry.quality),
              _getQualityColor(entry.quality),
            ),
            _buildDetailRow(
              'نوع الشبكة',
              _getNetworkTypeText(entry.networkType),
              AppColors.textSecondary,
            ),
            _buildDetailRow(
              'الخادم',
              entry.serverReachable ? 'متصل' : 'غير متصل',
              entry.serverReachable ? AppColors.success : AppColors.error,
            ),
            if (entry.responseTime != null)
              _buildDetailRow(
                'زمن الاستجابة',
                '${entry.responseTime!.inMilliseconds}ms',
                AppColors.textSecondary,
              ),
            
            // Test results summary
            if (entry.testResults.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'نتائج الاختبارات:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.testResults.map((test) => _buildTestResult(test)),
            ],
            
            // Error message if exists
            if (entry.error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.error!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isConnected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected ? AppColors.success : AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isConnected ? 'متصل' : 'غير متصل',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResult(ConnectionTestResult test) {
    final isSuccess = test.status == TestStatus.success;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? AppColors.success : AppColors.error,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              test.testName,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (test.duration != null)
            Text(
              '${test.duration!.inMilliseconds}ms',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getQualityText(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return 'ممتاز';
      case ConnectionQuality.good:
        return 'جيد';
      case ConnectionQuality.fair:
        return 'مقبول';
      case ConnectionQuality.poor:
        return 'ضعيف';
      case ConnectionQuality.none:
        return 'لا يوجد اتصال';
    }
  }

  Color _getQualityColor(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return AppColors.success;
      case ConnectionQuality.good:
        return AppColors.primary;
      case ConnectionQuality.fair:
        return AppColors.warning;
      case ConnectionQuality.poor:
        return AppColors.error;
      case ConnectionQuality.none:
        return AppColors.textSecondary;
    }
  }

  String _getNetworkTypeText(ConnectivityResult type) {
    switch (type) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'بيانات الجوال';
      case ConnectivityResult.ethernet:
        return 'إيثرنت';
      case ConnectivityResult.none:
        return 'غير متصل';
      default:
        return 'غير معروف';
    }
  }
}