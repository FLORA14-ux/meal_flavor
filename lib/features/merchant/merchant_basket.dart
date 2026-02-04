class MerchantBasket {
  final String id;
  final String title;
  final String status;
  final int quantity;
  final int availableQuantity;
  final double originalPrice;
  final double discountedPrice;
  final DateTime? pickupStart;
  final DateTime? pickupEnd;

  MerchantBasket({
    required this.id,
    required this.title,
    required this.status,
    required this.quantity,
    required this.availableQuantity,
    required this.originalPrice,
    required this.discountedPrice,
    required this.pickupStart,
    required this.pickupEnd,
  });

  int get sold => (quantity - availableQuantity) < 0 ? 0 : (quantity - availableQuantity);

  String get pickupWindow {
    if (pickupStart == null || pickupEnd == null) return 'Horaires à confirmer';
    String format(DateTime dt) {
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }

    return '${format(pickupStart!)} - ${format(pickupEnd!)}';
  }
}
