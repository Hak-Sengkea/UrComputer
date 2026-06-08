import 'package:supabase_flutter/supabase_flutter.dart';

class ProductImage {
  final String id;
  final String imageUrl;
  final String viewAngle;
  final int displayOrder;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.viewAngle,
    required this.displayOrder,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = (json['image_url'] ?? '').toString();
    final resolvedImageUrl =
        rawImageUrl.isEmpty || rawImageUrl.startsWith('http')
        ? rawImageUrl
        : Supabase.instance.client.storage
              .from('products')
              .getPublicUrl(rawImageUrl);

    return ProductImage(
      id: json['id'].toString(),
      imageUrl: resolvedImageUrl,
      viewAngle: (json['view_angle'] ?? 'View').toString(),
      displayOrder: json['display_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'view_angle': viewAngle,
      'display_order': displayOrder,
    };
  }
}
