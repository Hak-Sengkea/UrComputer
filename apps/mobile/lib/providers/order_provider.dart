import 'package:flutter/material.dart';
import '../data/repository/order_repository.dart';
import '../models/order.dart';
import '../models/cart_items.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Logic: Loads all historical orders placed by this user
  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.getUserOrders(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logic: Orchestrates placing a new order
  Future<bool> checkout({
    required String userId,
    required String cartId,
    required List<CartItems> cartItems,
    required double totalAmount,
    required String address,
    required String city,
    String? state,
    String? zip,
    String? paymentMethod,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newOrder = await _orderRepository.createOrder(
        userId: userId,
        cartId: cartId,
        cartItems: cartItems,
        totalAmount: totalAmount,
        address: address,
        city: city,
        state: state,
        zip: zip,
        paymentMethod: paymentMethod,
      );
      
      // Add the new order to local memory list at index 0 (top of history)
      _orders.insert(0, newOrder);
      _isLoading = false;
      notifyListeners();
      return true; // Return true to indicate UI can redirect to success screen
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; // Checkout failed
    }
  }
}