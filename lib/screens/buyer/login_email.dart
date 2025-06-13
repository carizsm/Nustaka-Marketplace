// lib/screens/login_email.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Path ke AuthProvider Anda
import 'homepage.dart';
import 'login_phone.dart';
import 'signup_email.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final _formKey = GlobalKey<FormState>(); // Untuk validasi form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Untuk state loading tombol

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    // Hilangkan keyboard
    FocusScope.of(context).unfocus();

    // Hapus pesan error sebelumnya jika ada
    Provider.of<AuthProvider>(context, listen: false).clearErrorMessage();

    if (!(_formKey.currentState?.validate() ?? false)) {
      // Jika form tidak valid, jangan lakukan apa-apa
      return;
    }
    _formKey.currentState?.save(); // Panggil onSaved pada TextFormField jika ada

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) { // Cek apakah widget masih ada di tree
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepage()),
          );
        } else {
          // Pesan error akan ditampilkan oleh Consumer di bawah
          // atau bisa juga tampilkan snackbar di sini jika AuthProvider tidak langsung update UI
          final errorMessage = Provider.of<AuthProvider>(context, listen: false).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? 'Login gagal. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (error) { // Menangkap error umum jika ada (seharusnya sudah ditangani AuthProvider)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F898),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          // Icon(Icons.help_outline, color: Colors.black),
          // SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView( // Agar bisa di-scroll jika keyboard muncul
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form( // Bungkus dengan Form widget
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masuk ke Nustaka",
                style: TextStyle(
                  fontSize: 28, // Sedikit perbesar
                  fontFamily: 'MarcellusSC',
                  color: Color(0xFF8B0000),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField( // Ganti TextField dengan TextFormField
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  prefixIcon: const Icon(Icons.email_outlined), // Icon outline
                  // filled: true, // Sudah diatur di theme
                  // fillColor: Colors.white,
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(12),
                  //   borderSide: const BorderSide(color: Colors.black),
                  // ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'E-mail tidak boleh kosong.';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Format e-mail tidak valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Tambah spasi

              TextFormField( // Ganti TextField dengan TextFormField
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong.';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Tampilkan pesan error dari AuthProvider
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  if (auth.errorMessage != null && !_isLoading) { // Hanya tampilkan jika tidak loading
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                      child: Text(
                        auth.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Tidak ada error, tampilkan widget kosong
                },
              ),
              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFD9A25F)))
                  : ElevatedButton(
                onPressed: _submitLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9A25F),
                ),
                child: const Text(
                  "Masuk", // Ganti "Lanjut" menjadi "Masuk"
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  "atau masuk dengan",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Google Sign-In
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login dengan Google belum diimplementasikan.')),
                  );
                },
                icon: Image.asset(
                  'assets/icons/google.png', // Pastikan path ini benar dan aset ada di pubspec.yaml
                  height: 22,
                ),
                label: const Text("Google", style: TextStyle(color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Warna Google
                    // minimumSize: const Size(double.infinity, 50),
                    // textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    side: const BorderSide(color: Colors.black26)
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement( // Atau push, tergantung flow Anda
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPhonePage()),
                  );
                },
                icon: const Icon(Icons.phone_android, color: Colors.white),
                label: const Text("Nomor telepon"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86A340),
                  // minimumSize: const Size(double.infinity, 50),
                  // textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                ),
              ),
              const SizedBox(height: 32), // Tambah spasi

              const Text.rich(
                TextSpan(
                  text: "Dengan masuk di sini, anda menyetujui ",
                  style: TextStyle(fontSize: 12, color: Colors.black54), // Perkecil font
                  children: [
                    TextSpan(
                      text: "Syarat & Ketentuan",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B0000)),
                      // TODO: Tambahkan recognizer untuk navigasi ke halaman S&K
                    ),
                    TextSpan(text: " serta "),
                    TextSpan(
                      text: "Kebijakan Privasi",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B0000)),
                      // TODO: Tambahkan recognizer untuk navigasi ke halaman Kebijakan Privasi
                    ),
                    TextSpan(text: " Nustaka"),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Spasi sebelum "Belum punya akun?"

              // const Spacer(), // Hapus Spacer jika menggunakan SingleChildScrollView

              Center(
                child: GestureDetector(
                  onTap: () {
                    // Hapus pesan error sebelum navigasi
                    Provider.of<AuthProvider>(context, listen: false).clearErrorMessage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupEmailPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Daftar Sekarang",
                          style: TextStyle(
                            color: Color(0xFFD96D29),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Spasi di bawah
            ],
          ),
        ),
      ),
    );
  }
}