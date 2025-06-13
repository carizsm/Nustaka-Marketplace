import 'package:flutter/material.dart';
import 'seller_user_data.dart';
import 'package:nustaka/screens/onboarding_third.dart'; // pastikan file ini sudah ada

class SellerProfilPage extends StatelessWidget {
  const SellerProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9EB23B),
        elevation: 0,
        title: const Text("Ubah Profil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/user.jpg'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Ubah Foto Profil",
                      style: TextStyle(color: Color(0xFF9EB23B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Info Profil"),
            _buildProfileItem("Nama", "Travis Scott"),
            _buildProfileItem("Username", "mangtravis"),
            _buildProfileItem("Bio", "Lorem ipsum dolor sit amet"),
            const SizedBox(height: 16),
            _buildSectionTitle("Info Pribadi"),
            _buildStaticItem("User ID", "xxxxxxxx"),
            _buildProfileItem("E-mail", "travis@gmail.com"),
            _buildProfileItem("Nomor HP", "6281234567890"),
            _buildStaticItem("Jenis Kelamin", "Pria"),
            _buildStaticItem("Tanggal Lahir", "14 Juni 1998"),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Hapus Akun (belum direvisi)
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    side: const BorderSide(color: Colors.brown),
                  ),
                  child: const Text("Hapus Akun"),
                ),

                // ✅ Tombol Keluar dengan dialog
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Keluar"),
                        content: const Text("Yakin ingin keluar dari aplikasi?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tidak"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OnboardingThird(),
                                ),
                              );
                            },
                            child: const Text("Ya"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                  child: const Text("Keluar"),
                ),

                ElevatedButton(
                  onPressed: () {
                    currentUsername = "mangtravis";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil berhasil disimpan")),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9EB23B),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _buildStaticItem(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(value),
    );
  }
}
