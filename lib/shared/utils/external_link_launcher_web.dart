import 'package:web/web.dart' as web;

bool openExternalUrl(String url) {
  if (url.startsWith('mailto:') ||
      url.startsWith('tel:') ||
      url.startsWith('sms:')) {
    web.window.location.href = url;
    return true;
  }

  web.window.open(url, '_blank', 'noopener,noreferrer');
  return true;
}
