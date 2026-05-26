import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:portfolio/api/core/api_config.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Map<String, dynamic>>> getWebsiteList(String path) async {
    final decoded = await _getWebsiteResponse(path);
    return _listsFromResponse(decoded);
  }

  Future<List<Map<String, dynamic>>> getAllWebsiteList(
    String path, {
    int pageSize = 100,
  }) async {
    final firstPath = _pathWithQuery(path, page: 1, size: pageSize);
    final firstResponse = await _getWebsiteResponse(firstPath);
    final lists = [..._listsFromResponse(firstResponse)];
    final totalPages = _totalPagesFromResponse(firstResponse);

    for (var page = 2; page <= totalPages; page++) {
      final pagePath = _pathWithQuery(path, page: page, size: pageSize);
      final response = await _getWebsiteResponse(pagePath);
      lists.addAll(_listsFromResponse(response));
    }

    return lists;
  }

  Future<Map<String, dynamic>> postWebsiteForm(
    String path,
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse('${ApiConfig.websiteBaseUrl}$path');
    final response = await _client
        .post(uri, body: fields)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Request failed: ${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Invalid response format');
    }

    return decoded;
  }

  Future<Map<String, dynamic>> _getWebsiteResponse(String path) async {
    final uri = Uri.parse('${ApiConfig.websiteBaseUrl}$path');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Request failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Invalid response format');
    }

    return decoded;
  }

  List<Map<String, dynamic>> _listsFromResponse(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      return const [];
    }

    final lists = data['lists'];
    if (lists is! List) {
      return const [];
    }

    return lists
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _totalPagesFromResponse(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) return 1;

    final metaData = data['meta_data'];
    if (metaData is! Map<String, dynamic>) return 1;

    final totalPages = int.tryParse((metaData['total_page'] ?? 1).toString());
    return totalPages == null || totalPages < 1 ? 1 : totalPages;
  }

  String _pathWithQuery(String path, {required int page, required int size}) {
    final uri = Uri.parse(path);
    return uri
        .replace(
          queryParameters: {
            ...uri.queryParameters,
            'page': page.toString(),
            'size': size.toString(),
          },
        )
        .toString();
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
