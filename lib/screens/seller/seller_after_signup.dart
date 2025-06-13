import 'package:flutter/material.dart';
import 'seller_homepage.dart';

class SellerAfterSignupPage extends StatelessWidget {
  const SellerAfterSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F898),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline, color: Colors.black))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Datang di Nustaka",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MarcellusSC',
                  color: Color(0xFF8B0000),
                )),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: 'Nama lengkap',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                backgroundColor: const Color(0xFFD96D29),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Lanjut"),
            ),
          ],
        ),
      ),
    );
  }
}
