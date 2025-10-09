import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/error_reporting_service.dart';
import '../../../shared/widgets/custom_button.dart';

class ErrorReportingScreen extends ConsumerStatefulWidget {
  final String? errorMessage;
  final String? stackTrace;
  final Map<String, dynamic>? connectionTestData;

  const ErrorReportingScreen({
    super.key,
    this.errorMessage,
    this.stackTrace,
    this.connectionTestData,
  });

  @override
  ConsumerState<ErrorReportingScreen> createState() => _ErrorReportingScreenState();
}

class _ErrorReportingScreenState extends ConsumerState<ErrorReportingScreen> {
  final _errorReportingService = ErrorReportingService();
  final _descriptionController = TextEditingController();
  
  bool _isGenerating = false;
  bool _isSharing = false;
  ErrorReport? _generatedReport;
  String? _reportText;

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);

    try {
      final additionalData = <String, dynamic>{};
      
      if (_descriptionController.text.isNotEmpty) {
        additionalData['userDescription'] = _descriptionController.text;
      }

      // Add connection test data if available
      if (widget.connectionTestData != null) {
        additionalData['connectionTestData'] = widget.connectionTestData;
      }

      final report = await _errorReportingService.generateErrorReport(
        errorMessage: widget.errorMessage,
        stackTrace: widget.stackTrace,
        additionalData: additionalData,
      );

      final reportText = _getFormattedReportWithConnectionData(report);

      setState(() {
        _generatedReport = report;
        _reportText = reportText;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to generate error report: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _shareReport() async {
    if (_generatedReport == null) return;

    setState(() => _isSharing = true);

    try {
      await _errorReportingService.shareErrorReport(_generatedReport!);
      _showSuccessSnackBar('Error report shared successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to share error report: $e');
    } finally {
      setState(() => _isSharing = false);
    }
  }

  Future<void> _copyToClipboard() async {
    if (_reportText == null) return;

    try {
      await Clipboard.setData(ClipboardData(text: _reportText!));
      _showSuccessSnackBar('Error report copied to clipboard');
    } catch (e) {
      _showErrorSnackBar('Failed to copy to clipboard');
    }
  }

  String _getFormattedReportWithConnectionData(ErrorReport report) {
    final buffer = StringBuffer();
    
    // Start with basic error report
    buffer.writeln('=== تقرير الأخطاء الشامل ===');
    buffer.writeln('التاريخ والوقت: ${DateTime.now().toString()}');
    buffer.writeln();
    
    if (widget.errorMessage != null) {
      buffer.writeln('رسالة الخطأ: ${widget.errorMessage}');
      buffer.writeln();
    }

    // Add connection test data if available
    if (widget.connectionTestData != null) {
      buffer.writeln('=== تفاصيل اختبار الاتصال ===');
      _addConnectionTestDetails(buffer, widget.connectionTestData!);
    }

    // Add basic error report details
    buffer.writeln('=== معلومات النظام ===');
    buffer.writeln('نظام التشغيل: ${report.deviceInfo?.operatingSystem ?? 'غير معروف'}');
    buffer.writeln('إصدار التطبيق: ${report.appInfo?.version ?? 'غير معروف'}');
    buffer.writeln('طراز الجهاز: ${report.deviceInfo?.model ?? 'غير معروف'}');
    buffer.writeln();

    if (widget.stackTrace != null) {
      buffer.writeln('=== تتبع المكدس ===');
      buffer.writeln(widget.stackTrace);
      buffer.writeln();
    }

    return buffer.toString();
  }

  void _addConnectionTestDetails(StringBuffer buffer, Map<String, dynamic> testData) {
    // Add connection status
    if (testData['connectionStatus'] != null) {
      final status = testData['connectionStatus'];
      buffer.writeln('حالة الاتصال العامة: ${status['isConnected'] ? 'متصل' : 'غير متصل'}');
      buffer.writeln('جودة الاتصال: ${_getQualityTextArabic(status['quality'])}');
      if (status['error'] != null) {
        buffer.writeln('خطأ الاتصال: ${status['error']}');
      }
      buffer.writeln();
    }

    // Add network information
    if (testData['networkInfo'] != null) {
      final networkInfo = testData['networkInfo'];
      buffer.writeln('--- معلومات الشبكة ---');
      buffer.writeln('نوع الاتصال: ${_getConnectionTypeArabic(networkInfo['connectionType'])}');
      if (networkInfo['networkName'] != null) {
        buffer.writeln('اسم الشبكة: ${networkInfo['networkName']}');
      }
      if (networkInfo['ipAddress'] != null) {
        buffer.writeln('عنوان IP: ${networkInfo['ipAddress']}');
      }
      if (networkInfo['signalStrength'] != null) {
        buffer.writeln('قوة الإشارة: ${networkInfo['signalStrength']}%');
      }
      buffer.writeln();
    }

    // Add server information
    if (testData['serverInfo'] != null) {
      final serverInfo = testData['serverInfo'];
      buffer.writeln('--- معلومات الخادم ---');
      buffer.writeln('عنوان الخادم: ${serverInfo['serverUrl']}');
      buffer.writeln('المنفذ: ${serverInfo['port']}');
      buffer.writeln('حالة الخادم: ${serverInfo['isReachable'] ? 'متاح' : 'غير متاح'}');
      if (serverInfo['responseTime'] != null) {
        buffer.writeln('زمن الاستجابة: ${serverInfo['responseTime']} مللي ثانية');
      }
      if (serverInfo['lastError'] != null) {
        buffer.writeln('آخر خطأ في الخادم: ${serverInfo['lastError']}');
      }
      buffer.writeln();
    }

    // Add test results
    if (testData['testResults'] != null) {
      buffer.writeln('--- نتائج الاختبارات التفصيلية ---');
      final testResults = testData['testResults'] as List;
      for (final test in testResults) {
        buffer.writeln('اختبار: ${_getTestNameArabic(test['testName'])}');
        buffer.writeln('الحالة: ${_getTestStatusArabic(test['status'])}');
        if (test['result'] != null) {
          buffer.writeln('النتيجة: ${test['result']}');
        }
        if (test['error'] != null) {
          buffer.writeln('الخطأ: ${test['error']}');
        }
        if (test['duration'] != null) {
          buffer.writeln('المدة: ${test['duration']} مللي ثانية');
        }
        buffer.writeln('---');
      }
      buffer.writeln();
    }

    // Add speed test results
    if (testData['speedTestResult'] != null) {
      final speedTest = testData['speedTestResult'];
      buffer.writeln('--- نتائج اختبار السرعة ---');
      buffer.writeln('سرعة التحميل: ${speedTest['downloadSpeed']} Mbps');
      buffer.writeln('سرعة الرفع: ${speedTest['uploadSpeed']} Mbps');
      buffer.writeln('البينغ: ${speedTest['ping']} ms');
      buffer.writeln('التذبذب: ${speedTest['jitter']} ms');
      buffer.writeln();
    }

    // Add all collected errors
    if (testData['errors'] != null) {
      final errors = testData['errors'] as List;
      if (errors.isNotEmpty) {
        buffer.writeln('--- جميع الأخطاء المكتشفة ---');
        for (final error in errors) {
          buffer.writeln('نوع الخطأ: ${error['type']}');
          buffer.writeln('رسالة الخطأ: ${error['message']}');
          if (error['status'] != null) {
            buffer.writeln('حالة الاختبار: ${error['status']}');
          }
          if (error['duration'] != null) {
            buffer.writeln('مدة الاختبار: ${error['duration']} مللي ثانية');
          }
          buffer.writeln('وقت الخطأ: ${error['timestamp']}');
          buffer.writeln('---');
        }
        buffer.writeln();
      }
    }
  }

  String _getQualityTextArabic(String? quality) {
    switch (quality) {
      case 'ConnectionQuality.excellent': return 'ممتاز';
      case 'ConnectionQuality.good': return 'جيد';
      case 'ConnectionQuality.fair': return 'مقبول';
      case 'ConnectionQuality.poor': return 'ضعيف';
      case 'ConnectionQuality.none': return 'لا يوجد اتصال';
      default: return quality ?? 'غير محدد';
    }
  }

  String _getConnectionTypeArabic(String? type) {
    switch (type) {
      case 'ConnectivityResult.wifi': return 'واي فاي';
      case 'ConnectivityResult.mobile': return 'بيانات الجوال';
      case 'ConnectivityResult.ethernet': return 'إيثرنت';
      case 'ConnectivityResult.bluetooth': return 'بلوتوث';
      case 'ConnectivityResult.vpn': return 'VPN';
      case 'ConnectivityResult.other': return 'أخرى';
      case 'ConnectivityResult.none': return 'لا يوجد اتصال';
      default: return type ?? 'غير محدد';
    }
  }

  String _getTestNameArabic(String testName) {
    switch (testName) {
      case 'Internet Connectivity': return 'اتصال الإنترنت';
      case 'DNS Resolution': return 'حل DNS';
      case 'Server Ping': return 'بينغ الخادم';
      case 'API Endpoints': return 'نقاط API';
      default: return testName;
    }
  }

  String _getTestStatusArabic(String status) {
    switch (status) {
      case 'TestStatus.success': return 'نجح';
      case 'TestStatus.failed': return 'فشل';
      case 'TestStatus.timeout': return 'انتهت المهلة';
      case 'TestStatus.running': return 'قيد التشغيل';
      case 'TestStatus.pending': return 'في الانتظار';
      default: return status;
    }
  }

  Widget _buildConnectionTestSummary() {
    if (widget.connectionTestData == null) return const SizedBox.shrink();
    
    final testData = widget.connectionTestData!;
    final errors = testData['errors'] as List? ?? [];
    final testResults = testData['testResults'] as List? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connection Status
        if (testData['connectionStatus'] != null) ...[
          _buildSummaryRow(
            'Connection Status',
            testData['connectionStatus']['isConnected'] ? 'Connected' : 'Disconnected',
            testData['connectionStatus']['isConnected'] ? AppColors.success : AppColors.error,
          ),
        ],
        
        // Test Results Summary
        if (testResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Test Results:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          ...testResults.map((test) => _buildSummaryRow(
            _getTestNameArabic(test['testName']),
            _getTestStatusArabic(test['status']),
            _getStatusColor(test['status']),
          )),
        ],
        
        // Errors Summary
        if (errors.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Errors Found: ${errors.length}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 4),
          ...errors.take(3).map((error) => _buildSummaryRow(
            error['type'],
            'Error detected',
            AppColors.error,
          )),
          if (errors.length > 3)
            Text(
              '... and ${errors.length - 3} more errors',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
        
        // Speed Test Summary
        if (testData['speedTestResult'] != null) ...[
          const SizedBox(height: 8),
          Text(
            'Speed Test:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          _buildSummaryRow(
            'Download Speed',
            '${testData['speedTestResult']['downloadSpeed']} Mbps',
            AppColors.success,
          ),
          _buildSummaryRow(
            'Upload Speed',
            '${testData['speedTestResult']['uploadSpeed']} Mbps',
            AppColors.success,
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'TestStatus.success': return AppColors.success;
      case 'TestStatus.failed': return AppColors.error;
      case 'TestStatus.timeout': return AppColors.warning;
      case 'TestStatus.running': return AppColors.primary;
      case 'TestStatus.pending': return AppColors.textSecondary;
      default: return AppColors.textSecondary;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  size: 32,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error Report Generator',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Generate a detailed report to help technical support',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Error Information
            if (widget.errorMessage != null) ...[
              Card(
                color: AppColors.error.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(
                            'Error Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.errorMessage!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Connection Test Summary
            if (widget.connectionTestData != null) ...[
              Card(
                color: AppColors.info.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.network_check, color: AppColors.info),
                          const SizedBox(width: 8),
                          Text(
                            'Connection Test Summary',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildConnectionTestSummary(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // User Description
            Text(
              'Describe what you were doing (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please describe what you were trying to do when this error occurred...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (_) => _generateReport(),
            ),
            const SizedBox(height: 24),

            // Generate Report Button
            if (_generatedReport == null)
              CustomButton(
                text: 'Generate Report',
                onPressed: _isGenerating ? null : _generateReport,
                isLoading: _isGenerating,
                isFullWidth: true,
                icon: Icons.description,
              ),

            // Report Preview
            if (_reportText != null) ...[
              const SizedBox(height: 24),
              Text(
                'Report Preview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _reportText!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Copy',
                      onPressed: _copyToClipboard,
                      backgroundColor: AppColors.secondary,
                      icon: Icons.copy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Share',
                      onPressed: _isSharing ? null : _shareReport,
                      isLoading: _isSharing,
                      icon: Icons.share,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Information Card
            Card(
              color: AppColors.info.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: AppColors.info),
                        const SizedBox(width: 8),
                        Text(
                          'What\'s included in the report?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• Error message and stack trace'),
                    const Text('• Device and app information'),
                    const Text('• Complete connection test results'),
                    const Text('• Server ping and API endpoint errors'),
                    const Text('• Network connectivity details'),
                    const Text('• Speed test results (if available)'),
                    const Text('• All DioException and connection errors'),
                    const Text('• Timestamp and user description'),
                    const SizedBox(height: 8),
                    Text(
                      'No personal data or sensitive information is included.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
