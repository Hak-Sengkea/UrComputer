class Category {
  final String id;
  final String name;
  final String? banner;
  final String? description;
  final String? icon;

  Category({
    required this.id,
    required this.banner,
    required this.name,
    this.description,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      banner: json['banner'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'banner': banner,
      'description': description,
      'icon': icon,
    };
  }
}