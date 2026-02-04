import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(
      uri,
      headers: _headers(token),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.post(
      uri,
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.put(
      uri,
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.delete(
      uri,
      headers: _headers(token),
    );
    return _handleResponse(response);
  }

  Map<String, String> _headers(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {};
    }

    final message = body is Map<String, dynamic> && body['message'] != null
        ? body['message'].toString()
        : body is Map<String, dynamic> && body['error'] != null
            ? body['error'].toString()
            : 'Request failed (${response.statusCode})';

    // If there are validation errors (e.g., from a 400 Bad Request),
    // the backend might send a 'details' or 'errors' field.
    if (body is Map<String, dynamic> && (body['details'] != null || body['errors'] != null)) {
      String validationErrors = '';
      if (body['details'] is List) {
        validationErrors = body['details'].map((e) => e.toString()).join(', ');
      } else if (body['details'] is String) {
        validationErrors = body['details'].toString();
      } else if (body['errors'] is Map) {
        validationErrors = (body['errors'] as Map).values.map((e) => e.toString()).join(', ');
      }
      if (validationErrors.isNotEmpty) {
        throw Exception('$message: $validationErrors');
      }
    }
    throw Exception(message);
  }
}
