import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String username,
    required String fullName,
    @Default(false) bool isDonor,
    @Default(false) bool isRecipient,
    required String bloodType,
  }) = _UserEntity;
}
