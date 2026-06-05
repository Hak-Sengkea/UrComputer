class Brand {
  final String id;
  final String name;
  final String? logo;
  final String? description;

  Brand({required this.id, required this.name, this.logo, this.description});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'].toString(),
      name: json['name'],
      logo: json['logo'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'logo': logo, 'description': description};
  }
}
