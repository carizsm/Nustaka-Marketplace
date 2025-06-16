class TransactionData {
  final String id;
  final double totalAmount;
  final String status; // ⬅️ WAJIB ADA
  final DateTime? createdAt;

  TransactionData({
    required this.id,
    required this.totalAmount,
    required this.status, // ⬅️ WAJIB DI-INIT
    this.createdAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '', // ⬅️ PARSE DI SINI
      createdAt: _parseTimestamp(json['created_at']),
    );
  }

  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp is Map<String, dynamic> && timestamp.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp['_seconds'] * 1000);
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }
}
