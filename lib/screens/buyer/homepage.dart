import 'package:flutter/material.dart';
import '../../models/product.dart' as model;
import '../../services/api_service.dart';

import 'notification_page.dart';
import 'wishlist_page.dart';
import 'transaction_page.dart';
import 'user_profille.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedCategory = 'Semua';
  bool isLoading = true;
  final ApiService apiService = ApiService();

  final categories = [
    'Semua',
    'Jawa Timur',
    'Madura',
    'Jawa Barat',
    'Kalimantan Selatan',
  ];

  List<model.FullyEnrichedProduct> allProducts = [];

  // Tambahkan controller dan state untuk pencarian
  final TextEditingController searchController = TextEditingController();
  String searchKeyword = '';

  List<model.FullyEnrichedProduct> get filteredProducts {
    List<model.FullyEnrichedProduct> products = allProducts;
    if (selectedCategory != 'Semua') {
      products = products
          .where((p) => p.regionId?.toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }
    if (searchKeyword.trim().isNotEmpty) {
      final keyword = searchKeyword.trim().toLowerCase();
      products = products
          .where((p) => p.name.toLowerCase().contains(keyword))
          .toList();
    }
    return products;
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      setState(() {
        searchKeyword = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await apiService.getProducts(limit: 100);
      setState(() {
        allProducts = products;
        isLoading = false;
      });
      print('Produk berhasil dimuat: ${products.length}');
    } catch (e) {
      print('Gagal memuat produk: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF86A340), width: 1),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.red),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 12),
                hintText: 'Cari barang...',
                hintStyle: TextStyle(color: Colors.red),
                prefixIcon: Icon(Icons.search, color: Colors.red),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UbahProfilPage()),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          kategoriFilter(),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Tidak ada produk ditemukan.'))
                : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
              children: filteredProducts.map<Widget>((product) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: selectedCategory == "Jawa Barat"
                      ? buildSimpleCard(product)
                      : buildProductCard(product),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF86A340),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WishlistPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaction'),
        ],
      ),
    );
  }

  Widget kategoriFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori',
            style: TextStyle(
              color: Color(0xFF86A340),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            iconEnabledColor: const Color(0xFF86A340),
            dropdownColor: Colors.white,
            value: selectedCategory,
            style: const TextStyle(color: Color(0xFF86A340)),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category, style: const TextStyle(color: Color(0xFF86A340))),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(model.FullyEnrichedProduct product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: (product.images.isNotEmpty && product.images.first.startsWith('http'))
                ? Image.network(
              product.images.first,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 130,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            )
                : Container(
              height: 130,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Rp ${product.price.toInt()}',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text('4.5 • ${product.stock} terjual',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(product.regionId ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSimpleCard(model.FullyEnrichedProduct product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: (product.images.isNotEmpty && product.images.first.startsWith('http'))
                ? Image.network(
              product.images.first,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 130,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            )
                : Container(
              height: 130,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}