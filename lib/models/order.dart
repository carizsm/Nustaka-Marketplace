class OrderItem {
  final String productName;
  final int quantity;
  final int pricePerItem;
  final List<String> images;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.pricePerItem,
    required this.images,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final product = json['productDetails'] ?? {};
    return OrderItem(
      productName: product['name'] ?? 'Unknown Product',
      quantity: json['quantity'] ?? 0,
      pricePerItem: json['price_per_item'] ?? 0,
      images: (product['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class OrderData {
  final String invoice;
  final String customerName;
  final String deadline;
  final String status;
  final List<OrderItem> items;

  OrderData({
    required this.invoice,
    required this.customerName,
    required this.deadline,
    required this.status,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      invoice: json['invoice'] ?? '',
      customerName: json['customer_name'] ?? '',
      deadline: json['deadline'] ?? '',
      status: json['status'] ?? '',
      items: (json['items'] as List)
          .map((itemJson) => OrderItem.fromJson(itemJson))
          .toList(),
    );
  }
}
