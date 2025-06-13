import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/order.dart';

class SellerOrderPage extends StatefulWidget {
  const SellerOrderPage({super.key});

  @override
  State<SellerOrderPage> createState() => _SellerOrderPageState();
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  List<OrderData> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final result = await ApiService().getMyOrders();
      setState(() {
        _orders = result;
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
          const Text("Daftar Order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOrderStatus("${_orders.length}", "Semua Pesanan"),
              _buildOrderStatus("${_orders.where((o) => o.status == "Menunggu Pembayaran").length}", "Menunggu Pembayaran"),
              _buildOrderStatus("${_orders.where((o) => o.status == "Siap Dikirim").length}", "Siap Dikirim"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOrderStatus("${_orders.where((o) => o.status == "Dalam Perjalanan").length}", "Dalam Perjalanan"),
              _buildOrderStatus("${_orders.where((o) => o.status == "Dibatalkan").length}", "Dibatalkan"),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text("Semua Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          if (_orders.isEmpty)
            const Text("Belum ada order.")
          else
            ..._orders.map((order) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildOrderItem(
                    order.invoice,
                    order.customerName,
                    order.deadline,
                    order.status,
                    order.items,
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildOrderItem(
  String invoice,
  String customer,
  String deadline,
  String status,
  List<OrderItem> items,
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(invoice, style: const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status,
                    style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(customer),
          const SizedBox(height: 8),
          Text("Batas Respons", style: TextStyle(color: Colors.grey[600])),
          Text(deadline, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Divider(),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Jumlah: ${item.quantity}"),
                    Text("Harga per item: Rp${item.pricePerItem}"),
                    if (item.images.isNotEmpty)
                      Image.network(item.images.first, width: 100, height: 100, fit: BoxFit.cover),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9A25F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Konfirmasi Resi"),
            ),
          ),
        ],
      ),
    ),
  );
}


  Color _getStatusColor(String status) {
    switch (status) {
      case "Pesanan Diproses":
        return Colors.orange;
      case "Menunggu Pembayaran":
        return Colors.blue;
      case "Dalam Perjalanan":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
