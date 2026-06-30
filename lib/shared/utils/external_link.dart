import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'external_link_launcher_stub.dart'
    if (dart.library.js_interop) 'external_link_launcher_web.dart';

class ExternalLink {
  static const MethodChannel _channel = MethodChannel(
    'portfolio/external_link',
  );

  static Future<bool> open(String url) async {
    final normalizedUrl = _normalize(url);
    if (normalizedUrl.isEmpty) return false;

    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null || uri.scheme.isEmpty) return false;

    if (kIsWeb) {
      return openExternalUrl(normalizedUrl);
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return await _channel.invokeMethod<bool>('open', normalizedUrl) ?? false;
    }

    return false;
  }

  static String _normalize(String url) {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) return '';

    final email = RegExp(
      r'^[\w.+-]+@[\w-]+(?:\.[\w-]+)+$',
    ).firstMatch(trimmedUrl);
    if (email != null) return 'mailto:$trimmedUrl';

    final uri = Uri.tryParse(trimmedUrl);
    if (uri != null && uri.scheme.isNotEmpty) return trimmedUrl;

    final looksLikeDomain = RegExp(
      r'^(?:www\.)?[\w-]+(?:\.[\w-]+)+(?:[/:?#].*)?$',
      caseSensitive: false,
    ).hasMatch(trimmedUrl);

    if (looksLikeDomain) {
      return 'https://$trimmedUrl';
    }

    return trimmedUrl;
  }
}
