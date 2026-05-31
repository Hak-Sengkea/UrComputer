class User {
  final int id;
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
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zipCode'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImage': profileImage,
      'address': address,
      'city': city,
      'country': country,
      'zipCode': zipCode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
