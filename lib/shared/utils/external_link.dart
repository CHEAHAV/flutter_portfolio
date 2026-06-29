import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ExternalLink {
  static const MethodChannel _channel = MethodChannel(
    'portfolio/external_link',
  );

  static Future<bool> open(String url) async {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) return false;

    final uri = Uri.tryParse(trimmedUrl);
    if (uri == null || uri.scheme.isEmpty) return false;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return await _channel.invokeMethod<bool>('open', trimmedUrl) ?? false;
    }

    return false;
  }
}
