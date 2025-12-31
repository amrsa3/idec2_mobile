import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_constants.dart';
import '../../core/auth/auth.dart';
import '../../services/unified_token_manager.dart';
import 'chat_page.dart';

/// Chat Wrapper Page
/// Wraps ChatPage with required dependencies from providers
class ChatWrapperPage extends ConsumerStatefulWidget {
  const ChatWrapperPage({super.key});

  @override
  ConsumerState<ChatWrapperPage> createState() => _ChatWrapperPageState();
}

class _ChatWrapperPageState extends ConsumerState<ChatWrapperPage> {
  String? _cachedToken;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadToken();
  }
  
  Future<void> _loadToken() async {
    try {
      final token = await UnifiedTokenManager.instance.getValidAccessToken();
      if (mounted) {
        setState(() {
          _cachedToken = token;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [ChatWrapperPage] Error loading token: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  String _getToken() {
    // Return cached token, will be refreshed if needed by TokenManager
    return _cachedToken ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    debugPrint('🔐 [ChatWrapperPage] Auth state: isAuthenticated=${authState.isAuthenticated}, user=${authState.user?.phone}');
    
    // Show loading while checking auth
    if (_isLoading) {
      return const _LoadingScreen();
    }
    
    // Check if authenticated
    if (authState.isAuthenticated && authState.user != null) {
      // If no token yet, show loading
      if (_cachedToken == null || _cachedToken!.isEmpty) {
        return const _LoadingScreen();
      }
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('المحادثات'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ChatPage(
          baseUrl: ApiConstants.baseUrl,
          getToken: _getToken,
          userId: authState.user!.id,
        ),
      );
    }
    
    // Not authenticated
    return _buildLoginRequired(context);
  }

  Widget _buildLoginRequired(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'يجب تسجيل الدخول للوصول للمحادثات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري التحميل...'),
          ],
        ),
      ),
    );
  }
}
