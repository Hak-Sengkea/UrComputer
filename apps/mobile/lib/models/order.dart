import 'order_item.dart';

class Order {
  final String id;
  final String userId;
  final String status; // pending, processing, shipped, delivered, cancelled
  final double totalAmount;
  final String shippingAddress;
  final String shippingCity;
  final String? shippingState;
  final String? shippingZip;
  final String paymentStatus; // pending, paid, failed, refunded
  final String? paymentMethod;
  final DateTime createdAt;
  final List<OrderItem> items; // Nested list of items in this order

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.shippingAddress,
    required this.shippingCity,
    this.shippingState,
    this.shippingZip,
    required this.paymentStatus,
    this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse nested order items list if present in response
    var list = json['order_items'] as List? ?? [];
    List<OrderItem> parsedItems = list.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      shippingAddress: json['shipping_address'] as String,
      shippingCity: json['shipping_city'] as String,
      shippingState: json['shipping_state']?.toString(),
      shippingZip: json['shipping_zip']?.toString(),
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      items: parsedItems,
    );
  }
}