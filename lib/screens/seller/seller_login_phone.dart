import 'package:flutter/material.dart';
import 'seller_login_email.dart';
import 'seller_homepage.dart';
import 'seller_signup_phone.dart';


class SellerLoginPhonePage extends StatelessWidget {
  const SellerLoginPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F898),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Icon(Icons.help_outline, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Berjualan Kembali di Nustaka",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'MarcellusSC',
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              decoration: InputDecoration(
                hintText: 'Nomor telepon',
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SellerHomepage()),
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
                "Lanjut",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),
            const Center(
              child: Text(
                "atau masuk dengan",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/google.png',
                height: 22,
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

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SellerLoginEmailPage()),
                );
              },
              icon: const Icon(Icons.email),
              label: const Text("E-mail"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF86A340),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text.rich(
              TextSpan(
                text: "Dengan masuk di sini, anda menyetujui ",
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

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SellerSignupPhonePage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Belum punya akun? ",
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

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
