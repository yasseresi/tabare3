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
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'is_donor') @Default(false) bool isDonor,
    @JsonKey(name: 'is_recipient') @Default(false) bool isRecipient,
    @JsonKey(name: 'blood_type') required String bloodType,
    // Backend `wilaya` can be an id or a nested object; resolved to a plain
    // 1-based id in the mapper, so keep it out of JSON codegen.
    @JsonKey(includeFromJson: false, includeToJson: false) int? wilayaId,
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
    wilayaId: wilayaId,
  );
}
