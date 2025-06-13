// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// Impor model Anda
import '../models/product.dart'; // Sesuaikan path
import '../models/order.dart';
import '../models/transaction.dart';
// ... impor model lain

class ApiService {
  // Sesuaikan dengan base URL API Anda
  // Untuk Android Emulator dari API lokal:
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (includeAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // Contoh: Login User
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: await _getHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Simpan token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', data['token'] as String);
      return data; // Mengembalikan {'token': ..., 'user': ...}
    } else {
      // Coba parse pesan error dari API
      String message = 'Login failed';
      try {
        message = jsonDecode(response.body)['message'] ?? message;
      } catch (_) {}
      throw Exception('$message (Status: ${response.statusCode})');
    }
  }

  // Contoh: Mendapatkan Daftar Produk (FullyEnrichedProduct)
  Future<List<FullyEnrichedProduct>> getProducts({
    String? categoryId,
    String? regionId,
    int page = 1,
    int limit = 10
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (regionId != null) queryParams['region_id'] = regionId;

    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); // Handle karakter UTF-8
      final Map<String, dynamic> data = jsonDecode(decodedBody);
      final List<dynamic> productListJson = data['data'] as List<dynamic>;
      return productListJson.map((json) => FullyEnrichedProduct.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load products (Status: ${response.statusCode})');
    }
  }

  // Contoh: Mendapatkan Detail Produk
  Future<FullyEnrichedProduct> getProductById(String productId) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: await _getHeaders()
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return FullyEnrichedProduct.fromJson(jsonDecode(decodedBody) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw Exception('Product not found (Status: 404)');
    }
    else {
      throw Exception('Failed to load product details (Status: ${response.statusCode})');
    }
  }

  // Add product to cart
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    final url = Uri.parse('$_baseUrl/cart');
    final headers = await _getHeaders(includeAuth: true);
    final body = jsonEncode({
      'product_id': productId,
      'quantity': quantity,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to cart: ${response.body}');
    }
  }

  // Get all cart items
  Future<List<Map<String, dynamic>>> getCart() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cart'),
      headers: await _getHeaders(includeAuth: true),
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final dynamic data = jsonDecode(decodedBody);

      List<dynamic> cartListJson;
      if (data is List) {
        cartListJson = data;
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        cartListJson = data['data'];
      } else {
        throw Exception('Unexpected cart response format');
      }

      return cartListJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Update cart item quantity
  Future<void> updateCartItem(String cartItemId, int quantity) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/cart/$cartItemId'),
      headers: await _getHeaders(includeAuth: true),
      body: jsonEncode({'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }

  // Delete cart item
  Future<void> deleteCartItem(String cartItemId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cart/$cartItemId'),
      headers: await _getHeaders(includeAuth: true),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart item');
    }
  }


  // getMyProducts (untuk seller)
  Future<List<FullyEnrichedProduct>> getMyProducts() async {
    final uri = Uri.parse('$_baseUrl/products/my');
    final response = await http.get(uri, headers: await _getHeaders(includeAuth: true));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody) as Map<String, dynamic>;
      final List<dynamic> productsJson = data['data'];
      return productsJson.map((e) => FullyEnrichedProduct.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      // 404 berarti data kosong → kembalikan list kosong, bukan lempar error
      return [];
    } else {
      throw Exception('Gagal memuat produk saya. Status: ${response.statusCode}');
    }
  }

  // getMyOrders (untuk seller)
  Future<List<OrderData>> getMyOrders() async {
    final uri = Uri.parse('$_baseUrl/orders'); // ✅ endpoint benar
    final response = await http.get(uri, headers: await _getHeaders(includeAuth: true));

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);
      final List<dynamic> list = data['data'];
      return list.map((e) => OrderData.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Gagal memuat daftar order');
    }
  }

  // getmyTransactions (untuk seller)
  Future<List<TransactionData>> getMyTransactions() async {
    final uri = Uri.parse('$_baseUrl/seller/transactions');
    final response = await http.get(uri, headers: await _getHeaders(includeAuth: true));

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);
      final List<dynamic> list = data['data'];
      return list.map((e) => TransactionData.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat daftar transaksi');
    }
  }

  // createProduct (untuk seller)
  Future<void> createProduct({
    required String name,
    required String detail,
    required String description,
    required int stock,
    required String unit,
    required int price,
    required bool visible,
  }) async {
    final uri = Uri.parse('$_baseUrl/seller/products');
    final response = await http.post(
      uri,
      headers: await _getHeaders(includeAuth: true),
      body: jsonEncode({
        'name': name,
        'detail': detail,
        'description': description,
        'stock': stock,
        'unit': unit,
        'price': price,
        'visible': visible,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan produk. Status: ${response.statusCode}');
    }
  }

  // updateProduct (untuk seller)
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String detail,
    required String description,
    required int stock,
    required String unit,
    required int price,
    required bool visible,
  }) async {
    final uri = Uri.parse('$_baseUrl/products/$productId');

    final body = jsonEncode({
      'name': name,
      'detail': detail,
      'description': description,
      'stock': stock,
      'unit': unit,
      'price': price,
      'visible': visible,
    });

    final response = await http.put(
      uri,
      headers: await _getHeaders(includeAuth: true),
      body: body,
    );

    if (response.statusCode == 200) {
      // Update sukses
      return;
    } else {
      String message = 'Failed to update product';
      try {
        final decoded = jsonDecode(response.body);
        message = decoded['message'] ?? message;
      } catch (_) {}
      throw Exception('$message (Status: ${response.statusCode})');
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? phoneNumber,
    String? address,
    String role = 'buyer', // Default role adalah 'buyer'
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/register'),
        headers: await _getHeaders(),
        body: jsonEncode(<String, String?>{
          'username': username,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
          'address': address,
          'role': role,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201) { // Kode status 201 untuk 'Created'
        if (responseBody.containsKey('token')) {
          // Simpan token setelah registrasi berhasil
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', responseBody['token'] as String);
          return responseBody; // Mengembalikan {'token': ..., 'user': ...}
        } else {
          throw Exception('Registration response format is invalid: Missing token.');
        }
      } else {
        String message = 'Registration failed';
        if (responseBody.containsKey('message')) {
          message = responseBody['message'] as String;
        }
        throw Exception('$message (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('ApiService Register Error: $e');
      throw Exception('An error occurred during registration: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
}



