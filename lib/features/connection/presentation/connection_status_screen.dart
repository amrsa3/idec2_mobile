import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/server_config_service.dart';
import '../../../shared/widgets/custom_button.dart';
import 'server_config_screen.dart';
import 'error_reporting_screen.dart';

// إضافة enum لحالات الاتصال
enum ConnectionState {
  initial,
  checking,
  connected,
  disconnected,
  error,
  timeout,
}

class ConnectionStatusScreen extends ConsumerStatefulWidget {
  const ConnectionStatusScreen({super.key});

  @override
  ConsumerState<ConnectionStatusScreen> createState() => _ConnectionStatusScreenState();
}

class _ConnectionStatusScreenState extends ConsumerState<ConnectionStatusScreen> {
  bool _internetConnected = false;
  bool _serverReachable = false;
  bool _isChecking = false;
  bool _hasChecked = false;
  int? _serverResponseTime;
  String? _errorMessage;
  String? _serverUrl;
  int? _serverPort;
  String? _connectionType;
  String? _testedEndpoint;
  DateTime? _lastTestTime;
  ConnectionState _connectionState = ConnectionState.initial;
  
  // متغيرات جديدة للفحص اليدوي
  bool _isManualTesting = false;
  bool _hasManualTested = false;
  String? _manualTestError;
  
  final _serverConfigService = ServerConfigService();

  @override
  void initState() {
    super.initState();
    // تشغيل فحص الاتصال تلقائياً عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnection();
    });
  }

  // إضافة timeout واضح لعملية فحص الاتصال
  Future<void> _checkConnection() async {
    print('🔄 بدء فحص الاتصال - تم الضغط على الزر');
    print('📊 الحالة الحالية: _isChecking=$_isChecking, _hasChecked=$_hasChecked');
    
    // التحقق من أن الفحص ليس قيد التشغيل بالفعل
    if (_isChecking) {
      print('⚠️ الفحص قيد التشغيل بالفعل، تجاهل الطلب');
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
      _hasChecked = false;
      _connectionState = ConnectionState.checking;
    });
    
    print('✅ تم تحديث الحالة: _isChecking=true');
    print('🔄 إعادة بناء الواجهة...');

    try {
      print('⏳ جاري تنفيذ فحص الاتصال...');
      // إضافة timeout عام لكامل العملية (30 ثانية)
      await _performConnectionCheck().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⏰ انتهت مهلة فحص الاتصال');
          throw TimeoutException('انتهت مهلة فحص الاتصال (30 ثانية)', const Duration(seconds: 30));
        },
      );
      print('✅ تم إكمال فحص الاتصال بنجاح');
    } on TimeoutException catch (e) {
      print('❌ خطأ: انتهت مهلة فحص الاتصال - $e');
      print('🔄 تحديث الحالة بسبب انتهاء المهلة...');
      setState(() {
        _internetConnected = false;
        _serverReachable = false;
        _serverResponseTime = null;
        _serverUrl = null;
        _serverPort = null;
        _connectionType = 'انتهت المهلة';
        _errorMessage = 'انتهت مهلة فحص الاتصال. يرجى المحاولة مرة أخرى.';
        _connectionState = ConnectionState.timeout;
      });
      print('✅ تم تحديث الحالة بعد انتهاء المهلة');
    } catch (e) {
      print('❌ خطأ في فحص الاتصال: $e');
      print('📋 تفاصيل الخطأ: ${e.runtimeType}');
      print('🔄 تحديث الحالة بسبب الخطأ...');
      setState(() {
        _internetConnected = false;
        _serverReachable = false;
        _serverResponseTime = null;
        _serverUrl = null;
        _serverPort = null;
        _connectionType = 'غير متصل';
        _errorMessage = 'فشل في اختبار الاتصال: $e';
        _connectionState = ConnectionState.error;
      });
      print('✅ تم تحديث الحالة بعد الخطأ');
    } finally {
      print('🏁 انتهاء فحص الاتصال - تحديث الحالة');
      print('🔄 تحديث الحالة النهائية...');
      setState(() {
        _isChecking = false;
        _hasChecked = true;
      });
      print('✅ تم تحديث الحالة النهائية: _isChecking=false, _hasChecked=true');
      print('🎯 إعادة بناء الواجهة النهائية...');
    }
  }

  Future<void> _performConnectionCheck() async {
    try {
      // فحص اتصال الإنترنت مع timeout
      final connectivityResult = await Connectivity().checkConnectivity().timeout(
        const Duration(seconds: 10),
        onTimeout: () => ConnectivityResult.none,
      );
      
      final internetConnected = connectivityResult != ConnectivityResult.none;
      
      // Get connection type string
      String connectionType = 'غير متصل';
      if (connectivityResult == ConnectivityResult.wifi) {
        connectionType = 'WiFi';
      } else if (connectivityResult == ConnectivityResult.mobile) {
        connectionType = 'بيانات الجوال';
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        connectionType = 'إيثرنت';
      }
      
      setState(() {
        _internetConnected = internetConnected;
        _connectionType = connectionType;
      });

      if (internetConnected) {
        // فحص اتصال الخادم مع timeout
        final serverConfig = await _serverConfigService.getServerConfig().timeout(
          const Duration(seconds: 5),
        );
        
        final testResult = await _serverConfigService.testServerConnection(serverConfig).timeout(
          const Duration(seconds: 15),
        );
        
        setState(() {
          _serverReachable = testResult.isReachable;
          _serverResponseTime = testResult.responseTime;
          _serverUrl = serverConfig.baseUrl;
          _serverPort = serverConfig.port;
          _testedEndpoint = testResult.endpoint;
          _lastTestTime = DateTime.now();
          
          if (testResult.isReachable) {
            _connectionState = ConnectionState.connected;
            _errorMessage = null;
          } else {
            _connectionState = ConnectionState.disconnected;
            _errorMessage = testResult.error ?? testResult.message;
          }
        });
      } else {
        setState(() {
          _serverReachable = false;
          _serverResponseTime = null;
          _serverUrl = null;
          _serverPort = null;
          _errorMessage = 'لا يوجد اتصال بالإنترنت';
          _connectionState = ConnectionState.disconnected;
        });
      }
    } catch (e) {
      rethrow; // إعادة رمي الخطأ ليتم التعامل معه في الدالة الرئيسية
    }
  }

  // دالة الفحص اليدوي الجديدة - منفصلة وموثوقة
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
      
      // فحص اتصال الإنترنت مع timeout قصير
      print('📡 فحص اتصال الإنترنت...');
      final connectivityResult = await Connectivity().checkConnectivity().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          print('⏰ انتهت مهلة فحص الاتصال');
          return ConnectivityResult.none;
        },
      );
      
      final internetConnected = connectivityResult != ConnectivityResult.none;
      print('📡 نتيجة فحص الإنترنت: $internetConnected');
      
      // تحديد نوع الاتصال
      String connectionType = 'غير متصل';
      if (connectivityResult == ConnectivityResult.wifi) {
        connectionType = 'WiFi';
      } else if (connectivityResult == ConnectivityResult.mobile) {
        connectionType = 'بيانات الجوال';
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        connectionType = 'إيثرنت';
      }
      
      // تحديث حالة الإنترنت
      setState(() {
        _internetConnected = internetConnected;
        _connectionType = connectionType;
      });
      print('✅ تم تحديث حالة الإنترنت: $_internetConnected');

      if (internetConnected) {
        print('🌐 الإنترنت متصل، فحص الخادم...');
        
        // فحص اتصال الخادم مع timeout قصير
        final serverConfig = await _serverConfigService.getServerConfig().timeout(
          const Duration(seconds: 5),
        );
        print('⚙️ تم الحصول على إعدادات الخادم: ${serverConfig.baseUrl}:${serverConfig.port}');
        
        final testResult = await _serverConfigService.testServerConnection(serverConfig).timeout(
          const Duration(seconds: 12),
        );
        print('🔗 نتيجة فحص الخادم: ${testResult.isReachable}');
        
        // تحديث حالة الخادم
        setState(() {
          _serverReachable = testResult.isReachable;
          _serverResponseTime = testResult.responseTime;
          _serverUrl = serverConfig.baseUrl;
          _serverPort = serverConfig.port;
          _testedEndpoint = testResult.endpoint;
          _lastTestTime = DateTime.now();
          _hasChecked = true; // تحديث الحالة العامة أيضاً
          
          if (testResult.isReachable) {
            _connectionState = ConnectionState.connected;
            _errorMessage = null;
            _manualTestError = null;
          } else {
            _connectionState = ConnectionState.disconnected;
            _errorMessage = testResult.error ?? testResult.message;
            _manualTestError = testResult.error ?? testResult.message;
          }
        });
        print('✅ تم تحديث حالة الخادم: $_serverReachable');
      } else {
        print('❌ لا يوجد اتصال بالإنترنت');
        setState(() {
          _serverReachable = false;
          _serverResponseTime = null;
          _serverUrl = null;
          _serverPort = null;
          _errorMessage = 'لا يوجد اتصال بالإنترنت';
          _manualTestError = 'لا يوجد اتصال بالإنترنت';
          _connectionState = ConnectionState.disconnected;
          _hasChecked = true;
        });
      }
      
      print('✅ تم إكمال الفحص اليدوي بنجاح');
      
    } catch (e) {
      print('❌ خطأ في الفحص اليدوي: $e');
      setState(() {
        _internetConnected = false;
        _serverReachable = false;
        _serverResponseTime = null;
        _serverUrl = null;
        _serverPort = null;
        _connectionType = 'خطأ في الفحص';
        _errorMessage = 'فشل الفحص اليدوي: $e';
        _manualTestError = 'فشل الفحص اليدوي: $e';
        _connectionState = ConnectionState.error;
        _hasChecked = true;
      });
    } finally {
      print('🏁 انتهاء الفحص اليدوي');
      setState(() {
        _isManualTesting = false;
        _hasManualTested = true;
      });
      print('✅ تم تحديث الحالة النهائية للفحص اليدوي');
    }
  }

  void _navigateToServerConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ServerConfigScreen(),
      ),
    );
  }

  void _navigateToErrorReporting() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ErrorReportingScreen(
          errorMessage: _errorMessage,
        ),
      ),
    );
  }

  // Helper methods for status display
  Color _getStatusColor() {
    switch (_connectionState) {
      case ConnectionState.initial:
        return AppColors.textSecondary;
      case ConnectionState.checking:
        return AppColors.accent;
      case ConnectionState.connected:
        return AppColors.success;
      case ConnectionState.disconnected:
        return AppColors.error;
      case ConnectionState.error:
        return AppColors.error;
      case ConnectionState.timeout:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    switch (_connectionState) {
      case ConnectionState.initial:
        return Icons.cloud_queue;
      case ConnectionState.checking:
        return Icons.cloud_sync;
      case ConnectionState.connected:
        return Icons.cloud_done;
      case ConnectionState.disconnected:
        return Icons.cloud_off;
      case ConnectionState.error:
        return Icons.error_outline;
      case ConnectionState.timeout:
        return Icons.timer_off;
    }
  }

  String _getStatusText() {
    switch (_connectionState) {
      case ConnectionState.initial:
        return 'جاهز لفحص الاتصال';
      case ConnectionState.checking:
        return 'جاري فحص الاتصال';
      case ConnectionState.connected:
        return 'جميع الأنظمة متصلة';
      case ConnectionState.disconnected:
        return 'مشاكل في الاتصال';
      case ConnectionState.error:
        return 'خطأ في فحص الاتصال';
      case ConnectionState.timeout:
        return 'انتهت مهلة الاتصال';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overallStatus = _hasChecked && _internetConnected && _serverReachable;
    final hasConnectionIssues = _hasChecked && (!_internetConnected || !_serverReachable);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.connectionStatus),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToServerConfig,
            tooltip: 'Server Configuration',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Overall Status Icon with improved states
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor().withOpacity(0.1),
              ),
              child: _isChecking
                  ? const CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                  : Icon(
                      _getStatusIcon(),
                      size: 60,
                      color: _getStatusColor(),
                    ),
            ),
            
            const SizedBox(height: 24),
            
            // Overall Status Text with improved states
            Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Subtitle for additional context
            if (_isChecking) ...[
              const SizedBox(height: 8),
              Text(
                'يرجى الانتظار...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 32),

            // Connection Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل الاتصال',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Server Details (always show when available)
                    if (_serverUrl != null && _serverPort != null) ...[
                      _buildInfoRow(
                        'عنوان الخادم',
                        _serverUrl!,
                        Icons.computer,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'المنفذ',
                        _serverPort.toString(),
                        Icons.settings_ethernet,
                      ),
                      if (_testedEndpoint != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'المسار المختبر',
                          _testedEndpoint!,
                          Icons.api,
                        ),
                      ],
                      if (_lastTestTime != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'وقت آخر اختبار',
                          '${_lastTestTime!.hour.toString().padLeft(2, '0')}:${_lastTestTime!.minute.toString().padLeft(2, '0')}:${_lastTestTime!.second.toString().padLeft(2, '0')}',
                          Icons.access_time,
                        ),
                      ],
                      const Divider(),
                    ],

                    // Internet Connection Status
                    if (_hasChecked || _isChecking) ...[
                      _buildStatusRow(
                        'اتصال الإنترنت',
                        _internetConnected,
                        Icons.wifi,
                        subtitle: _isChecking 
                            ? 'جاري فحص الاتصال...'
                            : _connectionType,
                        isChecking: _isChecking,
                      ),
                      const Divider(),
                    ],

                    // Server Connection Status
                    if (_hasChecked || _isChecking) ...[
                      _buildStatusRow(
                        'اتصال الخادم',
                        _serverReachable,
                        Icons.dns,
                        subtitle: _isChecking 
                            ? 'جاري فحص الاتصال...'
                            : _serverReachable && _serverResponseTime != null 
                                ? 'زمن الاستجابة: ${_serverResponseTime}ms${_testedEndpoint != null ? ' عبر $_testedEndpoint' : ''}'
                                : 'غير متصل${_testedEndpoint != null ? ' - فشل الاتصال عبر $_testedEndpoint' : ''}',
                        isChecking: _isChecking,
                      ),
                    ] else ...[
                      // Show placeholder when not checked yet
                      _buildPlaceholderRow(
                        'حالة الاتصال',
                        'اضغط على "فحص الاتصال" لبدء الفحص',
                        Icons.help_outline,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Error Message with improved styling
            if (_errorMessage != null)
              Card(
                color: _connectionState == ConnectionState.timeout 
                    ? Colors.orange.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _connectionState == ConnectionState.timeout 
                            ? Icons.timer_off
                            : Icons.error_outline,
                        color: _connectionState == ConnectionState.timeout 
                            ? Colors.orange
                            : AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _connectionState == ConnectionState.timeout 
                                  ? 'انتهت مهلة الاتصال'
                                  : 'خطأ في الاتصال',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: _connectionState == ConnectionState.timeout 
                                    ? Colors.orange
                                    : AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _errorMessage!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Action Buttons
            Column(
              children: [
                // Retry Button - always visible, shows loading state when checking
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CustomButton(
                        text: _isChecking 
                            ? 'جاري فحص الاتصال...' 
                            : (_hasChecked ? 'إعادة فحص الاتصال' : 'فحص الاتصال'),
                        onPressed: () {
                          print('🖱️ تم الضغط على زر فحص الاتصال');
                          print('📊 الحالة عند الضغط: _isChecking=$_isChecking, _hasChecked=$_hasChecked');
                          print('🎯 نص الزر: ${_isChecking ? 'جاري فحص الاتصال...' : (_hasChecked ? 'إعادة فحص الاتصال' : 'فحص الاتصال')}');
                          
                          if (!_isChecking) {
                            print('🔄 بدء فحص الاتصال من الزر');
                            try {
                              _checkConnection();
                              print('✅ تم استدعاء _checkConnection بنجاح');
                            } catch (e) {
                              print('❌ خطأ في استدعاء _checkConnection: $e');
                            }
                          } else {
                            print('⚠️ الفحص قيد التشغيل بالفعل، تجاهل الضغط');
                          }
                        },
                        icon: _isChecking ? null : Icons.refresh,
                        backgroundColor: AppColors.primary,
                        isLoading: false,
                      ),
                      // مؤشر التحميل المنفصل
                      if (_isChecking)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'جاري الفحص...',
                                    style: TextStyle(
                                      color: AppColors.textOnPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Cancel Button - only visible when checking
                if (_isChecking) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'إلغاء الفحص',
                      onPressed: () {
                        print('🛑 تم الضغط على زر إلغاء الفحص');
                        setState(() {
                          _isChecking = false;
                          _connectionState = ConnectionState.initial;
                        });
                      },
                      icon: Icons.cancel,
                      backgroundColor: AppColors.error,
                    ),
                  ),
                ],

              ],
            ),

            const SizedBox(height: 24),

            // Main Action Buttons Section
            Column(
              children: [
                // Manual Test Button - New reliable test button
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CustomButton(
                        text: _isManualTesting 
                            ? 'جاري الفحص اليدوي...' 
                            : 'فحص يدوي موثوق 🔧',
                        onPressed: () {
                          print('🔧 تم الضغط على زر الفحص اليدوي');
                          print('📊 حالة الفحص اليدوي: _isManualTesting=$_isManualTesting');
                          
                          if (!_isManualTesting) {
                            print('🚀 بدء الفحص اليدوي');
                            _performManualTest();
                          } else {
                            print('⚠️ الفحص اليدوي قيد التشغيل بالفعل');
                          }
                        },
                        icon: _isManualTesting ? null : Icons.build,
                        backgroundColor: Colors.orange,
                        isLoading: false,
                      ),
                      // مؤشر التحميل للفحص اليدوي
                      if (_isManualTesting)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'فحص يدوي...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Cancel Manual Test Button - only visible when manual testing
                if (_isManualTesting) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'إلغاء الفحص اليدوي',
                      onPressed: () {
                        print('🛑 تم الضغط على زر إلغاء الفحص اليدوي');
                        setState(() {
                          _isManualTesting = false;
                          _manualTestError = 'تم إلغاء الفحص اليدوي';
                        });
                      },
                      icon: Icons.cancel,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Server Settings Button - Always visible
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

                // Error Report Button - Always visible
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'إرسال تقرير الخطأ 📋',
                    onPressed: _navigateToErrorReporting,
                    icon: Icons.bug_report,
                    type: ButtonType.outline,
                  ),
                ),

                const SizedBox(height: 12),

                // Export Report Button - Only when checked
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'تصدير التقرير',
                    onPressed: _hasChecked ? _exportReport : null,
                    backgroundColor: AppColors.info,
                    icon: Icons.file_download,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Information Card
            Card(
              color: AppColors.info.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: AppColors.info),
                        SizedBox(width: 8),
                        Text(
                          'نصائح استكشاف الأخطاء',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('• تحقق من اتصال WiFi أو بيانات الجوال'),
                    Text('• تأكد من صحة إعدادات الخادم'),
                    Text('• جرب التبديل بين WiFi وبيانات الجوال'),
                    Text('• اتصل بالدعم الفني إذا استمرت المشاكل'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    String title,
    bool isConnected,
    IconData icon, {
    String? subtitle,
    bool isChecking = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: isConnected ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          isChecking
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Icon(
                  isConnected ? Icons.check_circle : Icons.cancel,
                  color: isConnected ? AppColors.success : AppColors.error,
                ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderRow(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.help_outline,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    if (!_hasChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إجراء فحص الاتصال أولاً'),
        ),
      );
      return;
    }

    final report = _generateReport();
    Share.share(
      report,
      subject: 'تقرير فحص الاتصال - تطبيق IDEC',
    );
  }

  String _generateReport() {
    final timestamp = DateTime.now();
    final formattedTime = '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    
    final buffer = StringBuffer();
    buffer.writeln('=== تقرير فحص الاتصال - تطبيق IDEC ===');
    buffer.writeln('وقت التقرير: $formattedTime');
    buffer.writeln('');
    
    // Overall Status
    buffer.writeln('الحالة العامة: ${_internetConnected && _serverReachable ? 'متصل' : 'غير متصل'}');
    buffer.writeln('');
    
    // Server Configuration
    buffer.writeln('=== إعدادات الخادم ===');
    buffer.writeln('عنوان الخادم: ${_serverUrl ?? 'غير محدد'}');
    buffer.writeln('المنفذ: ${_serverPort ?? 'غير محدد'}');
    if (_testedEndpoint != null) {
      buffer.writeln('المسار المختبر: $_testedEndpoint');
    }
    if (_lastTestTime != null) {
      buffer.writeln('وقت آخر اختبار: ${_lastTestTime!.hour.toString().padLeft(2, '0')}:${_lastTestTime!.minute.toString().padLeft(2, '0')}:${_lastTestTime!.second.toString().padLeft(2, '0')}');
    }
    buffer.writeln('');
    
    // Connection Details
    buffer.writeln('=== تفاصيل الاتصال ===');
    buffer.writeln('اتصال الإنترنت: ${_internetConnected ? 'متصل' : 'غير متصل'}');
    buffer.writeln('نوع الاتصال: ${_connectionType ?? 'غير محدد'}');
    buffer.writeln('اتصال الخادم: ${_serverReachable ? 'متصل' : 'غير متصل'}');
    if (_serverResponseTime != null) {
      buffer.writeln('زمن الاستجابة: ${_serverResponseTime}ms');
    }
    buffer.writeln('');
    
    // Error Information
    if (_errorMessage != null) {
      buffer.writeln('=== تفاصيل الخطأ ===');
      buffer.writeln(_errorMessage!);
      buffer.writeln('');
    }
    
    // Troubleshooting Tips
    buffer.writeln('=== نصائح استكشاف الأخطاء ===');
    buffer.writeln('• تحقق من اتصال WiFi أو بيانات الجوال');
    buffer.writeln('• تأكد من صحة إعدادات الخادم');
    buffer.writeln('• جرب التبديل بين WiFi وبيانات الجوال');
    buffer.writeln('• اتصل بالدعم الفني إذا استمرت المشاكل');
    buffer.writeln('');
    
    buffer.writeln('=== معلومات تقنية ===');
    buffer.writeln('تطبيق: IDEC Conference App');
    buffer.writeln('إصدار التقرير: 1.0');
    
    return buffer.toString();
  }
}
