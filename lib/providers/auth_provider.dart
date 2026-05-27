import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../core/constants.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.tokenKey);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.login(email, password);
      final token = response.data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      _token = token;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    _token = null;
    notifyListeners();
  }
}
