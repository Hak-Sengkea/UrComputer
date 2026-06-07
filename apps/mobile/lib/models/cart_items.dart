import 'product.dart'; // 1. Add this import

class CartItems {
  String id;
  String cartId;
  String productId;
  int quantity;
  Product product; // 2. Add the Product field here

  CartItems({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.product, // 3. Add to constructor
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      // Note: Supabase columns are snake_case ('cart_id' and 'product_id')
      id: json['id'].toString(),
      cartId: (json['cart_id'] ?? json['cartId']).toString(),
      productId: (json['product_id'] ?? json['productId']).toString(),
      quantity: json['quantity'] as int,
      
      // 4. Parse the nested product details
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}