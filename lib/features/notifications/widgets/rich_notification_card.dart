import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_helper.dart';
import '../../../models/notification_model.dart';

/// بطاقة إشعار محسّنة تدعم Rich Notifications
/// (صور، فيديو، أزرار تفاعلية)
class RichNotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Function(String actionType, Map<String, dynamic>? data)? onActionTap;

  const RichNotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.onActionTap,
  }) : super(key: key);

  @override
  State<RichNotificationCard> createState() => _RichNotificationCardState();
}

class _RichNotificationCardState extends State<RichNotificationCard> {
  VideoPlayerController? _videoController;
  bool _showVideo = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _videoController!.initialize();
      setState(() {
        _showVideo = true;
      });
    } catch (error) {
      debugPrint('❌ [VIDEO] Error initializing: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dateFormat = intl.DateFormat('dd MMM yyyy, hh:mm a', isArabic ? 'ar' : 'en');

    // Parse metadata if available
    Map<String, dynamic>? metadata;
    try {
      if (widget.notification.data != null) {
        metadata = widget.notification.data is String
            ? jsonDecode(widget.notification.data as String)
            : widget.notification.data as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('⚠️ [NOTIFICATION] Error parsing metadata: $e');
    }

    final imageUrl = metadata?['imageUrl'] as String?;
    final videoUrl = metadata?['videoUrl'] as String?;
    final thumbnailUrl = metadata?['thumbnailUrl'] as String?;
    final actionButtons = metadata?['actionButtons'] as List?;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: widget.notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.notification.isRead
              ? Colors.transparent
              : AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: widget.notification.isRead
                ? null
                : LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.03),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرأس (العنوان والتاريخ)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأيقونة
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getNotificationColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getNotificationIcon(),
                        color: _getNotificationColor(),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // العنوان والوقت
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notification.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: widget.notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateHelper.getTimeAgo(widget.notification.createdAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Unread indicator
                    if (!widget.notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),

              // الصورة (إن وجدت)
              if (imageUrl != null && imageUrl.isNotEmpty)
                _buildImage(imageUrl),

              // الفيديو (إن وجد)
              if (videoUrl != null && videoUrl.isNotEmpty)
                _buildVideo(videoUrl, thumbnailUrl),

              // الرسالة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.notification.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Action Buttons (إن وجدت)
              if (actionButtons != null && actionButtons.isNotEmpty)
                _buildActionButtons(actionButtons),

              const SizedBox(height: 12),

              // Footer (النوع والإجراءات)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // نوع الإشعار
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getNotificationColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getNotificationTypeText(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getNotificationColor(),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // زر الحذف
                    if (widget.onDismiss != null)
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        iconSize: 20,
                        color: AppColors.textSecondary,
                        onPressed: widget.onDismiss,
                        tooltip: 'حذف',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.error_outline, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideo(String videoUrl, String? thumbnailUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _showVideo && _videoController != null
            ? Stack(
                children: [
                  // Video Player
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  // Play/Pause Button
                  Center(
                    child: IconButton(
                      icon: Icon(
                        _videoController!.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 64,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        });
                      },
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => _initializeVideoPlayer(videoUrl),
                child: Stack(
                  children: [
                    // Thumbnail
                    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(color: Colors.grey[900]),
                    // Play Button
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons(List actionButtons) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actionButtons.map((button) {
          final label = button['label'] as String? ?? 'إجراء';
          final actionType = button['action'] as String? ?? '';
          final data = button['data'] as Map<String, dynamic>?;

          return OutlinedButton.icon(
            onPressed: () {
              if (widget.onActionTap != null) {
                widget.onActionTap!(actionType, data);
              }
            },
            icon: Icon(_getActionIcon(actionType), size: 18),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getNotificationColor() {
    switch (widget.notification.type.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      case 'urgent':
        return Colors.deepOrange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon() {
    switch (widget.notification.type.toLowerCase()) {
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      case 'urgent':
        return Icons.priority_high;
      case 'registration':
        return Icons.assignment;
      case 'payment':
        return Icons.payment;
      case 'event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'VIEW_EVENT':
        return Icons.event;
      case 'VIEW_REGISTRATION':
        return Icons.assignment;
      case 'VIEW_PAYMENT':
        return Icons.payment;
      case 'VIEW_PROFILE':
        return Icons.person;
      case 'REGISTER':
        return Icons.how_to_reg;
      default:
        return Icons.open_in_new;
    }
  }

  String _getNotificationTypeText() {
    switch (widget.notification.type.toLowerCase()) {
      case 'success':
        return 'نجاح';
      case 'error':
        return 'خطأ';
      case 'warning':
        return 'تحذير';
      case 'info':
        return 'معلومة';
      case 'urgent':
        return 'عاجل';
      case 'registration':
        return 'تسجيل';
      case 'payment':
        return 'دفع';
      case 'event':
        return 'فعالية';
      default:
        return 'إشعار';
    }
  }
}




