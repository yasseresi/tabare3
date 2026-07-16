import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final bool isDonor;
  final bool isRecipient;
  final String bloodType;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.isDonor = false,
    this.isRecipient = false,
    required this.bloodType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      isDonor: json['is_donor'] as bool? ?? false,
      isRecipient: json['is_recipient'] as bool? ?? false,
      bloodType: json['blood_type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'full_name': fullName,
        'is_donor': isDonor,
        'is_recipient': isRecipient,
        'blood_type': bloodType,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        fullName: fullName,
        isDonor: isDonor,
        isRecipient: isRecipient,
        bloodType: bloodType,
      );
}
