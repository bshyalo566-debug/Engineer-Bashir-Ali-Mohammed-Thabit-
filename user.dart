import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? fullName;
  final String? email;
  final String? phone;
  final DateTime? createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.username,
    this.fullName,
    this.email,
    this.phone,
    this.createdAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, username, fullName, email, phone, isActive];
}
