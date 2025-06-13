import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/product.dart'; // Gunakan model Product dari folder models
import '../../services/api_service.dart';
import 'checkout.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  Future<void> _checkWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);
    setState(() {
      isWishlisted = wishlistJson.any((e) => e['id'].toString() == widget.product.id.toString());
    });
  }

  Future<void> _toggleWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);

    final idx = wishlistJson.indexWhere((e) => e['id'].toString() == widget.product.id.toString());

    setState(() {
      if (idx != -1) {
        wishlistJson.removeAt(idx);
        isWishlisted = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dihapus dari wishlist')),
        );
      } else {
        // Manual mapping ke Map<String, dynamic>
        final productJson = {
          'id': widget.product.id,
          'name': widget.product.name,
          'description': widget.product.description,
          'price': widget.product.price,
          'images': widget.product.images,
          'location': widget.product.location,
          'stock': widget.product.stock,
          // Hapus regionId karena Product tidak punya field ini
          // tambahkan field lain jika perlu
        };
        wishlistJson.add(productJson);
        isWishlisted = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ditambahkan ke wishlist')),
        );
      }
    });

    await prefs.setString('wishlist_products', jsonEncode(wishlistJson));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? const Color(0xFF86A340) : Colors.white,
            ),
            onPressed: _toggleWishlist,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar Produk
            (product.images.isNotEmpty && product.images.first.startsWith('http'))
                ? Image.network(
              product.images.first,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            )
                : Container(
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lokasi & rating & wishlist icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.location ?? '-', // Perbaikan: fallback jika null
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  product.ratingLabel,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? const Color(0xFF86A340) : const Color(0xFF86A340),
                            ),
                            onPressed: _toggleWishlist,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("Baso Tahu Goreng, Cepat Saji, Jajanan"),
                  const SizedBox(height: 8),
                  Text(
                    product.priceLabel,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Info pengiriman
                  Row(
                    children: const [
                      Icon(Icons.delivery_dining, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Delivery"),
                      Spacer(),
                      Text("Estimasi Tiba : 30 - 40 min (3.45 km)"),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tombol aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await ApiService().addToCart(product.id, quantity: 2);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal menambah ke keranjang: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF86A340),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('+ Keranjang'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi Produk
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Deskripsi Produk", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(product.description),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}