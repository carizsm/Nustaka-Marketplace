class TransactionData {
  final String invoice;
  final String customerName;
  final String productName;
  final String quantity;
  final String shippingMethod;
  final String address;
  final String arrivalTime;

  TransactionData({
    required this.invoice,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.shippingMethod,
    required this.address,
    required this.arrivalTime,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      invoice: json['invoice'],
      customerName: json['customer_name'],
      productName: json['product_name'],
      quantity: json['quantity'],
      shippingMethod: json['shipping_method'],
      address: json['address'],
      arrivalTime: json['arrival_time'],
    );
  }
}
