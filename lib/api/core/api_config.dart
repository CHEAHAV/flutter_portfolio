// Innotech wifi

// class ApiConfig {
//   static const String _defaultBaseUrl = 'http://192.168.0.152:8000';

//   static const String baseUrl = String.fromEnvironment(
//     'API_BASE_URL',
//     defaultValue: _defaultBaseUrl,
//   );

//   static const String websiteBaseUrl = '$baseUrl/api/v1/website';
// }

// ngrok

class ApiConfig {
  static const String _defaultBaseUrl = 'https://web-production-eece4.up.railway.app';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String websiteBaseUrl = '$baseUrl/api/v1/website';

  static const Map<String, String> ngrokHeaders = {
    'ngrok-skip-browser-warning': 'true',
  };
}