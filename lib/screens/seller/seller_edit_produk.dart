import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EditProdukPage extends StatefulWidget {
  final String productId; // <--- ID produk untuk keperluan update
  final String namaProduk;
  final String deskripsi;
  final String detail;
  final String harga;
  final int stok;
  final String satuan;
  final bool visible;
  final String gambar;

  const EditProdukPage({
    super.key,
    required this.productId,
    required this.namaProduk,
    required this.deskripsi,
    required this.detail,
    required this.harga,
    required this.stok,
    required this.satuan,
    required this.visible,
    required this.gambar,
  });

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  late TextEditingController _namaController;
  late TextEditingController _detailController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late bool _visibility;
  late String _selectedSatuan;
  final Color primaryGreen = const Color(0xFF86A340);
  final Color secondaryYellow = const Color(0xFFECF284);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaProduk);
    _detailController = TextEditingController(text: widget.detail);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    _hargaController = TextEditingController(text: widget.harga);
    _stokController = TextEditingController(text: widget.stok.toString());
    _visibility = widget.visible;
    _selectedSatuan = widget.satuan;
  }

  @override
  Widget build(BuildContext context) {
    bool isHargaEmpty = _hargaController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Produk'),
        backgroundColor: primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit informasi produkmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildLabel("Nama Produk"),
            TextField(controller: _namaController, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 16),

            _buildLabel("Foto Produk"),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                image: DecorationImage(
                  image: AssetImage(widget.gambar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel("Detail Produk"),
            TextField(controller: _detailController, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 16),

            _buildLabel("Deskripsi Produk"),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            _buildLabel("Stok Produk"),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSatuan,
                  items: ['Pcs', 'Kg', 'Ltr']
                      .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedSatuan = value!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel("Harga Produk"),
            Row(
              children: [
                const Text('Rp'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visibilitas Produk', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Produk bisa dicari pembeli jika aktif.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Switch(
                    value: _visibility,
                    onChanged: (value) => setState(() => _visibility = value),
                    activeColor: primaryGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: secondaryYellow,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(text), const SizedBox(height: 8)],
    );
  }

  Future<void> _submitEdit() async {
    setState(() => _isLoading = true);
    try {
      await ApiService().updateProduct(
        productId: widget.productId,
        name: _namaController.text,
        detail: _detailController.text,
        description: _deskripsiController.text,
        stock: int.tryParse(_stokController.text) ?? 0,
        unit: _selectedSatuan,
        price: int.tryParse(_hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        visible: _visibility,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil diperbarui')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
