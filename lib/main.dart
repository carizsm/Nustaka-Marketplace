// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart'; // Path ke AuthProvider Anda
import 'screens/splashscreen.dart';   // Path ke SplashScreen Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Tambahkan provider lain di sini jika ada (misal, ProductProvider)
      ],
      child: MaterialApp(
        title: 'Nustaka',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF4F898),
          fontFamily: 'Manrope',
          // Anda bisa menambahkan tema untuk button, input, dll. di sini
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Warna teks default untuk ElevatedButton
              // backgroundColor: const Color(0xFFD9A25F), // Warna background default (bisa di-override per button)
              textStyle: const TextStyle(fontFamily: 'Manrope', fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder( // Border saat tidak error dan aktif
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black54, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder( // Border saat di-fokus
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B0000), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.black45),
            prefixIconColor: Colors.black54,
          ),
        ),
        home: const SplashScreen(), // Mulai dengan SplashScreen
      ),
    );
  }
}