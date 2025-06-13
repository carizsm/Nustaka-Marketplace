import 'package:flutter/material.dart';
import 'seller_signup_phone.dart';
import 'seller_after_signup.dart';


class SellerSignupEmailPage extends StatelessWidget {
  const SellerSignupEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F898),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ayo Berjualan di Nustaka",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'MarcellusSC',
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 24),

            // Email
            TextField(
              decoration: InputDecoration(
                hintText: 'E-mail',
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol daftar
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SellerAfterSignupPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9A25F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Daftar",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),


            const SizedBox(height: 24),
            const Center(
              child: Text(
                "atau daftar dengan",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 12),

            // Google
            ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/google.png', 
                height: 24,
              ),
              label: const Text("Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF86A340),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Nomor telepon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SellerSignupPhonePage()),
                );
              },
              icon: const Icon(Icons.phone_android),
              label: const Text("Nomor telepon"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF86A340),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Syarat dan Ketentuan
            const Text.rich(
              TextSpan(
                text: "Dengan daftar di sini, anda menyetujui ",
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: "Syarat & Ketentuan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " serta "),
                  TextSpan(
                    text: "Kebijakan Privasi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " Nustaka"),
                ],
              ),
            ),

            const Spacer(),

            // Sudah punya akun
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); 
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Sudah punya akun? ",
                    children: [
                      TextSpan(
                        text: "Masuk",
                        style: TextStyle(
                          color: Color(0xFF86A340),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
