// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String? ?? '',
  username: json['username'] as String,
  fullName: json['fullName'] as String,
  isDonor: json['isDonor'] as bool? ?? false,
  isRecipient: json['isRecipient'] as bool? ?? false,
  bloodType: json['bloodType'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'fullName': instance.fullName,
      'isDonor': instance.isDonor,
      'isRecipient': instance.isRecipient,
      'bloodType': instance.bloodType,
    };
