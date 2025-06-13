import 'package:flutter/material.dart';
import 'wishlist_page.dart';
import 'notification_page.dart';
import 'user_profille.dart';

class Product {
  final String title;
  final String price;
  final String rating;
  final String location;
  final String imagePath;
  final String category;
  final String iconPath;

  const Product({
    required this.title,
    required this.price,
    required this.rating,
    required this.location,
    required this.imagePath,
    required this.category,
    required this.iconPath,
  });
}

class TransactionPage extends StatelessWidget {
  TransactionPage({Key? key}) : super(key: key);

  final List<Product> transactions = [
    Product(
      title: "Sate Madura Haji Nanang",
      price: "Rp 35.000",
      rating: "4.8 • 100+ terjual",
      location: "Madura",
      imagePath: "assets/images/sate_madura.png",
      category: "Madura",
      iconPath: "",
    ),
    Product(
      title: "Mie Kocok",
      price: "Rp 30.000",
      rating: "4.7 • 100+ terjual",
      location: "Bandung, Jawa Barat",
      imagePath: "assets/images/mie_kocok.png",
      category: "Jawa Barat",
      iconPath: "",
    ),
    Product(
      title: "Bakso Malang Jl. Keraton",
      price: "Rp 18.000",
      rating: "4.5 • 10rb+ terjual",
      location: "Jawa Timur",
      imagePath: "assets/images/bakso_malang.png",
      category: "Jawa Timur",
      iconPath: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        title: SizedBox(
          height: 36,
          child: TextField(
            style: const TextStyle(color: Colors.red),
            decoration: InputDecoration(
              hintText: 'Cari transaksi...',
              hintStyle: const TextStyle(color: Colors.red),
              prefixIcon: const Icon(Icons.search, color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF86A340)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
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
      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("Tidak ada transaksi."))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final product = transactions[index];
                return buildTransactionCard(context, product);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF86A340),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistPage()),
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

  Widget buildTransactionCard(BuildContext context, Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.red.shade100,
                  child: const Icon(Icons.broken_image, color: Colors.red),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(product.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Total Belanja', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Selesai", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF86A340),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text("Beli Lagi"),
                      ),
                    ],
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
