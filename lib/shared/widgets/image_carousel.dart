import 'dart:async';
import 'package:flutter/material.dart';
import 'authenticated_image_widget.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final BoxFit fit;
  final bool showIndicators;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 300,
    this.fit = BoxFit.cover,
    this.showIndicators = true,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay && widget.images.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % widget.images.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image, size: 60, color: Colors.grey),
        ),
      );
    }

    if (widget.images.length == 1) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: AuthenticatedImageWidget(
          imageUrl: widget.images.first,
          fit: widget.fit,
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return AuthenticatedImageWidget(
                imageUrl: widget.images[index],
                fit: widget.fit,
              );
            },
          ),
        ),
        if (widget.showIndicators)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

