import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pc_build.dart';

enum CompareMode { products, pcBuilds }

class CompareProvider extends ChangeNotifier {
  CompareMode _mode = CompareMode.products;
  final List<Product> _selectedProducts = [];
  final List<PCBuild> _selectedBuilds = [];

  CompareMode get mode => _mode;
  List<Product> get selectedProducts => _selectedProducts;
  List<PCBuild> get selectedBuilds => _selectedBuilds;

  bool get isEmpty => _mode == CompareMode.products ? _selectedProducts.isEmpty : _selectedBuilds.isEmpty;
  int get count => _mode == CompareMode.products ? _selectedProducts.length : _selectedBuilds.length;

  void setMode(CompareMode newMode) {
    if (_mode != newMode) {
      _mode = newMode;
      clear();
    }
  }

  // --- Laptop / Component Comparison Logic ---
  bool addProduct(Product product) {
    setMode(CompareMode.products);

    // Limit to 3 items for mobile screen width
    if (_selectedProducts.length >= 3) return false; 
    
    // Prevent duplicate items
    if (_selectedProducts.any((p) => p.id == product.id)) return false;

    // Only allow comparing items of the SAME category (e.g. Laptops to Laptops)
    if (_selectedProducts.isNotEmpty) {
      if (_selectedProducts.first.categoryId != product.categoryId) {
        return false; 
      }
    }

    _selectedProducts.add(product);
    notifyListeners();
    return true;
  }

  void removeProduct(String productId) {
    _selectedProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // --- PC Build Comparison Logic ---
  bool addBuild(PCBuild build) {
    setMode(CompareMode.pcBuilds);

    // Limit to 2 custom builds side-by-side
    if (_selectedBuilds.length >= 2) return false; 
    if (_selectedBuilds.any((b) => b.id == build.id)) return false;

    _selectedBuilds.add(build);
    notifyListeners();
    return true;
  }

  void removeBuild(String buildId) {
    _selectedBuilds.removeWhere((b) => b.id == buildId);
    notifyListeners();
  }

  void clear() {
    _selectedProducts.clear();
    _selectedBuilds.clear();
    notifyListeners();
  }
}