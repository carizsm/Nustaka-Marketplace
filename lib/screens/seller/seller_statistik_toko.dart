
import 'package:flutter/material.dart';

class SellerStatistikToko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Statistik Toko'),
        backgroundColor: Color(0xFF9ACD32), // Hijau terang
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rutin pantau perkembangan toko untuk tingkatkan penjualanmu.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text("7 hari terakhir (06 Jan - 12 Jan)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard("Rp 2.350.000", "+3%", "Pendapatan kotor"),
                _buildStatCard("34", "+1,4%", "Produk Dilihat"),
                _buildStatCard("47", "+2,3%", "Produk Dipesan"),
                _buildStatCard("0", "", "Komplain"),
              ],
            ),
            SizedBox(height: 24),
            _buildRatingSection(),
            SizedBox(height: 24),
            Text("Jumlah Pendapatan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Cek pemasukan dari transaksi selesai di tokomu."),
            SizedBox(height: 16),
            _buildIncomeGraph()
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String change, String label) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
          SizedBox(height: 4),
          if (change.isNotEmpty)
            Text(change, style: TextStyle(fontSize: 12, color: Colors.green)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rating & Ulasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 32),
              SizedBox(width: 8),
              Text("4.6 / 5.0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Text("90% pembeli merasa puas"),
          Text("7438 rating • 5233 ulasan"),
          SizedBox(height: 12),
          _buildRatingBar(5, 5155),
          _buildRatingBar(4, 1582),
          _buildRatingBar(3, 503),
          _buildRatingBar(2, 103),
          _buildRatingBar(1, 95),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, int count) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text("$star"),
        SizedBox(width: 4),
        Expanded(
          child: LinearProgressIndicator(
            value: count / 5155,
            backgroundColor: Colors.grey.shade200,
            color: Colors.lightGreen,
          ),
        ),
        SizedBox(width: 4),
        Text("($count)")
      ],
    );
  }

  Widget _buildIncomeGraph() {
    return Container(
      height: 180,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Pendapatan", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text("Rp 576.000", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text("▼ -25%", style: TextStyle(color: Colors.red)),
            ],
          ),
          Expanded(
            child: Center(child: Text("📈 Grafik dummy (bisa diganti chart lib)")),
          ),
        ],
      ),
    );
  }
}
