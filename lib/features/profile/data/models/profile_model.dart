import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @Default('') String email,
    required String username,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
    required String gender,
    @JsonKey(name: 'national_id') String? nationalId,
    @JsonKey(name: 'blood_type') required String bloodType,
    double? weight,
    required String city,
    @JsonKey(name: 'chronic_diseases') String? chronicDiseases,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_donor') @Default(false) bool isDonor,
    @JsonKey(name: 'is_recipient') @Default(false) bool isRecipient,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

extension ProfileModelX on ProfileModel {
  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    email: email,
    username: username,
    fullName: fullName,
    phone: phone,
    dateOfBirth: dateOfBirth,
    gender: gender,
    nationalId: nationalId,
    bloodType: bloodType,
    weight: weight,
    city: city,
    chronicDiseases: chronicDiseases,
    avatarUrl: avatarUrl,
    isDonor: isDonor,
    isRecipient: isRecipient,
    isActive: isActive,
  );
}
