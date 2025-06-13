import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DetailTransaksiPage(),
    );
  }
}

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: Color(0xFFECF284)), // Warna teks title
        ),
        leading: const BackButton(color: Color(0xFFECF284)), // Warna ikon back
        backgroundColor: const Color(0xFF86A340), // Warna latar AppBar
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Pesanan Selesai"),
            _infoRow("INV/20250204/XXX/3456789812", "Lihat Invoice", colorRight: Colors.green),
            const SizedBox(height: 4),
            const Text("Tanggal Pembelian: 04 Februari 2025, 09:45 WIB", style: TextStyle(fontSize: 12)),

            const Divider(height: 32),

            _sectionTitle("Detail Produk"),
            Row(
              children: [
                Container(width: 50, height: 50, color: Colors.grey[300]),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("[NAMA BARANG]", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("1 x Rp 59.000"),
                  ],
                ),
              ],
            ),

            const Divider(height: 32),

            _sectionTitle("Info Pengiriman"),
            _infoRow("Kurir", "JNE"),
            _infoRow("No. Resi", "XXX00-YYYY8888"),
            const SizedBox(height: 10),
            const Text("Eldwin Fikhar Ananda", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              "Jl. Taman Riviera No. 31, Cluster Riviera, Palem Semi, "
                  "Kel. Bencongan, Kec. Bencongan, Kab. Tangerang, Banten 15810",
              style: TextStyle(fontSize: 12),
            ),

            const Divider(height: 32),

            _sectionTitle("Rincian Pembayaran"),
            _infoRow("Metode Pembayaran", "QRIS"),
            _infoRow("Subtotal Harga Barang", "Rp59.000"),
            _infoRow("Kupon Diskon Barang", "-Rp20.000"),
            _infoRow("Total Ongkos Kirim", "Rp11.500"),
            _infoRow("Kupon Diskon Ongkos Kirim", "-Rp11.500"),
            _infoRow("Asuransi Pengiriman", "Rp500"),
            _infoRow("Biaya Jasa Aplikasi", "Rp1.000"),
            const SizedBox(height: 10),
            const Divider(),
            _infoRow("Total Belanja", "Rp40.500", bold: true),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _infoRow(String left, String right, {bool bold = false, Color? colorRight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(
            right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: colorRight,
            ),
          ),
        ],
      ),
    );
  }
}
