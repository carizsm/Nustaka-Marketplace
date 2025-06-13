import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F898),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150),
            const SizedBox(height: 20),
            Text(
              "Nustaka",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w400,
                fontFamily: 'MarcellusSC',
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Immerse in History,\nInspire Culture",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'MarcellusSC',
                color: Color(0xFF8B0000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
