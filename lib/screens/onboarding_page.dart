import 'package:flutter/material.dart';
import 'onboarding_third.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/storefront.png',
      'title': 'Immerse in History,\nInspire Culture',
      'desc':
          'Selamat datang di Nustaka, toko online produk lokal Nusantara. '
              'Setiap tenun, ukiran, dan cita rasa menyimpan kisah berharga masa lalu serta kreativitas anak bangsa.',
      'button': 'Selanjutnya →',
    },
    {
      'image': 'assets/images/culture.png',
      'title': 'Dari Akar Tradisi ke\nEtalase Digital',
      'desc':
          'Nustaka mengangkat produk lokal Indonesia ke panggung global sambil merayakan warisan budaya di baliknya. '
              'Setiap belanja mendukung pelestarian budaya.',
      'button': 'Mulai →',
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingThird()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F898),
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final item = onboardingData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(item['image']!, height: 250),
                Column(
                  children: [
                    Text(
                      item['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF8B0000),
                        fontFamily: 'MarcellusSC',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item['desc']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B0000),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: nextPage,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item['button']!,
                      style: TextStyle(
                        color: Color(0xFF8B0000),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'MarcellusSC',
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
