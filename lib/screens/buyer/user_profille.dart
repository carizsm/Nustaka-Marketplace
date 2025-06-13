import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ubah Profil Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8CAC2B), // hijau seperti di screenshot
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8CAC2B),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const UbahProfilPage(),
    );
  }
}

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({Key? key}) : super(key: key);

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  // Contoh variabel untuk menampilkan apakah profil sudah terisi atau masih kosong
  // Anda bisa menggantinya dengan data nyata (misalnya dari API atau model aplikasi)
  bool isFilled = false;

  // Contoh data (dummy). Jika kosong, tampilkan null/empty string.
  final String nama = 'Eldwin Fikhar Ananda';
  final String username = 'eldwinfikhar';
  final String bio = 'Lorem ipsum dolor sit amet';
  final String userId = 'xxxxxxxx';
  final String email = 'eldwinnnnn@gmail.com';
  final String nomorHP = '6281234567890';
  final String jenisKelamin = 'Pria';
  final String tanggalLahir = '14 Juni 1998';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Ubah Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ============================
              // Bagian Foto Profil
              // ============================
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Tambahkan logika untuk mengubah foto profil
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: isFilled
                        // Jika data terisi, tampilkan foto (contoh dari network)
                            ? const NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ) as ImageProvider
                        // Jika kosong, tampilkan icon default
                            : null,
                        child: !isFilled
                            ? Icon(
                          Icons.person_outline,
                          size: 48,
                          color: Colors.grey.shade600,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ubah Foto Profil',
                      style: TextStyle(
                        color: const Color(0xFF8CAC2B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ============================
              // Bagian Info Profil
              // ============================
              Container(
                color: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Section
                    const Text(
                      'Info Profil',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // Field: Nama (tidak bisa diedit di sini, hanya nilai)
                    _buildFieldRow(
                      label: 'Nama',
                      value: isFilled ? nama : '',
                      placeholder: nama,
                      canEdit: false,
                      onTap: () {
                        // Nama biasanya tidak diedit. Bisa dihapus onTap.
                      },
                    ),
                    const SizedBox(height: 8),

                    // Field: Username (bisa diedit, ada arrow)
                    _buildFieldRow(
                      label: 'Username',
                      value: isFilled ? username : '',
                      placeholder: 'Tambah username',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman edit username
                      },
                    ),
                    const SizedBox(height: 8),

                    // Field: Bio
                    _buildFieldRow(
                      label: 'Bio',
                      value: isFilled ? bio : '',
                      placeholder: 'Tulis bio tentangmu',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman edit bio
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ============================
              // Bagian Info Pribadi
              // ============================
              Container(
                color: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Section
                    const Text(
                      'Info Pribadi',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // Field: User ID (hanya tampil)
                    _buildFieldRow(
                      label: 'User ID',
                      value: userId,
                      placeholder: userId,
                      canEdit: false,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),

                    // Field: E-mail
                    _buildFieldRow(
                      label: 'E-mail',
                      value: isFilled ? email : '',
                      placeholder: 'Tambah E-mail',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman edit e-mail
                      },
                    ),
                    const SizedBox(height: 8),

                    // Field: Nomor HP
                    _buildFieldRow(
                      label: 'Nomor HP',
                      value: isFilled ? nomorHP : '',
                      placeholder: 'Tambah nomor HP',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman edit nomor HP
                      },
                    ),
                    const SizedBox(height: 8),

                    // Field: Jenis Kelamin
                    _buildFieldRow(
                      label: 'Jenis Kelamin',
                      value: isFilled ? jenisKelamin : '',
                      placeholder: 'Pilih jenis kelamin',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman pilih jenis kelamin
                      },
                    ),
                    const SizedBox(height: 8),

                    // Field: Tanggal Lahir
                    _buildFieldRow(
                      label: 'Tanggal Lahir',
                      value: isFilled ? tanggalLahir : '',
                      placeholder: 'Tambah tanggal lahir',
                      canEdit: true,
                      onTap: () {
                        // TODO: Navigasi ke halaman pilih tanggal lahir
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              const SizedBox(height: 24),

              // ============================
              // Bagian Tombol Aksi di Bawah
              // ============================
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Tombol Hapus Akun
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Logika hapus akun
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB74D0E), // oranye
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Hapus Akun',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Keluar (Outlined)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Logika logout
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFB74D0E), // garis oranye
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB74D0E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Simpan
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Logika simpan perubahan profil
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8CAC2B), // hijau
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget pembantu untuk membuat satu baris field (label + value + panah jika editable).
  Widget _buildFieldRow({
    required String label,
    required String value,
    required String placeholder,
    required bool canEdit,
    required VoidCallback onTap,
  }) {
    final bool hasValue = value.trim().isNotEmpty;
    return InkWell(
      onTap: canEdit ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Label
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            // Nilai atau placeholder
            Expanded(
              child: Text(
                hasValue ? value : placeholder,
                style: TextStyle(
                  color: hasValue ? Colors.black87 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            // Panah (hanya jika bisa diedit)
            if (canEdit)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
