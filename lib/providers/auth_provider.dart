// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
// import '../models/user.dart'; // Impor jika Anda membuat model User

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;
  // User? _currentUser; // Jika Anda ingin menyimpan data user
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  // User? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authToken')) {
      return;
    }
    final storedToken = prefs.getString('authToken');
    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
      // Anda bisa menambahkan logika untuk memvalidasi token di sini jika perlu
      // atau mengambil data user berdasarkan token yang tersimpan
      // Misalnya: await fetchCurrentUser();
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Update UI untuk menunjukkan loading

    try {
      final responseData = await _apiService.login(email, password);
      _token = responseData['token'] as String?;
      // Jika API mengembalikan data user, parse dan simpan:
      // if (responseData.containsKey('user')) {
      //   _currentUser = User.fromJson(responseData['user'] as Map<String, dynamic>);
      // }
      _isLoading = false;
      notifyListeners();
      return true; // Login berhasil
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', ''); // Hapus prefix "Exception: "
      _isLoading = false;
      notifyListeners();
      return false; // Login gagal
    }
  }

  Future<void> logout() async {
    _token = null;
    // _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    // Jika Anda menyimpan data user lain di SharedPreferences, hapus juga
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}