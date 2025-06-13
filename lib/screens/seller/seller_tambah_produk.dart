import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'seller_homepage.dart';

final Color primaryGreen = Color(0xFF86A340);
final Color secondaryYellow = Color(0xFFECF284);

class TambahProdukPage extends StatefulWidget {
  @override
  _TambahProdukPageState createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  bool _visibilityActive = true;
  String _selectedSatuan = 'Pcs';
  String _selectedCurrency = 'Rp';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isHargaEmpty = _hargaController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tambah Produk', style: TextStyle(color: secondaryYellow)),
        backgroundColor: primaryGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryYellow),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SellerHomepage()),
            );
          },
        ),
        actions: [
          Icon(Icons.search, color: secondaryYellow),
          SizedBox(width: 16),
          Icon(Icons.notifications, color: secondaryYellow),
          SizedBox(width: 16),
          Icon(Icons.account_circle, color: secondaryYellow),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yuk, isi informasi produkmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            _buildLabel('Nama Produk'),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: 'Ketikkan nama produk kamu disini',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            _buildLabel('Foto Produk'),
            Container(
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
            ),
            SizedBox(height: 16),

            _buildLabel('Detail Produk'),
            TextField(
              controller: _detailController,
              decoration: InputDecoration(
                hintText: 'Ketikkan detail produk kamu disini',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            _buildLabel('Deskripsi Produk'),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ketikkan deskripsi produk kamu disini',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            _buildLabel('Stok Produk'),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSatuan,
                  items: ['Pcs', 'Kg', 'Ltr'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (value) => setState(() => _selectedSatuan = value!),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan jumlah stok produk kamu disini',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            _buildLabel('Harga Produk'),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: ['Rp', '\$'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (value) => setState(() => _selectedCurrency = value!),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Atur harga produkmu disini',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHargaEmpty ? Colors.red[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isHargaEmpty ? 'Belum Kompetitif' : 'Sudah Kompetitif',
                    style: TextStyle(
                      color: isHargaEmpty ? Colors.red[800] : Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Kisaran harga kompetitif : Rp 11.500 - 13.500', style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),

            _buildLabel('Visibilitas Produk'),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visibilitas Produk', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          'Jika aktif, produkmu dapat dicari oleh calon pembeli.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _visibilityActive,
                    onChanged: (value) => setState(() => _visibilityActive = value),
                    activeColor: primaryGreen,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: secondaryYellow,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isLoading ? null : _uploadProduk,
                child: _isLoading
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: secondaryYellow, strokeWidth: 2))
                    : Text('Upload Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 8),
        ],
      );

  Future<void> _uploadProduk() async {
    setState(() => _isLoading = true);
    try {
      await ApiService().createProduct(
        name: _namaController.text,
        detail: _detailController.text,
        description: _deskripsiController.text,
        stock: int.tryParse(_stokController.text) ?? 0,
        unit: _selectedSatuan,
        price: int.tryParse(_hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        visible: _visibilityActive,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produk berhasil diunggah!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SellerHomepage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal unggah: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
