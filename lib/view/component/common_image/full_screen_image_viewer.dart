import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'common_image.dart';

void showFullScreenImage(
  BuildContext context, {
  required String imageSrc,
  required ImageType imageType,
}) {
  if (imageSrc.isEmpty) return;
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) =>
          FullScreenImageViewer(imageSrc: imageSrc, imageType: imageType),
    ),
  );
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageSrc;
  final ImageType imageType;

  const FullScreenImageViewer({
    super.key,
    required this.imageSrc,
    required this.imageType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: imageType == ImageType.file
                  ? Image.file(
                      File(imageSrc),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          _errorPlaceholder(),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageSrc,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                      errorWidget: (context, url, error) => _errorPlaceholder(),
                    ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorPlaceholder() {
    return const Icon(Icons.broken_image, color: Colors.white54, size: 64);
  }
}
