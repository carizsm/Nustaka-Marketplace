import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/transaction.dart';

class SellerTransactionPage extends StatefulWidget {
  const SellerTransactionPage({super.key});

  @override
  State<SellerTransactionPage> createState() => _SellerTransactionPageState();
}

class _SellerTransactionPageState extends State<SellerTransactionPage> {
  List<TransactionData> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final result = await ApiService().getMyTransactions();
      setState(() {
        _transactions = result;
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
          const Text(
            "Riwayat Transaksi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            "Pesanan Selesai",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (_transactions.isEmpty)
            const Text("Belum ada transaksi.")
          else
            ..._transactions.map((tx) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTransactionItem(
                tx.invoice,
                tx.customerName,
                tx.productName,
                tx.quantity,
                tx.shippingMethod,
                tx.address,
                tx.arrivalTime,
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String invoice,
    String customer,
    String product,
    String quantity,
    String shipping,
    String address,
    String arrival,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invoice, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(customer, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            Text(product, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Jumlah Pembelian : $quantity"),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.push_pin, size: 20),
                const SizedBox(width: 8),
                Text(shipping),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Text(address),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(),
            const SizedBox(height: 12),

            Text("Tiba pada", style: TextStyle(color: Colors.grey[600])),
            Text(arrival, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
