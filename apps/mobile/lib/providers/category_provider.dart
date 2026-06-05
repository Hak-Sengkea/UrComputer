import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../data/repository/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();
  
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  List<Category> get filteredCategories => _filteredCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _repository.getAllCategories();
      _filteredCategories = _categories;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Category?> getCategoryById(String id) async {
    return await _repository.getCategoryById(id);
  }

  Future<void> searchCategories(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredCategories = await _repository.searchCategories(query);
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
