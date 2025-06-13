class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final String? category;
  final String? location;
  final String? briefHistory;
  final String? status;
  final String? iconPath;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    this.category,
    this.location,
    this.briefHistory,
    this.status,
    this.iconPath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      category: json['category_id'] ?? json['region_id'],
      location: json['region_id'],
      briefHistory: json['briefHistory'],
      status: json['status'],
      iconPath: '',
    );
  }

  String get priceLabel => 'Rp ${price.toStringAsFixed(0)}';
  String get ratingLabel => '4.5 • $stock terjual';
}

class SellerInfo {
  final String id;
  final String username;

  SellerInfo({
    required this.id,
    required this.username,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class ReviewSummary {
  final double? averageRating;
  final int reviewCount;

  ReviewSummary({
    this.averageRating,
    required this.reviewCount,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}

class FullyEnrichedProduct extends Product {
  final String? categoryId;
  final String? regionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SellerInfo? sellerInfo;
  final ReviewSummary? reviewSummary;

  FullyEnrichedProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required List<String> images,
    String? category,
    String? location,
    String? briefHistory,
    String? status,
    String? iconPath,
    this.categoryId,
    this.regionId,
    this.createdAt,
    this.updatedAt,
    this.sellerInfo,
    this.reviewSummary,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    stock: stock,
    images: images,
    category: category,
    location: location,
    briefHistory: briefHistory,
    status: status,
    iconPath: iconPath,
  );

  factory FullyEnrichedProduct.fromJson(Map<String, dynamic> json) {
    return FullyEnrichedProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      category: json['category_id'],
      location: json['region_id'],
      briefHistory: json['briefHistory'],
      status: json['status'],
      categoryId: json['category_id'],
      regionId: json['region_id'],
      createdAt: _parseTimestamp(json['created_at']),
      updatedAt: _parseTimestamp(json['updated_at']),
      sellerInfo: json['sellerInfo'] != null
          ? SellerInfo.fromJson(json['sellerInfo'])
          : null,
      reviewSummary: json['reviewSummary'] != null
          ? ReviewSummary.fromJson(json['reviewSummary'])
          : null,
    );
  }

  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp is Map<String, dynamic> &&
        timestamp.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(
        timestamp['_seconds'] * 1000,
      );
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  String get imageUrl => images.isNotEmpty ? images[0] : '';
  double get rating => reviewSummary?.averageRating ?? 0.0;
  int get totalSold => stock;
  bool get visible => status?.toLowerCase() == 'active';
  String get productId => id;
}
