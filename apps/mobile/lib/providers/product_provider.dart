import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../data/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.getAllProducts();
      _filteredProducts = _products;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredProducts = await _repository.getProductsByCategory(categoryId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductsByBrand(int brandId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredProducts = await _repository.getProductsByBrand(brandId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredProducts = await _repository.searchProducts(query);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Product?> getProductById(int id) async {
    return await _repository.getProductById(id);
  }

  Future<void> getDiscountedProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredProducts = await _repository.getDiscountedProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getInStockProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredProducts = await _repository.getInStockProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

