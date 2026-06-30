// Innotech wifi

// class ApiConfig {
//   static const String _defaultBaseUrl = 'http://192.168.0.153:8000';

//   static const String baseUrl = String.fromEnvironment(
//     'API_BASE_URL',
//     defaultValue: _defaultBaseUrl,
//   );

//   static const String websiteBaseUrl = '$baseUrl/website';
// }


// deploy

class ApiConfig {
  static const String _defaultBaseUrl = 'https://fastapi-fortfolio.vercel.app';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String websiteBaseUrl = '$baseUrl/website';
}
