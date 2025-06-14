import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import 'checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _cartFuture;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartFuture = _fetchCartWithProduct();
  }

  Future<List<Map<String, dynamic>>> _fetchCartWithProduct() async {
    final api = ApiService();
    final cartItems = await api.getCart();
    List<Map<String, dynamic>> result = [];
    for (var cart in cartItems) {
      try {
        final product = await api.getProductById(cart['product_id']);
        result.add({
          'cart': cart,
          'product': product,
        });
      } catch (_) {}
    }
    _cartItems = result;
    return result;
  }

  Future<void> _refreshCart() async {
    setState(() {
      _cartFuture = _fetchCartWithProduct();
    });
  }

  Future<void> _deleteCartItem(String cartItemId) async {
    await ApiService().deleteCartItem(cartItemId);
    await _refreshCart();
  }

  Future<void> _updateQuantity(String cartItemId, int newQty) async {
    if (newQty < 1) return;
    await ApiService().updateCartItem(cartItemId, newQty);
    await _refreshCart();
  }

  int get totalPrice {
    int total = 0;
    for (var i = 0; i < _cartItems.length; i++) {
      final cart = _cartItems[i]['cart'];
      total += (cart['price_per_item'] as int) * (cart['quantity'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final themeGreen = const Color(0xFF86A340);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: themeGreen,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Keranjang',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _cartFuture,
              builder: (context, snapshot) {
                final count = snapshot.data?.length ?? 0;
                return count > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$count item',
                          style: TextStyle(color: themeGreen, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat keranjang: ${snapshot.error}'));
          }
          final cartItems = snapshot.data ?? [];
          _cartItems = cartItems;
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjangmu masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF86A340),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yuk, tambahkan produk ke keranjang!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Belanja Sekarang'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshCart,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cart = cartItems[index]['cart'];
                      final FullyEnrichedProduct product = cartItems[index]['product'];
                      final int quantity = cart['quantity'] as int;
                      final int price = cart['price_per_item'] as int;
                      final int subtotal = price * quantity;

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
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${price.toString()}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => _updateQuantity(cart['id'], quantity - 1),
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade400),
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(Icons.remove, size: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '$quantity',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => _updateQuantity(cart['id'], quantity + 1),
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF86A340)),
                                              shape: BoxShape.circle,
                                              color: themeGreen.withOpacity(0.1),
                                            ),
                                            child: Icon(Icons.add, size: 20, color: themeGreen),
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                          onPressed: () async {
                                            await _deleteCartItem(cart['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Subtotal: Rp $subtotal',
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          'Rp $totalPrice',
                          style: TextStyle(
                            color: themeGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _cartItems.isEmpty
                            ? null
                            : () {
                                // Kirim seluruh produk di keranjang ke halaman checkout
                                final selectedProducts = _cartItems
                                    .map((item) => item['product'] as FullyEnrichedProduct)
                                    .toList();
                                final cartData = _cartItems
                                    .map((item) => item['cart'] as Map<String, dynamic>)
                                    .toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutPage(
                                      products: selectedProducts,
                                      cartData: cartData,
                                    ),
                                  ),
                                );
                              },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
