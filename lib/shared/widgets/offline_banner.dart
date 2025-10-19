import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBanner extends StatefulWidget {
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final String? message;
  final Duration animationDuration;

  const OfflineBanner({
    Key? key,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.message,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isOffline = false;
  bool _hasShownOffline = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _checkConnectivity();
    _listenToConnectivityChanges();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final isOffline = result == ConnectivityResult.none;
    
    if (isOffline != _isOffline) {
      setState(() {
        _isOffline = isOffline;
      });

      if (_isOffline) {
        _hasShownOffline = true;
        _animationController.forward();
      } else if (_hasShownOffline) {
        // Show brief "back online" message then hide
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isOffline) {
            _animationController.reverse();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * 50),
              child: _isOffline || _slideAnimation.value > -1.0
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isOffline
                            ? (widget.backgroundColor ?? Colors.red[600])
                            : Colors.green[600],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOffline
                                ? Icons.wifi_off
                                : Icons.wifi,
                            color: widget.textColor ?? Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOffline
                                ? (widget.message ?? 'لا يوجد اتصال بالإنترنت')
                                : 'تم استعادة الاتصال بالإنترنت',
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
        if (widget.child != null) Expanded(child: widget.child!),
      ],
    );
  }
}

// Simple offline banner without animation for basic usage
class SimpleOfflineBanner extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? textColor;

  const SimpleOfflineBanner({
    Key? key,
    this.message,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.red[600],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: textColor ?? Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  message ?? 'لا يوجد اتصال بالإنترنت',
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
