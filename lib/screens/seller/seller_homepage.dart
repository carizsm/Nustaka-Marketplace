import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import 'seller_order.dart';
import 'seller_transaction.dart';
import 'seller_tambah_produk.dart';
import 'seller_statistik_toko.dart';
import 'seller_statistik_produk.dart';
import 'seller_profil.dart';
import 'seller_edit_produk.dart';
import 'seller_notification.dart';

class SellerHomepage extends StatefulWidget {
  const SellerHomepage({super.key});

  @override
  State<SellerHomepage> createState() => _SellerHomepageState();
}

class _SellerHomepageState extends State<SellerHomepage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SellerHomeContent(),
    const SellerOrderPage(),
    const SellerTransactionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9EB23B),
        elevation: 0,
        title: const Text(
          'Halo, Penjual',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerNotificationPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerProfilPage()));
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF9EB23B),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaction'),
        ],
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF9EB23B),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TambahProdukPage()));
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class SellerHomeContent extends StatefulWidget {
  const SellerHomeContent({super.key});

  @override
  State<SellerHomeContent> createState() => _SellerHomeContentState();
}

class _SellerHomeContentState extends State<SellerHomeContent> {
  List<FullyEnrichedProduct> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final result = await ApiService().getMyProducts();
      setState(() {
        _products = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!, style: TextStyle(color: Colors.red)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboard(context),
          const SizedBox(height: 24),
          const Text("Produk", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          if (_products.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9C3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.yellow.shade700),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Belum ada produk yang ingin dijual.\nTambahkan produkmu dengan menekan tombol ➕ di kanan bawah.",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._products.map((product) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildProductCard(context, product),
                )),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Text('Hari ini', style: TextStyle(fontSize: 16)),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SellerStatistikToko()));
              },
              child: const Text('Lihat Statistik toko >', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildDashboardItem('20', 'Pesanan Baru', '+Rp200 rb'),
            const SizedBox(width: 8),
            _buildDashboardItem('12', 'Siap Dikirim', '+Rp65 rb'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildDashboardItem('0', 'Dibatalkan', ''),
            const SizedBox(width: 8),
            _buildDashboardItem('0', 'Komplain', ''),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardItem(String number, String label, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(number, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 4),
              Text(label),
              if (subtitle.isNotEmpty)
                Text('Potensi $subtitle', style: const TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, FullyEnrichedProduct product) {
    final image = product.imageUrl.isNotEmpty ? product.imageUrl : 'https://via.placeholder.com/150';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        product.visible ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Rp ${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${product.rating} • ${product.totalSold} terjual', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SellerStatistikProduk(
                                  namaProduk: product.name,
                                  lokasi: product.location ?? '-',
                                  deskripsi: product.description,
                                  harga: 'Rp ${product.price}',
                                  gambar: image,
                                  terjual: product.totalSold,
                                  dilihat: 0,
                                  dipesan: 0,
                                  rating: product.rating,
                                  ulasan: {},
                                ),
                              ),
                            );
                          },
                          child: const Text('Statistik'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProdukPage(
                                  productId: product.id,
                                  namaProduk: product.name,
                                  deskripsi: product.description,
                                  detail: product.briefHistory ?? '-',
                                  harga: product.price.toInt(),
                                  stok: product.stock,
                                  satuan: product.category ?? 'Pcs',
                                  kategori: product.categoryId ?? '-',
                                  wilayah: product.regionId ?? '-',
                                  visible: product.visible,
                                ),
                              ),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
