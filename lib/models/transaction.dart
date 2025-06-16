class TransactionData {
  final String id;
  final String orderStatus;
  final String shippingAddress;
  final int totalAmount;
  final DateTime createdAt;

  TransactionData({
    required this.id,
    required this.orderStatus,
    required this.shippingAddress,
    required this.totalAmount,
    required this.createdAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    final createdAt = json['created_at'];
    DateTime parsedDate = DateTime.now();
    if (createdAt is Map && createdAt.containsKey('_seconds')) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(createdAt['_seconds'] * 1000);
    }

    return TransactionData(
      id: json['id'] ?? '',
      orderStatus: json['order_status'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      createdAt: parsedDate,
    );
  }

  get status => null;
}
