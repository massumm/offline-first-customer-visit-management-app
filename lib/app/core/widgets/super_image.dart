import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/network/dio_provider.dart';
import 'image_not_found.dart';

class SuperImage extends StatelessWidget {
  const SuperImage(
      this.path, {
        super.key,
        this.bytes,
        this.width,
        this.height,
        this.padding,
        this.bgColor,
        this.radius = 0,
        this.fit = BoxFit.cover,
        this.filterQuality =
            FilterQuality.medium, // Add filterQuality parameter with a default
        this.placeholder,
        this.errorWidget,
      });

  final String? path;
  final Uint8List? bytes;
  final double? width, height, radius;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BoxFit fit;
  final FilterQuality filterQuality; // Declare filterQuality

  final Widget Function(BuildContext, String)? placeholder;
  final Widget? errorWidget;

  bool get _isSvg => path?.toLowerCase().endsWith('.svg') ?? false;
  bool get _isHttp => path?.startsWith('http') ?? false;
  bool get _isHttps => path?.startsWith('https') ?? false;
  bool get _isAsset => path?.startsWith('assets') ?? false;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (bytes != null) {
      imageWidget = _loadMemoryImage(bytes!);
    } else {
      final imgPath = path;
      if (imgPath == null || imgPath.isEmpty) {
        imageWidget = _getDisplayErrorWidget();
      } else if (_isHttp || _isHttps) {
        imageWidget = _loadNetworkImage(imgPath);
      } else if (_isAsset) {
        imageWidget = _loadAssetImage(imgPath);
      } else if (imgPath.startsWith('/')) {
        imageWidget = FutureBuilder<bool>(
          future: File(imgPath).exists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return placeholder != null
                  ? placeholder!(context, imgPath)
                  : _defaultPlaceholder(context, imgPath);
            }
            if (snapshot.hasData && snapshot.data == true) {
              return _loadFileImage(imgPath);
            }
            // Handle error or file not found
            return _getDisplayErrorWidget();
          },
        );
      } else {
        // Assume it's a fileKey that needs to be resolved to a network URL.
        imageWidget = _loadNetworkImage('${DioProvider.mediaBaseUrl}/$imgPath');
      }
    }

    return _buildContainer(imageWidget);
  }

  Widget _loadAssetImage(String imgPath) {
    if (_isSvg) {
      // SvgPicture.asset doesn't have a great error handler, so we use a
      // FutureBuilder to load the SVG data and handle potential errors.
      return FutureBuilder<String>(
        future: rootBundle.loadString(imgPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return placeholder != null
                ? placeholder!(context, imgPath)
                : _defaultPlaceholder(context, imgPath);
          }
          if (snapshot.hasData && snapshot.data != null) {
            return SvgPicture.string(snapshot.data!,
                width: width, height: height, fit: fit);
          }
          return _getDisplayErrorWidget();
        },
      );
    } else {
      // Image.asset handles errors via the errorBuilder.
      return Image.asset(imgPath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _getDisplayErrorWidget());
    }
  }

  Widget _loadNetworkImage(String imgPath) {
    if (_isSvg) {
      return SvgPicture.network(
        imgPath,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (context) => placeholder != null
            ? placeholder!(context, imgPath)
            : _defaultPlaceholder(context, imgPath),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imgPath,
        width: width,
        height: height,
        fit: fit,
        filterQuality:
        filterQuality, // Apply filterQuality to CachedNetworkImage
        cacheKey: imgPath,
        placeholder: placeholder ?? _defaultPlaceholder,
        errorWidget: (context, url, error) => _getDisplayErrorWidget(),
      );
    }
  }

  Widget _loadFileImage(String imgPath) => Image.file(
    File(imgPath),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => _getDisplayErrorWidget(),
    frameBuilder: (BuildContext context, Widget child, int? frame,
        bool wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: child,
      );
    },
  );

  Widget _loadMemoryImage(Uint8List data) => Image.memory(
    data,
    width: width,
    height: height,
    fit: fit,
    filterQuality: filterQuality, // Apply filterQuality to Image.memory
    errorBuilder: (context, error, stackTrace) => _getDisplayErrorWidget(),
  );

  Widget _buildContainer(Widget child) {
    final isCircle =
        width != null && height == width && (radius ?? 0) >= (width! / 2);
    final borderRadius = BorderRadius.circular(radius ?? 0);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isCircle ? null : borderRadius,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _getDisplayErrorWidget() =>
      errorWidget ?? _buildError(); // Central error widget logic

  Widget _buildError() {
    final isSmall = (width ?? 50) < 50;
    return isSmall
        ? const Icon(Icons.error_outline, color: Colors.redAccent)
        : ImageNotFoundWidget(
      height: height ?? 50,
      width: width ?? 50,
    );
  }

  Widget _defaultPlaceholder(BuildContext context, String url) =>
      const Center(child: CircularProgressIndicator(strokeWidth: 1));
}
