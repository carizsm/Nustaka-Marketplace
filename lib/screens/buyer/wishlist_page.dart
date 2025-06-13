import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/product.dart';
import 'transaction_page.dart';
import 'user_profille.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<FullyEnrichedProduct> wishlistProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlistProducts();
  }

  Future<void> _loadWishlistProducts() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);

    final List<FullyEnrichedProduct> products = wishlistJson
        .map((e) => FullyEnrichedProduct.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      wishlistProducts = products;
      isLoading = false;
    });
  }

  Future<void> _removeFromWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_products') ?? '[]';
    final List<dynamic> wishlistJson = jsonDecode(wishlistString);

    wishlistJson.removeWhere((e) => (e['id'].toString() == productId.toString()));

    await prefs.setString('wishlist_products', jsonEncode(wishlistJson));
    await _loadWishlistProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dihapus dari wishlist')),
    );
  }

  void _showBottomSheet(BuildContext context, String productId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bottomSheetItem(Icons.category, 'Lihat Barang Serupa'),
              _bottomSheetItem(Icons.store, 'Lihat Toko'),
              _bottomSheetItem(Icons.share, 'Bagikan Link Barang'),
              _bottomSheetItem(Icons.bookmark, 'Simpan ke Koleksi'),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeFromWishlist(productId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetItem(IconData icon, String text, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black),
      title: Text(
        text,
        style: TextStyle(color: isDestructive ? Colors.red : Colors.black),
      ),
      onTap: () {
        // Bisa kasih fungsi masing-masing kalau mau
      },
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.shopping_cart_checkout, size: 48, color: Colors.green),
              SizedBox(height: 10),
              Text(
                'Item Berhasil Ditambahkan!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );

    // Biar dialognya hilang otomatis setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UbahProfilPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : wishlistProducts.isEmpty
                ? const Center(child: Text('Wishlist kosong'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 10),
                      _buildFilterRow(),
                      const SizedBox(height: 10),
                      Text(
                        '${wishlistProducts.length} Barang',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: wishlistProducts.map((product) {
                            return _buildWishlistCard(
                              context,
                              product: product,
                              onRemove: () => _removeFromWishlist(product.id),
                              onMore: () => _showBottomSheet(context, product.id),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF86A340),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // ke Home
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaction'),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari barang...',
        prefixIcon: const Icon(Icons.search, color: Colors.red),
        hintStyle: const TextStyle(color: Colors.red),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        _buildDropdownFilter("Urutkan"),
        const SizedBox(width: 10),
        _buildDropdownFilter("Stok"),
        const SizedBox(width: 10),
        _buildDropdownFilter("Kategori"),
      ],
    );
  }

  Widget _buildDropdownFilter(String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: label,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: [label].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistCard(
    BuildContext context, {
    required FullyEnrichedProduct product,
    required VoidCallback onRemove,
    required VoidCallback onMore,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (product.images.isNotEmpty && product.images.first.startsWith('http'))
                  ? Image.network(
                      product.images.first,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(product.location ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('Rp ${product.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: onMore,
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () => _showSuccessPopup(context),
                  child: const Text('+ Keranjang', style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 1,
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Color(0xFF86A340)),
                  onPressed: () => onRemove(),
                  tooltip: 'Hapus dari wishlist',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
