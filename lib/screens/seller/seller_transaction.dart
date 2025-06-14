import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/transaction.dart';
import 'package:intl/intl.dart';

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

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM, HH:mm', 'id_ID');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Riwayat Transaksi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (_transactions.isEmpty)
            const Text("Belum ada transaksi.")
          else
            ..._transactions.map((tx) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTransactionCard(tx),
                )),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionData tx) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pesanan ${_capitalizeStatus(tx.orderStatus)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(tx.id),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(tx.shippingAddress)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money_rounded, size: 18),
                const SizedBox(width: 6),
                Text("Total: Rp${tx.totalAmount.toString()}"),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text("Tiba pada", style: TextStyle(color: Colors.grey[600])),
            Text(_formatDate(tx.createdAt),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _capitalizeStatus(String status) {
    return status.isEmpty ? "-" : status[0].toUpperCase() + status.substring(1);
  }
}
