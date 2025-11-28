import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final List<String> _frameAssets = const [
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
  ];
  int _selectedFrameIndex = 0;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _extractInitials(widget.profile);
    final selectedFrame = _frameAssets[_selectedFrameIndex];

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RepaintBoundary(
                    key: _badgeKey,
                    child: _BadgePreview(
                      profile: widget.profile,
                      initials: initials,
                      controller: _imageController,
                      frameAsset: selectedFrame,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _FrameSelector(
                    frameAssets: _frameAssets,
                    selectedIndex: _selectedFrameIndex,
                    onSelected: _onFrameSelected,
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
      ),
    );
  }

  void _onFrameSelected(int index) {
    if (index == _selectedFrameIndex) return;
    setState(() => _selectedFrameIndex = index);
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
  final String frameAsset;

  const _BadgePreview({
    required this.profile,
    required this.initials,
    required this.controller,
    required this.frameAsset,
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
            IgnorePointer(
              child: _BadgeFrame(assetPath: frameAsset),
            ),
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
  final String assetPath;

  const _BadgeFrame({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const _FallbackFrame();
      },
    );
  }
}

class _FallbackFrame extends StatelessWidget {
  const _FallbackFrame();

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

class _FrameSelector extends StatelessWidget {
  final List<String> frameAssets;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FrameSelector({
    required this.frameAssets,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الإطار المفضل',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: frameAssets.asMap().entries.map((entry) {
            final index = entry.key;
            final asset = entry.value;
            final isSelected = index == selectedIndex;
            final isLast = index == frameAssets.length - 1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: isLast ? 0 : 12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.white24,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: Colors.black,
                            child: Image.asset(
                              asset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const _FallbackFrame();
                              },
                            ),
                          ),
                          if (isSelected)
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
