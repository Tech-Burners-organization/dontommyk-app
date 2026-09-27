import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

enum ImageType { file, png, jpg, svg, network }

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final ImageType imageType;
  final BoxFit fill;
  final bool isProfile;
  final bool autoAspectRatio;

  const CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height,
    this.width,
    this.borderRadius = 10,
    this.imageType = ImageType.svg,
    this.fill = BoxFit.cover,
    this.defaultImage = "",
    this.isProfile = false,
    this.autoAspectRatio = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (autoAspectRatio &&
        (imageType == ImageType.file || imageType == ImageType.network)) {
      return FutureBuilder<Size>(
        future: imageType == ImageType.file
            ? _getFileImageSize(imageSrc)
            : _getNetworkImageSize(imageSrc),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(height: 200);
          }

          final size = snapshot.data!;
          final aspectRatio = size.width / size.height;

          return AspectRatio(aspectRatio: aspectRatio, child: _buildImage());
        },
      );
    }

    return _buildImage();
  }

  /// ================= IMAGE BUILDER =================

  Widget _buildImage() {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.svg:
        imageWidget = SvgPicture.asset(
          imageSrc,
          colorFilter: imageColor != null
              ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
              : null,
          height: height,
          width: width,
          fit: fill,
        );
        break;

      case ImageType.file:
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            File(imageSrc),
            color: imageColor,
            height: height,
            width: width,
            fit: fill,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print("File Image Error: $error");
              }
              return Image.asset(defaultImage, fit: fill);
            },
          ),
        );
        break;

      case ImageType.png:
      case ImageType.jpg:
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imageSrc,
            color: imageColor,
            height: height,
            width: width,
            fit: fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(defaultImage, fit: fill);
            },
          ),
        );
        break;

      case ImageType.network:
        imageWidget = CachedNetworkImage(
          height: height,
          width: width,
          imageUrl: imageSrc,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              image: DecorationImage(image: imageProvider, fit: fill),
            ),
          ),
          progressIndicatorBuilder: (context, url, progress) =>
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
          errorWidget: (context, url, error) {
            if (kDebugMode) {
              print("Network Image Error: $error");
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                isProfile ? 100 : borderRadius,
              ),
              child: Image.asset(
                defaultImage,
                fit: fill,
                height: height,
                width: width,
              ),
            );
          },
        );
        break;
    }

    if (height != null || width != null) {
      return SizedBox(height: height, width: width, child: imageWidget);
    }

    return imageWidget;
  }

  /// ================= FILE IMAGE SIZE =================

  Future<Size> _getFileImageSize(String path) async {
    final image = Image.file(File(path));
    final completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, _) {
            completer.complete(
              Size(info.image.width.toDouble(), info.image.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }

  /// ================= NETWORK IMAGE SIZE =================

  Future<Size> _getNetworkImageSize(String url) async {
    final completer = Completer<Size>();
    final image = NetworkImage(url);

    image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, _) {
            completer.complete(
              Size(info.image.width.toDouble(), info.image.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }
}
