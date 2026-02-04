import 'package:meal_flavor/core/services/api_client.dart';
import 'package:meal_flavor/core/services/token_storage.dart';

class MerchantService {
  MerchantService({ApiClient? apiClient, TokenStorage? storage})
      : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _storage;

  Future<Map<String, dynamic>> getMyMerchant() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Veuillez vous connecter');
    }

    final response = await _apiClient.get('/api/merchants/me', token: token);
    final merchant = response['merchant'];
    if (merchant is Map<String, dynamic>) {
      return merchant;
    }
    return {};
  }

  Future<void> registerMerchant({
    required String businessName,
    required String type,
    required String address,
    required double latitude,
    required double longitude,
    required String phoneNumber,
    String? description,
    required String openingTime,
    required String closingTime,
  }) async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Veuillez vous connecter pour enregistrer votre commerce.');
    }

    final body = {
      'businessName': businessName,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };

    await _apiClient.post('/api/merchants/register', body, token: token);
  }
}
