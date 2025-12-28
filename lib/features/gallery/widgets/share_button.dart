import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Share Button Widget for Gallery Photos
class ShareButton extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? description;
  final String? albumTitle;
  final Color? iconColor;
  final double? iconSize;

  const ShareButton({
    super.key,
    required this.imageUrl,
    this.title,
    this.description,
    this.albumTitle,
    this.iconColor,
    this.iconSize = 24.0,
  });

  Future<void> _sharePhoto(BuildContext context) async {
    try {
      final text = _buildShareText();
      await Share.share(
        text,
        subject: title ?? 'صورة من معرض الصور',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في المشاركة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    try {
      final text = _buildShareText();
      final url = 'https://wa.me/?text=${Uri.encodeComponent(text)}';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'لا يمكن فتح WhatsApp';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في المشاركة على WhatsApp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareToTelegram(BuildContext context) async {
    try {
      final text = _buildShareText();
      final url = 'https://t.me/share/url?url=${Uri.encodeComponent(imageUrl)}&text=${Uri.encodeComponent(text)}';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'لا يمكن فتح Telegram';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في المشاركة على Telegram: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareToTwitter(BuildContext context) async {
    try {
      final text = _buildShareText();
      final url = 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}&url=${Uri.encodeComponent(imageUrl)}';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'لا يمكن فتح Twitter';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في المشاركة على Twitter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة عامة'),
              onTap: () {
                Navigator.pop(context);
                _sharePhoto(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('مشاركة على WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                _shareToWhatsApp(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.send, color: Colors.blue),
              title: const Text('مشاركة على Telegram'),
              onTap: () {
                Navigator.pop(context);
                _shareToTelegram(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email, color: Colors.blue),
              title: const Text('مشاركة على Twitter'),
              onTap: () {
                Navigator.pop(context);
                _shareToTwitter(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _buildShareText() {
    final buffer = StringBuffer();
    
    if (title != null && title!.isNotEmpty) {
      buffer.writeln(title);
    }
    
    if (albumTitle != null && albumTitle!.isNotEmpty) {
      buffer.writeln('من ألبوم: $albumTitle');
    }
    
    if (description != null && description!.isNotEmpty) {
      buffer.writeln(description);
    }
    
    buffer.writeln(imageUrl);
    
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: iconSize,
      ),
      onPressed: () => _showShareOptions(context),
      tooltip: 'مشاركة',
    );
  }
}
















