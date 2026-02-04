import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  AuthService({ApiClient? apiClient, TokenStorage? storage})
      : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _storage;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    String role = 'CLIENT',
  }) async {
    final response = await _apiClient.post('/api/auth/register', {
      'email': email,
      'password': password,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role,
    });

    await _saveAuthFromResponse(response);
    return response['user'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    await _saveAuthFromResponse(response);
    return response['user'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>?> me() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) return null;

    final response = await _apiClient.get('/api/auth/me', token: token);
    final user = response['user'];
    if (user is Map<String, dynamic>) {
      if (user['role'] != null) {
        await _storage.saveRole(user['role'].toString());
      }
      return user;
    }
    return null;
  }

  Future<void> signOut() async {
    await _storage.clear();
  }

  Future<void> _saveAuthFromResponse(Map<String, dynamic> response) async {
    final token = response['token']?.toString();
    if (token != null && token.isNotEmpty) {
      await _storage.saveToken(token);
    }

    final user = response['user'];
    if (user is Map<String, dynamic> && user['role'] != null) {
      await _storage.saveRole(user['role'].toString());
    }
  }
}
