import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<Map<String, dynamic>>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = _fetchWishlist();
  }

  Future<List<Map<String, dynamic>>> _fetchWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);
    final List<Map<String, dynamic>> result = wishlistJson
        .where((e) => e is Map)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return result;
  }

  Future<void> _removeFromWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);

    wishlistJson.removeWhere((e) => (e['id'].toString() == productId.toString()));

    await prefs.setString('wishlist_products', jsonEncode(wishlistJson));
    setState(() {
      _wishlistFuture = _fetchWishlist();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dihapus dari wishlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeGreen = const Color(0xFF86A340);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: themeGreen,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final wishlistItems = snapshot.data ?? [];
          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 90, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Wishlist kamu masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF86A340),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yuk, tambahkan produk favoritmu!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: wishlistItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = wishlistItems[index];
              final images = product['images'];
              final imageUrl = (images is List && images.isNotEmpty && images[0].toString().startsWith('http'))
                  ? images[0]
                  : null;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name']?.toString() ?? '-',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${product['price']?.toString() ?? '-'}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['location']?.toString() ?? '-',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _removeFromWishlist(product['id'].toString()),
                        tooltip: 'Hapus dari wishlist',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
