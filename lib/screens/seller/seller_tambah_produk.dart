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

  // Dropdown wilayah
  final List<String> _availableRegions = [
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'DKI Jakarta',
    'Bali',
    'Sumatera Utara',
  ];
  String _selectedRegion = 'Jawa Barat';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _jenisProdukController = TextEditingController();
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
            Text('Yuk, isi informasi produkmu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            _buildLabel('Nama Produk'),
            _textField(_namaController, 'Ketikkan nama produk kamu disini'),
            SizedBox(height: 16),

            _buildLabel('Foto Produk (opsional)'),
            Container(
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
            ),
            SizedBox(height: 16),

            _buildLabel('Detail Produk'),
            _textField(_detailController, 'Detail singkat produk', maxLines: 2),
            SizedBox(height: 16),

            _buildLabel('Deskripsi Produk'),
            _textField(_deskripsiController, 'Deskripsi lengkap produk', maxLines: 4),
            SizedBox(height: 16),

            _buildLabel('Jenis Produk'),
            _textField(_jenisProdukController, 'Misal: Makanan, Minuman'),
            SizedBox(height: 16),

            _buildLabel('Wilayah Produk'),
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: _availableRegions.map((region) {
                return DropdownMenuItem(value: region, child: Text(region));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedRegion = value);
              },
            ),
            SizedBox(height: 16),

            _buildLabel('Stok Produk'),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSatuan,
                  items: ['Pcs', 'Kg', 'Ltr']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedSatuan = value!),
                ),
                SizedBox(width: 8),
                Expanded(child: _textField(_stokController, 'Jumlah stok', type: TextInputType.number)),
              ],
            ),
            SizedBox(height: 16),

            _buildLabel('Harga Produk'),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: ['Rp', '\$']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCurrency = val!),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Harga produk',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
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
            Text('Kisaran harga kompetitif : Rp 11.500 - 13.500',
                style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),

            _buildLabel('Visibilitas Produk'),
            SwitchListTile(
              title: Text('Aktifkan Visibilitas Produk'),
              subtitle: Text('Jika aktif, produkmu dapat dicari oleh calon pembeli.'),
              value: _visibilityActive,
              activeColor: primaryGreen,
              onChanged: (val) => setState(() => _visibilityActive = val),
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
                    ? CircularProgressIndicator(color: secondaryYellow)
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

  Widget _textField(TextEditingController controller, String hint,
      {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _uploadProduk() async {
    setState(() => _isLoading = true);

    try {
      if (_namaController.text.isEmpty ||
          _detailController.text.isEmpty ||
          _deskripsiController.text.isEmpty ||
          _jenisProdukController.text.isEmpty ||
          _stokController.text.isEmpty ||
          _hargaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap lengkapi semua data wajib')),
        );
        return;
      }

      final int stock = int.tryParse(_stokController.text.trim()) ?? 0;
      final int price =
          int.tryParse(_hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      await ApiService().createProduct(
        name: _namaController.text.trim(),
        detail: _detailController.text.trim(),
        description: _deskripsiController.text.trim(),
        stock: stock,
        price: price,
        visible: _visibilityActive,
        categoryId: _jenisProdukController.text.trim(),
        regionId: _selectedRegion,
        imageUrls: [],
        status: "available",
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil diunggah!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SellerHomepage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal unggah: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
