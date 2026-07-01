import 'package:flutter/material.dart';
import '../../api/api.dart';

class ApiImage {
  static bool isNetworkImage(String image) {
    return image.startsWith('http://') || image.startsWith('https://');
  }

  static ImageProvider imageProviderFor(
    String image, {
    required String fallbackAsset,
  }) {
    if (image.isEmpty) {
      return AssetImage(fallbackAsset);
    }

    if (isNetworkImage(image)) {
      return NetworkImage(image);
    }

    return AssetImage(image);
  }

  static String resolveImage(Map<String, dynamic> item) {
    final link = (item['image_link'] ?? item['icon_link'] ?? '').toString();
    if (link.isNotEmpty) return _toAbsoluteUrl(link);

    return (item['image'] ?? item['icon'] ?? '').toString();
  }

  static String resolveImageLeft(Map<String, dynamic> item) {
    final link = (item['image_left_link'] ?? '').toString();
    if (link.isNotEmpty) return _toAbsoluteUrl(link);
    return (item['imageleft'] ?? item['image_left'] ?? '').toString();
  }

  static String resolveImageRight(Map<String, dynamic> item) {
    final link = (item['image_right_link'] ?? '').toString();
    if (link.isNotEmpty) return _toAbsoluteUrl(link);
    return (item['imageright'] ?? item['image_right'] ?? '').toString();
  }

  static String resolveIcon(Map<String, dynamic> item) {
    final link = (item['image_link'] ?? item['icon_link'] ?? '').toString();
    if (link.isNotEmpty) return _toAbsoluteUrl(link);

    return (item['image'] ?? item['icon'] ?? '').toString();
  }

  static String _toAbsoluteUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) {
      return Uri.parse(ApiConfig.baseUrl).resolve(path).toString();
    }
    return path;
  }
}
