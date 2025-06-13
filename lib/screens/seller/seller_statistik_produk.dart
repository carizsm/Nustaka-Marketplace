import 'package:flutter/material.dart';

class SellerStatistikProduk extends StatelessWidget {
  final String namaProduk;
  final String lokasi;
  final String deskripsi;
  final String harga;
  final String gambar;
  final int terjual;
  final int dilihat;
  final int dipesan;
  final double rating;
  final Map<int, int> ulasan; // bintang -> jumlah

  const SellerStatistikProduk({
    required this.namaProduk,
    required this.lokasi,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.terjual,
    required this.dilihat,
    required this.dipesan,
    required this.rating,
    required this.ulasan,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int totalUlasan = ulasan.values.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9EB23B),
        elevation: 0,
        title: const Text('Statistik Produk'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.person_outline, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                gambar,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(lokasi, style: const TextStyle(fontSize: 14)),
            Text(namaProduk,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(deskripsi),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  harga,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (rating > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                if (terjual > 0) ...[
                  const SizedBox(width: 4),
                  Text("$terjual+ terjual"),
                ]
              ],
            ),
            const SizedBox(height: 16),
            _buildStatBox(totalUlasan),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(int totalUlasan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ringkasan Statistik Produk",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("7 hari terakhir (06 Jan - 12 Jan)"),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMiniCard(terjual, "+3%", "Produk Terjual"),
              _buildMiniCard(dilihat, "+1,4%", "Produk Dilihat"),
              _buildRatingCard(totalUlasan),
              _buildMiniCard(dipesan, "+2,3%", "Produk Dipesan"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniCard(int value, String growth, String label) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              shadows: [Shadow(blurRadius: 1, color: Colors.black12)],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$growth\n dari 7 hari lalu",
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRatingCard(int totalUlasan) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int bintang = 5; bintang >= 1; bintang--)
            _buildRatingRow(bintang, ulasan[bintang] ?? 0, totalUlasan),
          const SizedBox(height: 4),
          const Text("Rating", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRatingRow(int star, int count, int total) {
    double value = (total == 0) ? 0 : count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 4),
          Text("$star"),
          const SizedBox(width: 4),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 4),
          Text("($count)", style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
