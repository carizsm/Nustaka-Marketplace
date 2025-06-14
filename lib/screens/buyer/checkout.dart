import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> products;
  final List<Map<String, dynamic>> cartData;

  const CheckoutPage({super.key, required this.products, required this.cartData});

  Future<String?> _getBuyerId() async {
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences keys: ${prefs.getKeys()}');
    for (final key in prefs.getKeys()) {
      print('Key: $key, Value: ${prefs.get(key)}');
    }
    final userId = prefs.getString('userId');
    final buyerId = prefs.getString('buyer_id');
    print('userId: $userId, buyer_id: $buyerId');
    if (userId != null) return userId;
    if (buyerId != null) return buyerId;

    // Coba ambil dari JWT (authToken)
    final authToken = prefs.getString('authToken');
    if (authToken != null) {
      try {
        final parts = authToken.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          String normalized = base64.normalize(payload);
          final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));
          print('JWT payload: $payloadMap');
          if (payloadMap['id'] != null) {
            return payloadMap['id'].toString();
          }
        }
      } catch (e) {
        print('JWT parsing error: $e');
      }
    }
    return null;
  }

  List<String> _getSellerIds() {
    final sellerIds = <String>{};
    for (var cart in cartData) {
      if (cart['seller_id'] != null) {
        sellerIds.add(cart['seller_id'].toString());
      }
    }
    return sellerIds.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data sesuai payload API
    final String shippingAddress = "Jl. Rumah Buyer No. 123, Kota Bandung, Jawa Barat, 40200";
    final int shippingCost = 11500;
    final int shippingInsuranceFee = 500;
    final int applicationFee = 1000;
    final int productDiscount = 20000;
    final int shippingDiscount = 11500;

    // Hitung subtotal_items dari cartData
    int subtotalItems = 0;
    for (var cart in cartData) {
      subtotalItems += (cart['price_per_item'] as int) * (cart['quantity'] as int);
    }

    // Hitung total_amount sesuai payload API
    int totalAmount = subtotalItems +
        shippingCost +
        shippingInsuranceFee +
        applicationFee -
        productDiscount -
        shippingDiscount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ringkasan Produk
            ...products.map((product) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (product.images.isNotEmpty && product.images.first.startsWith('http'))
                          ? Image.network(
                              product.images.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(product.priceLabel, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          // Tampilkan jumlah dari cartData jika ada
                          Text(
                            'Jumlah: ${_getQtyForProduct(product, cartData)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 10),
            // Info Pengiriman
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(shippingAddress)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Breakdown biaya
            Column(
              children: [
                _row('Subtotal Barang', subtotalItems),
                _row('Ongkir', shippingCost),
                _row('Asuransi Pengiriman', shippingInsuranceFee),
                _row('Biaya Aplikasi', applicationFee),
                _row('Diskon Produk', -productDiscount),
                _row('Diskon Ongkir', -shippingDiscount),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Rp $totalAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF86A340))),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Tambahkan log isi cart backend sebelum checkout
                    final backendCart = await ApiService().getCart();
                    print('CART BACKEND: $backendCart');
                    if (backendCart.isEmpty) {
                      print('ERROR: Cart backend kosong, tidak bisa checkout');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Keranjang backend kosong, tidak bisa checkout')),
                      );
                      return;
                    }
                    print('CHECKOUT PAYLOAD:');
                    print({
                      "shipping_address": shippingAddress,
                      "subtotal_items": subtotalItems,
                      "shipping_cost": shippingCost,
                      "shipping_insurance_fee": shippingInsuranceFee,
                      "application_fee": applicationFee,
                      "product_discount": productDiscount,
                      "shipping_discount": shippingDiscount,
                      "total_amount": totalAmount,
                    });
                    await ApiService().createOrder(
                      shippingAddress: shippingAddress,
                      subtotalItems: subtotalItems,
                      shippingCost: shippingCost,
                      shippingInsuranceFee: shippingInsuranceFee,
                      applicationFee: applicationFee,
                      productDiscount: productDiscount,
                      shippingDiscount: shippingDiscount,
                      totalAmount: totalAmount,
                    );
                    // Tambahkan notifikasi ke SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    final notifString = prefs.getString('notifications') ?? '[]';
                    final List<dynamic> notifJson = jsonDecode(notifString);
                    notifJson.insert(0, {
                      "title": "Checkout Berhasil",
                      "body": "Pesanan kamu berhasil dibuat. Silakan cek status pesanan di halaman transaksi.",
                      "time": _formatNow(),
                    });
                    await prefs.setString('notifications', jsonEncode(notifJson));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout berhasil!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    print('Checkout error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checkout gagal: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86A340),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Konfirmasi & Bayar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _getQtyForProduct(Product product, List<Map<String, dynamic>> cartData) {
    try {
      final cart = cartData.firstWhere((c) => c['product_id'].toString() == product.id.toString());
      return cart['quantity'] as int? ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Widget _row(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            (value < 0 ? '- ' : '') + 'Rp ${value.abs()}',
            style: TextStyle(
              color: value < 0 ? Colors.red : Colors.black,
              fontWeight: value < 0 ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Tambahkan fungsi utilitas di bawah class CheckoutPage:
String _formatNow() {
  final now = DateTime.now();
  return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
}