import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/profile_model.dart';
import '../../../../shared/widgets/authenticated_image_widget.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../utils/badge_saver.dart';

class ProfileBadgeScreen extends StatefulWidget {
  final ProfileModel profile;

  const ProfileBadgeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProfileBadgeScreen> createState() => _ProfileBadgeScreenState();
}

class _ProfileBadgeScreenState extends State<ProfileBadgeScreen> {
  final GlobalKey _badgeKey = GlobalKey();
  bool _isSaving = false;
  final TransformationController _imageController = TransformationController();

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _extractInitials(widget.profile);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: const CustomAppBar(
        title: 'هوية مشارك IDEC 2026',
        showBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  key: _badgeKey,
                  child: _BadgePreview(
                    profile: widget.profile,
                    initials: initials,
                    controller: _imageController,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _downloadBadge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.download),
                  label: Text(
                    _isSaving ? 'جاري تجهيز الهوية...' : 'تنزيل الهوية',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadBadge() async {
    try {
      setState(() => _isSaving = true);
      await Future.delayed(const Duration(milliseconds: 50));

      final boundary = _badgeKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('الهوية غير جاهزة بعد، حاول مجدداً');
      }

      final ui.Image captured = await boundary.toImage(pixelRatio: 3);
      final byteData = await captured.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) {
        throw Exception('تعذر تحويل الهوية إلى صورة');
      }

      final rgbaBytes = byteData.buffer.asUint8List();
      final image = img.Image.fromBytes(
        width: captured.width,
        height: captured.height,
        bytes: rgbaBytes.buffer,
        order: img.ChannelOrder.rgba,
      );
      final jpgBytes = Uint8List.fromList(
        img.encodeJpg(image, quality: 95),
      );

      await saveBadgeBytes(
        jpgBytes,
        'IDEC_badge_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ الهوية بنجاح 🎉'),
          backgroundColor: Colors.green[700],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تنزيل الهوية: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _extractInitials(ProfileModel profile) {
    final name = profile.fullNameAr.isNotEmpty
        ? profile.fullNameAr
        : (profile.fullNameEn.isNotEmpty ? profile.fullNameEn : '');
    if (name.isEmpty) return 'ID';

    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts.first;
      final second = parts[1];
      return '${first.substring(0, 1)}${second.substring(0, 1)}'.toUpperCase();
    }

    final segment = parts.first;
    final length = segment.length >= 2 ? 2 : 1;
    return segment.substring(0, length).toUpperCase();
  }
}

class _BadgePreview extends StatelessWidget {
  final ProfileModel profile;
  final String initials;
  final TransformationController controller;

  const _BadgePreview({
    required this.profile,
    required this.initials,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3A3A3A),
              Color(0xFF0F0F0F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2B2B2B),
                      Color(0xFF090909),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: _ProfileImageLayer(
                profile: profile,
                initials: initials,
                controller: controller,
              ),
            ),
            const IgnorePointer(child: _BadgeFrame()),
          ],
        ),
      ),
    );
  }
}

class _ProfileImageLayer extends StatelessWidget {
  final ProfileModel profile;
  final String initials;
  final TransformationController controller;

  const _ProfileImageLayer({
    required this.profile,
    required this.initials,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide * 0.85;
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: ClipOval(
              child: InteractiveViewer(
                transformationController: controller,
                minScale: 0.7,
                maxScale: 1.6,
                panEnabled: true,
                scaleEnabled: true,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(200),
                clipBehavior: Clip.none,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: _buildImage(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    final imageUrl = profile.profilePictureUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return AuthenticatedImageWidget(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: _buildFallback(),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFFAA1D1D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        style: AppTextStyles.headlineMedium.copyWith(
          color: Colors.white,
          fontSize: 48,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _BadgeFrame extends StatelessWidget {
  const _BadgeFrame();

  Future<ByteData?> _loadFrame() async {
    try {
      return await rootBundle.load('assets/images/profile_badge_frame.png');
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData?>(
      future: _loadFrame(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final bytes = snapshot.data!;
          return IgnorePointer(
            child: Image.memory(
              bytes.buffer.asUint8List(),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          );
        }

        return IgnorePointer(child: _FallbackFrame());
      },
    );
  }
}

class _FallbackFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.3),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 10,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'أنا مشارك في IDEC 2026',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


