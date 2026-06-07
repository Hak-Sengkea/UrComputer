class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImage;
  final String? address;
  final String? city;
  final String? country;
  final String? zipCode;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.profileImage,
    this.address,
    this.city,
    this.country,
    this.zipCode,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      firstName: json['first_name'] ?? json['firstName'] ?? '',
      lastName: json['last_name'] ?? json['lastName'] ?? '',
      phone: json['phone'],
      profileImage: json['profile_image'] ?? json['profileImage'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zip_code'] ?? json['zipCode'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'profile_image': profileImage,
      'address': address,
      'city': city,
      'country': country,
      'zip_code': zipCode,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}