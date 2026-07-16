import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @Default('') String email,
    required String username,
    required String fullName,
    @Default(false) bool isDonor,
    @Default(false) bool isRecipient,
    required String bloodType,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
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
