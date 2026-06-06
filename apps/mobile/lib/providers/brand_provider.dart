import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../data/repository/brand_repository.dart';

class BrandProvider extends ChangeNotifier {
  final BrandRepository _repository = BrandRepository();
  
  List<Brand> _brands = [];
  List<Brand> _filteredBrands = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Brand> get brands => _brands;
  List<Brand> get filteredBrands => _filteredBrands;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllBrands() async {
    _isLoading = true;
    notifyListeners();
    try {
      _brands = await _repository.getAllBrands();
      _filteredBrands = _brands;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Brand?> getBrandById(String id) async {
    return await _repository.getBrandById(id);
  }

  Future<void> searchBrands(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredBrands = await _repository.searchBrands(query);
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