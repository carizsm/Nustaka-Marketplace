// lib/screens/signup_email.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'signup_phone.dart';
import 'after_signup.dart';

class SignupEmailPage extends StatefulWidget {
  const SignupEmailPage({super.key});

  @override
  State<SignupEmailPage> createState() => _SignupEmailPageState();
}

class _SignupEmailPageState extends State<SignupEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Tambahkan controller untuk username

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearErrorMessage(); // Hapus pesan error lama

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Panggil fungsi register dari provider
    final success = await authProvider.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      // Untuk phone_number dan address bisa ditambahkan field-nya jika ada,
      // atau biarkan default/kosong sesuai logika API.
    );

    if (mounted) {
      if (success) {
        Navigator.pushReplacement( // Ganti ke pushReplacement agar tidak bisa kembali
          context,
          MaterialPageRoute(builder: (_) => const AfterSignupPage()),
        );
      } else {
        // Tampilkan error menggunakan Snackbar atau di UI
        final errorMessage = authProvider.errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Registrasi gagal. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F898),
      appBar: AppBar(
        // ... (appBar tetap sama)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar ke Nustaka",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'MarcellusSC',
                  color: Color(0xFF8B0000),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
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
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
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
              const SizedBox(height: 20),

              // Tombol daftar dan state loading
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return auth.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _submitRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9A25F),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),

              // ... (sisa UI Anda tetap sama)

              const SizedBox(height: 24),
              const Center(child: Text("atau daftar dengan")),
              const SizedBox(height: 12),
              // Tombol Google
              ElevatedButton.icon(onPressed: (){}, icon: Image.asset('assets/icons/google.png', height: 24), label: const Text("Google"), /* ... style ... */),
              const SizedBox(height: 12),
              // Tombol Nomor Telepon
              ElevatedButton.icon(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPhonePage())); }, icon: const Icon(Icons.phone_android), label: const Text("Nomor telepon"), /* ... style ... */),
              const SizedBox(height: 20),
              // Sudah punya akun
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Hapus pesan error sebelumnya jika ada saat pindah halaman
                    Provider.of<AuthProvider>(context, listen: false).clearErrorMessage();
                    // Kembali ke halaman login sebelumnya
                    Navigator.of(context).pop();
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Sudah punya akun? ",
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Masuk",
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
            ],
          ),
        ),
      ),
    );
  }
}