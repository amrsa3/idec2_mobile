import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/server_config_model.dart';
import '../../../services/server_config_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ServerConfigScreen extends ConsumerStatefulWidget {
  const ServerConfigScreen({super.key});

  @override
  ConsumerState<ServerConfigScreen> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends ConsumerState<ServerConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _portController = TextEditingController();
  
  bool _isSecure = true;
  bool _isLoading = false;
  bool _isTesting = false;
  ServerConfig? _currentConfig;
  ServerTestResult? _testResult;
  
  final _serverConfigService = ServerConfigService();

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentConfig() async {
    setState(() => _isLoading = true);
    
    try {
      final config = await _serverConfigService.getServerConfig();
      setState(() {
        _currentConfig = config;
        _baseUrlController.text = config.baseUrl;
        _portController.text = config.port.toString();
        _isSecure = config.isSecure;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load server configuration');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isTesting = true);

    try {
      final config = ServerConfig(
        baseUrl: _baseUrlController.text.trim(),
        port: int.parse(_portController.text.trim()),
        isSecure: _isSecure,
      );

      final result = await _serverConfigService.testServerConnection(config);
      setState(() => _testResult = result);

      if (result.isReachable) {
        _showSuccessSnackBar('Server is reachable (${result.responseTime}ms)');
      } else {
        _showErrorSnackBar(result.message);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to test connection: $e');
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final config = ServerConfig(
        baseUrl: _baseUrlController.text.trim(),
        port: int.parse(_portController.text.trim()),
        isSecure: _isSecure,
        lastTested: DateTime.now(),
        isReachable: _testResult?.isReachable ?? false,
        responseTime: _testResult?.responseTime,
      );

      final success = await _serverConfigService.saveServerConfig(config);
      
      if (success) {
        _showSuccessSnackBar('Server configuration saved successfully');
        if (mounted) context.pop();
      } else {
        _showErrorSnackBar('Failed to save configuration');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save configuration: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetToDefault() async {
    final confirmed = await _showConfirmDialog(
      'Reset to Default',
      'Are you sure you want to reset to default server configuration?',
    );

    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      await _serverConfigService.resetToDefault();
      await _loadCurrentConfig();
      _showSuccessSnackBar('Reset to default configuration');
    } catch (e) {
      _showErrorSnackBar('Failed to reset configuration');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectPreset(ServerConfig preset) {
    setState(() {
      _baseUrlController.text = preset.baseUrl;
      _portController.text = preset.port.toString();
      _isSecure = preset.isSecure;
      _testResult = null;
    });
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Server URL is required';
    }
    
    final validation = _serverConfigService.validateConfig(value.trim(), 
        int.tryParse(_portController.text) ?? 0);
    return validation.urlError;
  }

  String? _validatePort(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Port is required';
    }
    
    final port = int.tryParse(value.trim());
    if (port == null) {
      return 'Port must be a number';
    }
    
    final validation = _serverConfigService.validateConfig(
        _baseUrlController.text, port);
    return validation.portError;
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

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Configuration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetToDefault,
            tooltip: 'Reset to Default',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Configuration Info
                    if (_currentConfig != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Configuration',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('URL: ${_currentConfig!.fullUrl}'),
                              if (_currentConfig!.lastTested != null)
                                Text('Last tested: ${_currentConfig!.lastTested}'),
                              if (_currentConfig!.isReachable)
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, 
                                         color: AppColors.success, size: 16),
                                    const SizedBox(width: 4),
                                    Text('Reachable', 
                                         style: TextStyle(color: AppColors.success)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Server Configuration Form
                    Text(
                      'Server Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Base URL Field
                    CustomTextField(
                      controller: _baseUrlController,
                      label: 'Server URL',
                      hint: 'e.g., 192.168.0.249 or api.idec.com',
                      validator: _validateUrl,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    // Port Field
                    CustomTextField(
                      controller: _portController,
                      label: 'Port',
                      hint: 'e.g., 3000 or 443',
                      validator: _validatePort,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // HTTPS Toggle
                    SwitchListTile(
                      title: const Text('Use HTTPS'),
                      subtitle: const Text('Enable secure connection'),
                      value: _isSecure,
                      onChanged: (value) => setState(() => _isSecure = value),
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 24),

                    // Test Connection Button
                    CustomButton(
                      text: 'Test Connection',
                      onPressed: _isTesting ? null : _testConnection,
                      isLoading: _isTesting,
                      isFullWidth: true,
                      backgroundColor: AppColors.secondary,
                    ),

                    // Test Result
                    if (_testResult != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: _testResult!.isReachable 
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _testResult!.isReachable 
                                        ? Icons.check_circle 
                                        : Icons.error,
                                    color: _testResult!.isReachable 
                                        ? AppColors.success 
                                        : AppColors.error,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _testResult!.isReachable 
                                        ? 'Connection Successful' 
                                        : 'Connection Failed',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _testResult!.isReachable 
                                          ? AppColors.success 
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Response time: ${_testResult!.responseTime}ms'),
                              if (_testResult!.statusCode != null)
                                Text('Status code: ${_testResult!.statusCode}'),
                              Text('Message: ${_testResult!.message}'),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Presets Section
                    Text(
                      'Quick Presets',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...DefaultServerConfigs.presets.map((preset) => Card(
                      child: ListTile(
                        title: Text(preset.baseUrl),
                        subtitle: Text('Port: ${preset.port} • ${preset.isSecure ? 'HTTPS' : 'HTTP'}'),
                        trailing: preset.isDefault 
                            ? const Chip(label: Text('Default'))
                            : null,
                        onTap: () => _selectPreset(preset),
                      ),
                    )),

                    const SizedBox(height: 32),

                    // Save Button
                    CustomButton(
                      text: 'Save Configuration',
                      onPressed: _isLoading ? null : _saveConfiguration,
                      isLoading: _isLoading,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
