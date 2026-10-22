import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  
  // Latihan 1: State Tema
  bool _isDarkMode = false;
  
  // Latihan 2: State Counter
  int _visitCount = 0;

  // Latihan 3: State Favorit
  List<String> _favorites = [];

  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;
  List<String> get favorites => _favorites;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load User
    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    
    _user = User(name: name, email: email, isLoggedIn: isLoggedIn);
    
    // Load Latihan 1: Tema
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    
    // Load Latihan 2: Counter Kunjungan (Increment setiap kali app dibuka)
    _visitCount = (prefs.getInt('visit_count') ?? 0) + 1;
    await prefs.setInt('visit_count', _visitCount);

    // Load Latihan 3: Daftar Favorit
    _favorites = prefs.getStringList('favorites') ?? [];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User newUser) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);
    
    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }

  // Latihan 1: Toggle Tema
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Latihan 3: Tambah/Hapus Favorit[cite: 17]
  Future<void> addFavorite(String item) async {
    if (item.isNotEmpty && !_favorites.contains(item)) {
      _favorites.add(item);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favorites);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String item) async {
    _favorites.remove(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }
}