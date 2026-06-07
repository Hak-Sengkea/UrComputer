import 'package:mobile/models/product_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? discount;
  final String categoryId;
  final String brandId;
  final String? image;
  final List<ProductImage>? viewAngle;
  final int? stock;
  final double? rating;
  final int? reviews;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discount,
    required this.categoryId,
    required this.brandId,
    required this.viewAngle,
    this.image,
    this.stock,
    this.rating,
    this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String? rawImage = json['image'];
    String? resolvedImage = rawImage;

    if (rawImage != null && rawImage.isNotEmpty) {
      if (rawImage.startsWith('http')) {
        // Keep the absolute URL as-is (e.g. loading from the old bucket where files are already hosted)
        resolvedImage = rawImage;
      } else {
        // Resolve relative paths (e.g. 'acer_headphones.jpg') dynamically using the active Supabase bucket
        resolvedImage = Supabase.instance.client.storage
            .from('products')
            .getPublicUrl(rawImage);
      }
    }

    final productImagesJson = json['product_images'] ?? json['view_angle'];
    final productImages = productImagesJson != null
        ? (productImagesJson as List)
              .map((img) => ProductImage.fromJson(img))
              .toList()
        : null;

    productImages?.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Product(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      categoryId: (json['category_id'] ?? json['categoryId']).toString(),
      brandId: (json['brand_id'] ?? json['brandId']).toString(),
      image: resolvedImage,
      viewAngle: productImages,
      stock: json['stock'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviews: json['reviews'] ?? json['reviews_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'category_id': categoryId,
      'brand_id': brandId,
      'image': image,
      'stock': stock,
      'rating': rating,
      'reviews_count': reviews,
    };
  }

  double get discountedPrice {
    if (discount == null || discount == 0) return price;
    return price - (price * discount! / 100);
  }
}
