import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/chat_connection_manager.dart' as conn;

/// Connection Status Indicator Widget
/// Shows connection status with animated transitions
class ConnectionStatusIndicator extends StatefulWidget {
  final Widget child;
  final Duration showDelay;

  const ConnectionStatusIndicator({
    super.key,
    required this.child,
    this.showDelay = const Duration(seconds: 2),
  });

  @override
  State<ConnectionStatusIndicator> createState() => _ConnectionStatusIndicatorState();
}

class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator>
    with SingleTickerProviderStateMixin {
  bool _showBanner = false;
  bool _isOnline = true;
  Timer? _showTimer;
  StreamSubscription? _connectionSubscription;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _isOnline = conn.chatConnection.isOnline;
    
    _connectionSubscription = conn.chatConnection.connectionStateStream.listen((state) {
      final isOnline = state == conn.ConnectionState.connected;
      
      if (isOnline != _isOnline) {
        setState(() {
          _isOnline = isOnline;
        });
        
        if (!isOnline) {
          // Show banner after delay
          _showTimer?.cancel();
          _showTimer = Timer(widget.showDelay, () {
            if (mounted && !_isOnline) {
              setState(() => _showBanner = true);
              _animationController.forward();
            }
          });
        } else {
          // Hide banner
          _showTimer?.cancel();
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() => _showBanner = false);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _connectionSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBanner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 50),
                  child: child,
                );
              },
              child: _buildBanner(),
            ),
          ),
      ],
    );
  }

  Widget _buildBanner() {
    return Material(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 12,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade600,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.9)),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'جاري إعادة الاتصال...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple connection dot indicator
class ConnectionDot extends StatelessWidget {
  final double size;

  const ConnectionDot({super.key, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<conn.ConnectionState>(
      stream: conn.chatConnection.connectionStateStream,
      initialData: conn.chatConnection.isOnline 
          ? conn.ConnectionState.connected 
          : conn.ConnectionState.disconnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data == conn.ConnectionState.connected;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isConnected ? Colors.green : Colors.red).withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
