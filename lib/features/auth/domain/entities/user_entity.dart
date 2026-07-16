import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final bool isDonor;
  final bool isRecipient;
  final String bloodType;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.isDonor = false,
    this.isRecipient = false,
    required this.bloodType,
  });

  @override
  List<Object?> get props => [id, email, username, fullName, isDonor, isRecipient, bloodType];
}
