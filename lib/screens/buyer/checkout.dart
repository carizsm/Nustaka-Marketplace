import 'package:flutter/material.dart';
import '../../models/product.dart';

class CheckoutPage extends StatelessWidget {
  final Product product;

  const CheckoutPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    int totalPrice = product.price.toInt() * quantity;

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
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
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
                          Text('Jumlah: $quantity', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Info Pengiriman (dummy)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: const [
                  Icon(Icons.delivery_dining, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Pengiriman: Reguler (Estimasi 30-40 menit)"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Rp $totalPrice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF86A340))),
              ],
            ),
            const Spacer(),
            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi proses checkout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout berhasil! (dummy)')),
                  );
                  Navigator.pop(context);
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
}
