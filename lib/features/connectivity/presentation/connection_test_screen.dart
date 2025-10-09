import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/connection_status.dart';
import '../../../providers/language_provider.dart';
import '../../../services/advanced_connectivity_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../connection/presentation/server_config_screen.dart';
import '../../connection/presentation/error_reporting_screen.dart';
import 'connection_history_screen.dart';

class ConnectionTestScreen extends ConsumerStatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  ConsumerState<ConnectionTestScreen> createState() =>
      _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends ConsumerState<ConnectionTestScreen>
    with TickerProviderStateMixin {
  final AdvancedConnectivityService _connectivityService =
      AdvancedConnectivityService();

  ConnectionStatus? _connectionStatus;
  SpeedTestResult? _speedTestResult;
  bool _isLoading = false;
  bool _isSpeedTesting = false;
  
  // متغيرات الفحص اليدوي
  bool _isManualTesting = false;
  bool _hasManualTested = false;
  String? _manualTestError;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _runConnectionTest();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _runConnectionTest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _connectivityService.getConnectionStatus();
      setState(() {
        _connectionStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = ConnectionStatus.initial().copyWith(
          error: e.toString(),
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _runSpeedTest() async {
    setState(() {
      _isSpeedTesting = true;
    });

    try {
      final result = await _connectivityService.performSpeedTest();
      setState(() {
        _speedTestResult = result;
        _isSpeedTesting = false;
      });
    } catch (e) {
      setState(() {
        _isSpeedTesting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في اختبار السرعة: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // دالة الفحص اليدوي الموثوق
  Future<void> _performManualTest() async {
    print('🔧 بدء الفحص اليدوي - زر منفصل');
    print('📊 حالة الفحص اليدوي: _isManualTesting=$_isManualTesting');
    
    // التحقق من أن الفحص اليدوي ليس قيد التشغيل
    if (_isManualTesting) {
      print('⚠️ الفحص اليدوي قيد التشغيل بالفعل، تجاهل الطلب');
      return;
    }

    // إعادة تعيين حالة الفحص اليدوي
    setState(() {
      _isManualTesting = true;
      _hasManualTested = false;
      _manualTestError = null;
    });
    
    print('✅ تم تحديث حالة الفحص اليدوي: _isManualTesting=true');

    try {
      print('🔍 بدء فحص الاتصال اليدوي...');
      
      // تشغيل فحص الاتصال العادي
      await _runConnectionTest();
      
      // إضافة تأخير قصير لإظهار النتائج
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _hasManualTested = true;
        _manualTestError = null;
      });
      
      print('✅ تم إكمال الفحص اليدوي بنجاح');
      
      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إكمال الفحص اليدوي بنجاح ✅'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
    } catch (e) {
      print('❌ خطأ في الفحص اليدوي: $e');
      setState(() {
        _manualTestError = e.toString();
        _hasManualTested = true;
      });
      
      // إظهار رسالة خطأ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الفحص اليدوي: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isManualTesting = false;
      });
      print('🏁 انتهى الفحص اليدوي: _isManualTesting=false');
    }
  }

  void _navigateToServerConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ServerConfigScreen(),
      ),
    );
  }

  void _navigateToConnectionHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConnectionHistoryScreen(),
      ),
    );
  }

  void _navigateToErrorReporting() {
    // Collect all connection test information and errors
    final Map<String, dynamic> connectionTestData = {
      'connectionStatus': _connectionStatus?.toJson(),
      'speedTestResult': _speedTestResult?.toJson(),
      'testResults': _connectionStatus?.testResults.map((test) => {
        'testName': test.testName,
        'status': test.status.toString(),
        'result': test.result,
        'error': test.error,
        'duration': test.duration?.inMilliseconds,
      }).toList(),
      'networkInfo': _connectionStatus?.networkInfo.toJson(),
      'serverInfo': _connectionStatus?.serverInfo.toJson(),
      'errors': _collectAllErrors(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ErrorReportingScreen(
          errorMessage: 'Connection Test Report',
          connectionTestData: connectionTestData,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _collectAllErrors() {
    final List<Map<String, dynamic>> errors = [];
    
    // Add connection status error if exists
    if (_connectionStatus?.error != null) {
      errors.add({
        'type': 'Connection Status Error',
        'message': _connectionStatus!.error!,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    // Add server info errors
    if (_connectionStatus?.serverInfo.lastError != null) {
      errors.add({
        'type': 'Server Error',
        'message': _connectionStatus!.serverInfo.lastError!,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    // Add test result errors
    if (_connectionStatus?.testResults != null) {
      for (final test in _connectionStatus!.testResults) {
        if (test.error != null) {
          errors.add({
            'type': 'Test Error - ${test.testName}',
            'message': test.error!,
            'status': test.status.toString(),
            'duration': test.duration?.inMilliseconds,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      }
    }

    return errors;
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
          'فحص الاتصال',
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
            onPressed: _isLoading ? null : _runConnectionTest,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _connectionStatus != null
              ? _buildConnectionView()
              : _buildErrorView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_find,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'جاري فحص الاتصال...',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى الانتظار',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionView() {
    final status = _connectionStatus!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildOverallStatusCard(status),
          const SizedBox(height: 16),
          _buildNetworkInfoCard(status.networkInfo),
          const SizedBox(height: 16),
          _buildServerInfoCard(status.serverInfo),
          const SizedBox(height: 16),
          _buildTestResultsCard(status.testResults),
          const SizedBox(height: 16),
          _buildSpeedTestCard(),
          const SizedBox(height: 16),
          _buildConnectionHistoryCard(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildOverallStatusCard(ConnectionStatus status) {
    final qualityColor = _getQualityColor(status.quality);
    final qualityText = _getQualityText(status.quality);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: qualityColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status.isConnected ? Icons.wifi : Icons.wifi_off,
                size: 40,
                color: qualityColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              status.isConnected ? 'متصل' : 'غير متصل',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: qualityColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              qualityText,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusIndicator(
                  'الشبكة',
                  status.networkInfo.connectionType != ConnectivityResult.none,
                ),
                _buildStatusIndicator(
                  'الخادم',
                  status.serverInfo.isReachable,
                ),
                _buildStatusIndicator(
                  'الإنترنت',
                  status.testResults.any((test) =>
                      test.testName == 'Internet Connectivity' &&
                      test.status == TestStatus.success),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive ? AppColors.success : AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkInfoCard(NetworkInfo networkInfo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.network_check,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'معلومات الشبكة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('نوع الاتصال',
                _getConnectionTypeText(networkInfo.connectionType)),
            if (networkInfo.networkName != null)
              _buildInfoRow('اسم الشبكة', networkInfo.networkName!),
            if (networkInfo.ipAddress != null)
              _buildInfoRow('عنوان IP', networkInfo.ipAddress!),
            if (networkInfo.signalStrength != null)
              _buildInfoRow('قوة الإشارة', '${networkInfo.signalStrength}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildServerInfoCard(ServerInfo serverInfo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.dns,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'معلومات الخادم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('عنوان الخادم', serverInfo.serverUrl),
            _buildInfoRow('المنفذ', serverInfo.port.toString()),
            _buildInfoRow(
              'الحالة',
              serverInfo.isReachable ? 'متاح' : 'غير متاح',
              valueColor:
                  serverInfo.isReachable ? AppColors.success : AppColors.error,
            ),
            if (serverInfo.responseTime != null)
              _buildInfoRow(
                'زمن الاستجابة',
                '${serverInfo.responseTime!.inMilliseconds} مللي ثانية',
              ),
            if (serverInfo.serverVersion != null)
              _buildInfoRow('إصدار الخادم', serverInfo.serverVersion!),
            if (serverInfo.lastError != null)
              _buildInfoRow(
                'آخر خطأ',
                serverInfo.lastError!,
                valueColor: AppColors.error,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultsCard(List<ConnectionTestResult> testResults) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'نتائج الاختبارات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...testResults.map((test) => _buildTestResultItem(test)),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultItem(ConnectionTestResult test) {
    final statusColor = _getTestStatusColor(test.status);
    final statusIcon = _getTestStatusIcon(test.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTestNameInArabic(test.testName),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (test.result != null)
                  Text(
                    test.result!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (test.error != null)
                  Text(
                    test.error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          if (test.duration != null)
            Text(
              '${test.duration!.inMilliseconds}ms',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeedTestCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.speed,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'اختبار السرعة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isSpeedTesting ? null : _runSpeedTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSpeedTesting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'ابدأ الاختبار',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_speedTestResult != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildSpeedMetric(
                      'التحميل',
                      '${_speedTestResult!.downloadSpeed.toStringAsFixed(1)} Mbps',
                      Icons.download,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSpeedMetric(
                      'الرفع',
                      '${_speedTestResult!.uploadSpeed.toStringAsFixed(1)} Mbps',
                      Icons.upload,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSpeedMetric(
                      'البينغ',
                      '${_speedTestResult!.ping} ms',
                      Icons.timer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSpeedMetric(
                      'التذبذب',
                      '${_speedTestResult!.jitter} ms',
                      Icons.graphic_eq,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text(
                    'اضغط "ابدأ الاختبار" لقياس سرعة الاتصال',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedMetric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionHistoryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'سجل الاتصال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _navigateToConnectionHistory,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'اضغط "عرض الكل" لمشاهدة سجل الاتصال',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Manual Test Button - زر الفحص اليدوي الموثوق
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: _isManualTesting ? 'جاري الفحص اليدوي...' : 'فحص يدوي موثوق 🔧',
            onPressed: _isManualTesting ? null : _performManualTest,
            icon: _isManualTesting ? Icons.hourglass_empty : Icons.build,
            backgroundColor: Colors.orange,
            isLoading: _isManualTesting,
          ),
        ),
        const SizedBox(height: 12),
        // Advanced Monitoring Button - زر المراقبة المتقدمة
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'مراقبة متقدمة 📊',
            onPressed: () => context.go(AppRoutes.connectionStatus),
            icon: Icons.analytics,
            backgroundColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        // Server Settings Button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'إعدادات الخادم ⚙️',
            onPressed: _navigateToServerConfig,
            icon: Icons.settings,
            backgroundColor: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        // Error Report Button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'إرسال تقرير الخطأ 📋',
            onPressed: _navigateToErrorReporting,
            icon: Icons.bug_report,
            type: ButtonType.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ في فحص الاتصال',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى المحاولة مرة أخرى',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _runConnectionTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getQualityColor(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return AppColors.success;
      case ConnectionQuality.good:
        return Colors.green;
      case ConnectionQuality.fair:
        return AppColors.warning;
      case ConnectionQuality.poor:
        return Colors.orange;
      case ConnectionQuality.none:
        return AppColors.error;
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

  String _getConnectionTypeText(ConnectivityResult type) {
    switch (type) {
      case ConnectivityResult.wifi:
        return 'واي فاي';
      case ConnectivityResult.mobile:
        return 'بيانات الجوال';
      case ConnectivityResult.ethernet:
        return 'إيثرنت';
      case ConnectivityResult.bluetooth:
        return 'بلوتوث';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'أخرى';
      case ConnectivityResult.none:
        return 'لا يوجد اتصال';
    }
  }

  Color _getTestStatusColor(TestStatus status) {
    switch (status) {
      case TestStatus.success:
        return AppColors.success;
      case TestStatus.failed:
        return AppColors.error;
      case TestStatus.timeout:
        return AppColors.warning;
      case TestStatus.running:
        return AppColors.primary;
      case TestStatus.pending:
        return AppColors.textSecondary;
    }
  }

  IconData _getTestStatusIcon(TestStatus status) {
    switch (status) {
      case TestStatus.success:
        return Icons.check_circle;
      case TestStatus.failed:
        return Icons.error;
      case TestStatus.timeout:
        return Icons.access_time;
      case TestStatus.running:
        return Icons.hourglass_empty;
      case TestStatus.pending:
        return Icons.pending;
    }
  }

  String _getTestNameInArabic(String testName) {
    switch (testName) {
      case 'Internet Connectivity':
        return 'اتصال الإنترنت';
      case 'DNS Resolution':
        return 'حل DNS';
      case 'Server Ping':
        return 'بينغ الخادم';
      case 'API Endpoints':
        return 'نقاط API';
      default:
        return testName;
    }
  }
}
