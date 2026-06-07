import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _prefsKey = 'favorites_list';
  List<Product> _favorites = [];
  bool _isLoading = false;

  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;

  /// Loads favorite products from SharedPreferences
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedFavorites = prefs.getStringList(_prefsKey);

      if (storedFavorites != null) {
        _favorites = storedFavorites
            .map((item) {
              try {
                final Map<String, dynamic> json = jsonDecode(item);
                return Product.fromJson(json);
              } catch (e) {
                // If decoding a specific item fails, skip it gracefully
                debugPrint('Error decoding favorite product: $e');
                return null;
              }
            })
            .whereType<Product>()
            .toList();
      } else {
        _favorites = [];
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves the current favorites list to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> encodedFavorites =
          _favorites.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList(_prefsKey, encodedFavorites);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  /// Adds a product to favorites
  Future<void> addFavorite(Product product) async {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      await _saveFavorites();
      notifyListeners();
    }
  }

  /// Removes a product from favorites by ID
  Future<void> removeFavorite(String productId) async {
    _favorites.removeWhere((p) => p.id == productId);
    await _saveFavorites();
    notifyListeners();
  }

  /// Toggles favorite status for a product
  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      await removeFavorite(product.id);
    } else {
      await addFavorite(product);
    }
  }

  /// Helper to check if a product is favorited
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }
}
