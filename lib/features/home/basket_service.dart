import 'package:meal_flavor/core/services/api_client.dart';
import 'package:meal_flavor/features/client/panier.dart';

class BasketService {
  BasketService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Panier>> fetchBaskets({String? category}) async {
    final params = <String>[];
    if (category != null && category != 'all') {
      params.add('category=$category');
    }
    final path = params.isEmpty ? '/api/baskets' : '/api/baskets?${params.join('&')}';
    final response = await _apiClient.get(path);
    final items = response['baskets'];
    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => _mapBasketToPanier(Map<String, dynamic>.from(item)))
        .toList();
  }

  Panier _mapBasketToPanier(Map<String, dynamic> basket) {
    final merchant = basket['merchant'] is Map<String, dynamic>
        ? basket['merchant'] as Map<String, dynamic>
        : <String, dynamic>{};

    final originalPrice = _toDouble(basket['originalPrice']);
    final discountedPrice = _toDouble(basket['discountedPrice']);
    final reduction = originalPrice > 0
        ? ((1 - (discountedPrice / originalPrice)) * 100).round()
        : 0;

    return Panier(
      id: basket['id']?.toString() ?? '',
      nom: merchant['businessName']?.toString() ?? basket['title']?.toString() ?? 'Commerce',
      categorie: _mapCategoryLabel(basket['category']?.toString()),
      imageUrl: basket['photoURL']?.toString() ??
          merchant['photoURL']?.toString() ??
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
      prixOriginal: originalPrice,
      prixReduit: discountedPrice,
      reduction: reduction,
      contenuPanier: basket['description']?.toString() ?? 'Panier surprise',
      heureRetrait: _formatPickupWindow(
        basket['pickupTimeStart']?.toString(),
        basket['pickupTimeEnd']?.toString(),
      ),
      adresseRetrait: merchant['address']?.toString() ?? '',
      distance: 0.0,
      paniersDisponibles: _toInt(basket['availableQuantity']),
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String _formatPickupWindow(String? start, String? end) {
    final startDt = start != null ? DateTime.tryParse(start) : null;
    final endDt = end != null ? DateTime.tryParse(end) : null;

    if (startDt == null || endDt == null) return 'Horaires à confirmer';

    String format(DateTime dt) {
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }

    return '${format(startDt)} - ${format(endDt)}';
  }

  String _mapCategoryLabel(String? raw) {
    switch (raw) {
      case 'SWEET':
        return 'Sucré';
      case 'SAVORY':
        return 'Salé';
      case 'MIXED':
        return 'Mixte';
      default:
        return raw ?? 'Mixte';
    }
  }
}
