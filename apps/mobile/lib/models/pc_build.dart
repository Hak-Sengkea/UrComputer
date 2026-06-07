import 'product.dart';

class PCBuild {
  final String id;
  final String userId;
  final String buildName;
  final String? description;
  double totalPrice;
  final Map<String, Product?> components;
  final String? imageUrl;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  PCBuild({
    required this.id,
    required this.userId,
    required this.buildName,
    this.description,
    required this.totalPrice,
    required this.components,
    this.imageUrl,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PCBuild.fromJson(Map<String, dynamic> json) {
    return PCBuild(
      id: json['id'],
      userId: json['user_id'],
      buildName: json['build_name'],
      description: json['description'],
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      components: {},
      imageUrl: json['image_url'],
      isPublic: json['is_public'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'build_name': buildName,
      'description': description,
      'total_price': totalPrice,
      'components': components.map((key, value) => MapEntry(key, value?.toJson())),
      'image_url': imageUrl,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get componentCount => components.values.where((c) => c != null).length;
  
  bool get isComplete {
    final requiredTypes = ['CPU', 'GPU', 'RAM', 'Motherboard', 'Storage', 'PSU'];
    return requiredTypes.every((type) => components[type] != null);
  }
}