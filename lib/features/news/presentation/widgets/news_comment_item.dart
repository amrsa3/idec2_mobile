import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/news_comment_model.dart';

class NewsCommentItem extends StatelessWidget {
  final NewsCommentModel comment;
  final Function(NewsCommentModel)? onReply;
  final String? replyingToCommentId;
  final TextEditingController? replyController;
  final Function(String)? onSendReply;
  final Function()? onCancelReply;

  const NewsCommentItem({
    super.key,
    required this.comment,
    this.onReply,
    this.replyingToCommentId,
    this.replyController,
    this.onSendReply,
    this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (comment.isPending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'قيد الانتظار',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.warning,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Content
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Reply button
          if (onReply != null)
            TextButton.icon(
              onPressed: () => onReply!(comment),
              icon: const Icon(Icons.reply, size: 16),
              label: const Text('رد'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          // Reply input box - show below the comment if this is the comment being replied to
          if (replyingToCommentId == comment.id && replyController != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.reply, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'رد على: ${comment.authorName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: onCancelReply,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration: InputDecoration(
                            hintText: 'اكتب ردك...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.primary),
                        onPressed: onSendReply != null ? () => onSendReply!(comment.id) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          // Replies
          if (comment.replies != null && comment.replies!.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...comment.replies!.map((reply) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: NewsCommentItem(
                  comment: reply,
                  onReply: null, // Nested replies disabled for now
                  replyingToCommentId: replyingToCommentId,
                  replyController: replyController,
                  onSendReply: onSendReply,
                  onCancelReply: onCancelReply,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

