class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double? discount;
  final int categoryId;
  final int brandId;
  final String? image;
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
    this.image,
    this.stock,
    this.rating,
    this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discount: json['discount'] != null ? (json['discount'] as num).toDouble() : null,
      categoryId: json['categoryId'],
      brandId: json['brandId'],
      image: json['image'],
      stock: json['stock'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviews: json['reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'categoryId': categoryId,
      'brandId': brandId,
      'image': image,
      'stock': stock,
      'rating': rating,
      'reviews': reviews,
    };
  }

  double get discountedPrice {
    if (discount == null || discount == 0) return price;
    return price - (price * discount! / 100);
  }
}
