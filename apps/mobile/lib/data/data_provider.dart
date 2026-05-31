import 'dart:convert';
import 'package:flutter/services.dart';

class JsonDataProvider {
  static final JsonDataProvider _instance = JsonDataProvider._internal();
  factory JsonDataProvider() => _instance;
  JsonDataProvider._internal();

  Map<String, dynamic>? _productsCache;
  Map<String, dynamic>? _categoriesCache;
  Map<String, dynamic>? _usersCache;
  Map<String, dynamic>? _brandsCache;

  Future<Map<String, dynamic>> loadProducts() async {
    if (_productsCache != null) return _productsCache!;
    final jsonString = await rootBundle.loadString('assets/json/products.json');
    
    _productsCache = json.decode(jsonString);
    print("Loaded successfully: ${_productsCache!['products'].length} products");
    return _productsCache!;
  }

  Future<Map<String, dynamic>> loadCategories() async {
    if (_categoriesCache != null) return _categoriesCache!;
    final jsonString = await rootBundle.loadString('assets/json/categories.json');
    _categoriesCache = json.decode(jsonString);
    return _categoriesCache!;
  }

  Future<Map<String, dynamic>> loadUsers() async {
    if (_usersCache != null) return _usersCache!;
    final jsonString = await rootBundle.loadString('assets/json/users.json');
    _usersCache = json.decode(jsonString);
    return _usersCache!;
  }

  Future<Map<String, dynamic>> loadBrands() async {
    if (_brandsCache != null) return _brandsCache!;
    final jsonString = await rootBundle.loadString('assets/json/brands.json');
    _brandsCache = json.decode(jsonString);
    return _brandsCache!;
  }

  // Clear cache when you want to reload (useful for "pull to refresh" simulation)
  void clearCache() {
    _productsCache = null;
    _categoriesCache = null;
    _usersCache = null;
    _brandsCache = null;
  }
}