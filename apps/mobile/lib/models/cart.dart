import 'package:mobile/models/cart_items.dart';

class Cart {
  String id;
  String userId;
  List<CartItems> items;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: (json['user_id'] ?? json['userId']).toString(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => CartItems.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId, // Must match 'user_id' in Supabase
    };
  }
}