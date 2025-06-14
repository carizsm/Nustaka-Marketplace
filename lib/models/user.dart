class User {
  final String id;
  final String email;
  final String role;
  final String status;
  final String address;
  final String gender;
  final DateTime? birthDate;
  final String name;
  final String bio;
  final String phoneNumber;
  final String username;
  final String? profilePictureUrl;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.address,
    required this.gender,
    required this.birthDate,
    required this.name,
    required this.bio,
    required this.phoneNumber,
    required this.username,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime? birthDate;
    if (json['birth_date'] is Map<String, dynamic> &&
        json['birth_date']?['_seconds'] != null) {
      birthDate = DateTime.fromMillisecondsSinceEpoch(
          (json['birth_date']['_seconds'] as int) * 1000);
    } else if (json['birth_date'] is String) {
      birthDate = DateTime.tryParse(json['birth_date']);
    }

    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: birthDate,
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      username: json['username'] ?? '',
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}
