import 'package:meal_flavor/core/services/api_client.dart';
import 'package:meal_flavor/core/services/token_storage.dart';
import 'package:meal_flavor/features/merchant/merchant_basket.dart';

class MerchantBasketService {
  MerchantBasketService({ApiClient? apiClient, TokenStorage? storage})
      : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _storage;

  Future<List<MerchantBasket>> fetchMyBaskets({required String merchantId}) async {
    final response = await _apiClient.get('/api/baskets?merchantId=$merchantId&status=ALL');
    final items = response['baskets'];
    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => _mapBasket(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<MerchantBasket> createBasket({
    required String title,
    required String category,
    required double originalPrice,
    required double discountedPrice,
    required int quantity,
    required DateTime pickupStart,
    required DateTime pickupEnd,
    String? description, // Make it nullable
    String? photoUrl, // Make it nullable
  }) async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Veuillez vous connecter');
    }

    final Map<String, dynamic> body = {
      'title': title,
      'category': category,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'quantity': quantity,
      'pickupTimeStart': pickupStart.toIso8601String(),
      'pickupTimeEnd': pickupEnd.toIso8601String(),
    };

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }
    if (photoUrl != null && photoUrl.isNotEmpty) {
      body['photoURL'] = photoUrl;
    }

    final response = await _apiClient.post(
      '/api/baskets',
      body,
      token: token,
    );

    final basket = response['basket'];
    if (basket is Map<String, dynamic>) {
      return _mapBasket(basket);
    }
    throw Exception('Impossible de créer le panier');
  }

  Future<MerchantBasket> updateStatus({
    required String id,
    required String status,
  }) async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Veuillez vous connecter');
    }

    final response = await _apiClient.put(
      '/api/baskets/$id',
      {
        'status': status,
      },
      token: token,
    );

    final basket = response['basket'];
    if (basket is Map<String, dynamic>) {
      return _mapBasket(basket);
    }
    throw Exception('Mise à jour impossible');
  }

  Future<void> deleteBasket(String id) async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Veuillez vous connecter');
    }

    await _apiClient.delete('/api/baskets/$id', token: token);
  }

  MerchantBasket _mapBasket(Map<String, dynamic> basket) {
    return MerchantBasket(
      id: basket['id']?.toString() ?? '',
      title: basket['title']?.toString() ?? 'Panier',
      status: basket['status']?.toString() ?? 'AVAILABLE',
      quantity: _toInt(basket['quantity']),
      availableQuantity: _toInt(basket['availableQuantity']),
      originalPrice: _toDouble(basket['originalPrice']),
      discountedPrice: _toDouble(basket['discountedPrice']),
      pickupStart: _toDate(basket['pickupTimeStart']),
      pickupEnd: _toDate(basket['pickupTimeEnd']),
    );
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  DateTime? _toDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
