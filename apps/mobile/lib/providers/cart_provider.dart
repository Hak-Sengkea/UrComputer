import 'package:flutter/material.dart';
import 'package:mobile/data/repository/cart_repository.dart';
import 'package:mobile/models/cart.dart';
import 'package:mobile/models/cart_items.dart';
import 'package:mobile/models/product.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository cartRepository;
  Cart? _cart;
  List<CartItems> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  CartProvider({required this.cartRepository});

  Cart? get cart => _cart;
  String? get cartId => _cart?.id;
  List<CartItems> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get itemCount => _cartItems.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _cartItems.fold(
        0.0,
        (total, item) => total + (item.product.discountedPrice * item.quantity),
      );

  // 1. Initialize the Cart and load its items
  Future<void> initializeCart(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await cartRepository.GetOrCreateCart(userId);
      _cartItems = await cartRepository.GetCartItems(_cart!.id);
    } catch (error) {
      _errorMessage = 'Failed to load cart items';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Add an item to the Cart
  Future<void> addToCart(Product product, int quantity) async {
    if (_cart == null) {
      _errorMessage = 'Cart is not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if product is already in cart
      final existingIndex = _cartItems.indexWhere((item) => item.productId == product.id);

      if (existingIndex != -1) {
        // If it exists, add new quantity to existing quantity
        final newQuantity = _cartItems[existingIndex].quantity + quantity;
        await cartRepository.AddToCart(_cart!.id, product.id, newQuantity);
      } else {
        // If it doesn't exist, insert new item with quantity
        await cartRepository.AddToCart(_cart!.id, product.id, quantity);
      }

      // Refresh local list from database to ensure nested product properties are loaded
      _cartItems = await cartRepository.GetCartItems(_cart!.id);
    } catch (error) {
      _errorMessage = 'Failed to add item to cart';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Update quantity of an item
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await cartRepository.updateItemQuantity(itemId, quantity);
      
      // Update quantity locally for instantaneous UI update
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _cartItems[index].quantity = quantity;
      }
    } catch (error) {
      _errorMessage = 'Failed to update quantity';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Remove a single item from the Cart
  Future<void> removeFromCart(String itemId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await cartRepository.removeFromCart(itemId);
      _cartItems.removeWhere((item) => item.id == itemId);
    } catch (error) {
      _errorMessage = 'Failed to remove item';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5. Clear all items in the Cart (e.g. after successful checkout)
  Future<void> clearCart() async {
    if (_cart == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await cartRepository.clearCart(_cart!.id);
      _cartItems.clear();
    } catch (error) {
      _errorMessage = 'Failed to clear cart';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to clear cart details locally upon logout
  void clearCartLocally() {
    _cart = null;
    _cartItems = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Helper method to clear items list locally after order placement
  void clearLocalCart() {
    _cartItems = [];
    notifyListeners();
  }
}