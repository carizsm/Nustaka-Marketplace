import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // File ini akan digenerate

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String role;

  // Tambahkan field lain dari API Anda jika perlu
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  final String? status;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.address,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}