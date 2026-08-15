// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      nationalId: json['national_id'] as String?,
      bloodType: json['blood_type'] as String,
      weight: (json['weight'] as num?)?.toDouble(),
      city: json['city'] as String,
      chronicDiseases: json['chronic_diseases'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isDonor: json['is_donor'] as bool? ?? false,
      isRecipient: json['is_recipient'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'date_of_birth': instance.dateOfBirth,
      'gender': instance.gender,
      'national_id': instance.nationalId,
      'blood_type': instance.bloodType,
      'weight': instance.weight,
      'city': instance.city,
      'chronic_diseases': instance.chronicDiseases,
      'avatar_url': instance.avatarUrl,
      'is_donor': instance.isDonor,
      'is_recipient': instance.isRecipient,
      'is_active': instance.isActive,
    };
