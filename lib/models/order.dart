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

class BuyerOrder {
  final String id;
  final String shippingAddress;
  final String orderStatus;
  final int subtotalItems;
  final int shippingCost;
  final int shippingInsuranceFee;
  final int applicationFee;
  final int productDiscount;
  final int shippingDiscount;
  final int totalAmount;
  final DateTime createdAt;
  final int totalItems;
  final String firstProductName;
  final String firstProductImage;

  BuyerOrder({
    required this.id,
    required this.shippingAddress,
    required this.orderStatus,
    required this.subtotalItems,
    required this.shippingCost,
    required this.shippingInsuranceFee,
    required this.applicationFee,
    required this.productDiscount,
    required this.shippingDiscount,
    required this.totalAmount,
    required this.createdAt,
    required this.totalItems,
    required this.firstProductName,
    required this.firstProductImage,
  });

  factory BuyerOrder.fromJson(Map<String, dynamic> json) {
    final itemsSummary = json['itemsSummary'] ?? {};
    final createdAt = json['created_at'];
    DateTime createdAtDate;
    if (createdAt is Map && createdAt.containsKey('_seconds')) {
      createdAtDate = DateTime.fromMillisecondsSinceEpoch(
        (createdAt['_seconds'] as int) * 1000,
      );
    } else {
      createdAtDate = DateTime.now();
    }
    return BuyerOrder(
      id: json['id'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      orderStatus: json['order_status'] ?? '',
      subtotalItems: json['subtotal_items'] ?? 0,
      shippingCost: json['shipping_cost'] ?? 0,
      shippingInsuranceFee: json['shipping_insurance_fee'] ?? 0,
      applicationFee: json['application_fee'] ?? 0,
      productDiscount: json['product_discount'] ?? 0,
      shippingDiscount: json['shipping_discount'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      createdAt: createdAtDate,
      totalItems: itemsSummary['totalItems'] ?? 0,
      firstProductName: itemsSummary['firstProductName'] ?? '',
      firstProductImage: itemsSummary['firstProductImage'] ?? '',
    );
  }
}