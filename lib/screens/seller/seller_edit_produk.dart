import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'seller_homepage.dart';

final Color primaryGreen = Color(0xFF86A340);
final Color secondaryYellow = Color(0xFFECF284);

class EditProdukPage extends StatefulWidget {
  final String productId;
  final String namaProduk;
  final String deskripsi;
  final String detail;
  final int harga;
  final int stok;
  final String satuan;
  final String kategori;
  final String wilayah;
  final bool visible;

  const EditProdukPage({
    super.key,
    required this.productId,
    required this.namaProduk,
    required this.deskripsi,
    required this.detail,
    required this.harga,
    required this.stok,
    required this.satuan,
    required this.kategori,
    required this.wilayah,
    required this.visible,
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
  late TextEditingController _kategoriController;

  bool _isLoading = false;
  bool _visibility = true;
  String _selectedSatuan = 'Pcs';
  String _selectedCurrency = 'Rp';

  final List<String> _availableRegions = [
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'DKI Jakarta',
    'Bali',
    'Sumatera Utara',
  ];
  late String _selectedRegion;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaProduk);
    _detailController = TextEditingController(text: widget.detail);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    _hargaController = TextEditingController(text: widget.harga.toString());
    _stokController = TextEditingController(text: widget.stok.toString());
    _kategoriController = TextEditingController(text: widget.kategori);
    _visibility = widget.visible;

    const satuanOptions = ['Pcs', 'Kg', 'Ltr'];
    _selectedSatuan = satuanOptions.contains(widget.satuan) ? widget.satuan : satuanOptions.first;
    _selectedRegion = _availableRegions.contains(widget.wilayah) ? widget.wilayah : _availableRegions.first;
  }

  @override
  Widget build(BuildContext context) {
    bool isHargaEmpty = _hargaController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Produk', style: TextStyle(color: secondaryYellow)),
        backgroundColor: primaryGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryYellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perbarui informasi produkmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildLabel('Nama Produk'),
            _textField(_namaController, 'Ketikkan nama produk kamu disini'),
            const SizedBox(height: 16),

            _buildLabel('Deskripsi Produk'),
            _textField(_deskripsiController, 'Deskripsi lengkap produk', maxLines: 4),
            const SizedBox(height: 16),

            _buildLabel('Jenis Produk'),
            _textField(_kategoriController, 'Misal: Makanan, Minuman'),
            const SizedBox(height: 16),

            _buildLabel('Wilayah Produk'),
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _availableRegions.map((region) {
                return DropdownMenuItem(value: region, child: Text(region));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRegion = value!),
            ),
            const SizedBox(height: 16),

            _buildLabel('Stok Produk'),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSatuan,
                  items: ['Pcs', 'Kg', 'Ltr']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSatuan = val!),
                ),
                const SizedBox(width: 8),
                Expanded(child: _textField(_stokController, 'Jumlah stok', type: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),

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
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Harga produk',
                      border: OutlineInputBorder(),
                    ),
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
            const SizedBox(height: 8),
            Text('Kisaran harga kompetitif : Rp 11.500 - 13.500', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),

            _buildLabel('Visibilitas Produk'),
            SwitchListTile(
              title: const Text('Aktifkan Visibilitas Produk'),
              subtitle: const Text('Jika aktif, produkmu dapat dicari oleh calon pembeli.'),
              value: _visibility,
              activeColor: primaryGreen,
              onChanged: (val) => setState(() => _visibility = val),
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: secondaryYellow,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: secondaryYellow)
                    : const Text('Simpan Perubahan'),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Hapus Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isLoading ? null : _confirmDelete,
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
          const SizedBox(height: 8),
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
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _submitEdit() async {
    setState(() => _isLoading = true);
    try {
      final stock = int.tryParse(_stokController.text.trim()) ?? 0;
      final price = int.tryParse(_hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      await ApiService().updateProduct(
        productId: widget.productId,
        name: _namaController.text.trim(),
        detail: _detailController.text.trim(),
        description: _deskripsiController.text.trim(),
        stock: stock,
        price: price,
        visible: _visibility,
        categoryId: _kategoriController.text.trim(),
        regionId: _selectedRegion,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil diperbarui')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SellerHomepage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah kamu yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteProduct();
    }
  }

  Future<void> _deleteProduct() async {
    setState(() => _isLoading = true);
    try {
      await ApiService().deleteProduct(widget.productId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SellerHomepage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
