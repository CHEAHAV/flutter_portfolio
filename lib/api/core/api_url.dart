import 'package:portfolio/api/core/api_config.dart';

class ApiUrl {
  static String toAbsoluteUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) {
      return Uri.parse(ApiConfig.baseUrl).resolve(path).toString();
    }
    return path;
  }

  static String resolveProjectUrl(Map<String, dynamic> item) {
    final url = (item['project_url'] ?? item['Project_Url'] ?? '').toString();
    if (url.isNotEmpty) return toAbsoluteUrl(url);
    return (item['projecturl'] ?? item['ProjectUrl'] ?? '').toString();
  }

  static String resolveCertificateUrl(Map<String, dynamic> item) {
    final url = (item['certificate_url'] ?? item['Certificate_Url'] ?? '')
        .toString();
    if (url.isNotEmpty) return toAbsoluteUrl(url);
    return (item['certificateurl'] ?? item['CertificateUrl'] ?? '').toString();
  }

  static String resolveContactUrl(Map<String, dynamic> item) {
    final url = (item['contact_url'] ?? item['contact_Url'] ?? '').toString();
    if (url.isNotEmpty) return toAbsoluteUrl(url);
    return (item['contacturl'] ?? item["contactUrl"] ?? '').toString();
  }

  static String resolveSocialUrl(Map<String, dynamic> item) {
    final url = (item['social_url'] ?? item['social_Url'] ?? '').toString();
    if (url.isNotEmpty) return toAbsoluteUrl(url);
    return (item['socialurl'] ?? item['socialUrl'] ?? '').toString();
  }
}
