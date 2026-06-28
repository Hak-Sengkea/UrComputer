import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order.dart';
import '../../models/cart_items.dart';

class OrderRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Logic: Places the order and links the cart items to it
  Future<Order> createOrder({
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
    try {
      // Cancel any existing pending orders for this user to prevent duplicate pending orders
      await _supabase
          .from('orders')
          .update({
            'status': 'cancelled',
            'payment_status': 'failed',
          })
          .eq('user_id', userId)
          .eq('status', 'pending');

      // 1. Insert the master order row into 'orders' table
      final orderResponse = await _supabase.from('orders').insert({
        'user_id': userId,
        'status': 'pending',
        'total_amount': totalAmount,
        'shipping_address': address,
        'shipping_city': city,
        'shipping_state': state,
        'shipping_zip': zip,
        'payment_status': 'pending',
        'payment_method': paymentMethod ?? 'cash_on_delivery',
      }).select().single();

      final String orderId = orderResponse['id'].toString();

      // 2. Prepare order item payloads using cart snapshots
      final List<Map<String, dynamic>> orderItemsData = cartItems.map((cartItem) {
        return {
          'order_id': orderId,
          'product_id': cartItem.productId,
          'product_name': cartItem.product.name,
          'quantity': cartItem.quantity,
          // Store historical prices at purchase time
          'price': cartItem.product.price,
          'discount': cartItem.product.discount ?? 0.0,
        };
      }).toList();

      // 3. Batch insert order items into 'order_items' table
      await _supabase.from('order_items').insert(orderItemsData);

      // 4. Note: Cart items deletion is removed from here.
      // We only clear the cart items after a successful payment transaction.

      // 5. Query and return the newly created order complete with order items
      final fullOrderResponse = await _supabase
          .from('orders')
          .select('*, order_items(*, product:products(image))')
          .eq('id', orderId)
          .single();

      return Order.fromJson(fullOrderResponse);
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  // Logic: Fetch all orders for a specific user
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('*, order_items(*, product:products(image))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load order history: $e');
    }
  }
}