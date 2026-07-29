import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String id,
    required String email,
    required String username,
    required String fullName,
    required String phone,
    required String dateOfBirth,
    required String gender,
    String? nationalId,
    required String bloodType,
    double? weight,
    required String city,
    String? chronicDiseases,
    String? avatarUrl,
    required bool isDonor,
    required bool isRecipient,
    required bool isActive,
  }) = _ProfileEntity;
}
