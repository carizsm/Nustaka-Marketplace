import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import '../../models/transactiondata.dart';

class SellerStatistikToko extends StatefulWidget {
  const SellerStatistikToko({super.key});

  @override
  State<SellerStatistikToko> createState() => _SellerStatistikTokoState();
}

class _SellerStatistikTokoState extends State<SellerStatistikToko> {
  bool _isLoading = true;

  double totalPendapatanKotor = 0;
  double totalPendapatanBersih = 0;
  int totalProdukDipesan = 0;
  double avgRating = 0.0;
  int totalUlasan = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistik();
  }

  Future<void> _loadStatistik() async {
    try {
      final transaksi = await ApiService().getMyTransactions();
      final produk = await ApiService().getMyProducts();

      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 6));

      for (var t in transaksi) {
        final tanggal = t.createdAt ?? DateTime.now();
        if (tanggal.isAfter(start.subtract(const Duration(days: 1)))) {
          totalPendapatanKotor += t.totalAmount;
          if (t.status.toLowerCase() == 'completed') {
            totalPendapatanBersih += t.totalAmount;
          }
        }
      }

      totalProdukDipesan = transaksi.length;

      final reviews = produk.map((p) => p.reviewSummary).whereType<ReviewSummary>();
      double totalRating = 0;
      for (var r in reviews) {
        totalRating += (r.averageRating ?? 0.0) * r.reviewCount;
        totalUlasan += r.reviewCount;
      }

      avgRating = totalUlasan > 0 ? totalRating / totalUlasan : 0;

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistik Toko'),
        backgroundColor: const Color(0xFF9ACD32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rutin pantau perkembangan toko untuk tingkatkan penjualanmu.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(_buildDateRange(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildStatCard("Rp ${totalPendapatanKotor.toStringAsFixed(0)}", "+3%", "Pendapatan Kotor"),
                      _buildStatCard("—", "", "Produk Dilihat"),
                      _buildStatCard("$totalProdukDipesan", "+2,3%", "Produk Dipesan"),
                      _buildStatCard("—", "", "Komplain"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildRatingSection(),
                  const SizedBox(height: 24),
                  const Text("Jumlah Pendapatan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text("Cek pemasukan dari transaksi selesai di tokomu."),
                  const SizedBox(height: 12),
                  Text("Rp ${totalPendapatanBersih.toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String value, String change, String label) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
          const SizedBox(height: 4),
          if (change.isNotEmpty)
            Text(change, style: const TextStyle(fontSize: 12, color: Colors.green)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rating & Ulasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 32),
              const SizedBox(width: 8),
              Text("${avgRating.toStringAsFixed(1)} / 5.0",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Text("$totalUlasan ulasan"),
        ],
      ),
    );
  }

  String _buildDateRange() {
    final now = DateTime.now();
    final end = now;
    final start = now.subtract(const Duration(days: 6));
    String format(DateTime d) =>
        "${d.day.toString().padLeft(2, '0')} ${_monthName(d.month)}";
    return "7 hari terakhir (${format(start)} - ${format(end)})";
  }

  String _monthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month];
  }
}
