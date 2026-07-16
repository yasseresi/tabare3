// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String? ?? '',
  username: json['username'] as String,
  fullName: json['full_name'] as String,
  isDonor: json['is_donor'] as bool? ?? false,
  isRecipient: json['is_recipient'] as bool? ?? false,
  bloodType: json['blood_type'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'full_name': instance.fullName,
      'is_donor': instance.isDonor,
      'is_recipient': instance.isRecipient,
      'blood_type': instance.bloodType,
    };
