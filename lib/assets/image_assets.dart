import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageAssets {
  static String getTestImage(int width, [int height = 0]) {
    return 'https://picsum.photos/$width${height > 0 ? '/$height' : ''}?x=${Random().nextInt(100)}';
  }

  static Widget pngAsset(
    String name, {
    Color? color,
    double? width,
    double? height,
    AlignmentGeometry alignment = Alignment.center,
    bool circle = false,
    BoxFit? fit,
    Widget? placeholderWidget,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Image.asset(
      name,
      color: color,
      alignment: alignment,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (context, error, _) {
        return Container();
      },
    );
  }

  static SvgPicture svgAssets(
    String name, {
    Color? color,
    double? width,
    double? height,
    BoxFit fit = BoxFit.none,
    String? packageName,
  }) {
    return SvgPicture.asset(
      name,
      color: color,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget networkImage({
    String? url,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    Alignment alignment = Alignment.center,
  }) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: height,
      child: CachedNetworkImage(
        alignment: alignment,
        imageUrl: url ?? '',
        fit: fit ?? BoxFit.cover,
        color: color,
      ),
    );
  }
}
