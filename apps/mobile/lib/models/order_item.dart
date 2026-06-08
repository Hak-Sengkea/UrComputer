class OrderItem {
  final String id;
  final String orderId;
  final String? productId; // Nullable in case a product is deleted from the store
  final String productName; // Snapshot of the name
  final int quantity;
  final double price; // Snapshot of the price
  final double discount; // Snapshot of the discount
  final String? productImage; // We can join this from products table for UI presentation

  OrderItem({
    required this.id,
    required this.orderId,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.discount,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      productId: json['product_id']?.toString(),
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      // Extract image URL from nested products query if it exists
      productImage: json['product'] != null ? json['product']['image']?.toString() : null,
    );
  }
}