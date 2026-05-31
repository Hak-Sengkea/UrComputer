import 'package:flutter/material.dart';
import '../../models/user.dart';

class AppStateProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  final List<int> _cartItems = [];

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<int> get cartItems => _cartItems;
  int get cartCount => _cartItems.length;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void addToCart(int productId) {
    if (!_cartItems.contains(productId)) {
      _cartItems.add(productId);
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((id) => id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(int productId) => _cartItems.contains(productId);
}
