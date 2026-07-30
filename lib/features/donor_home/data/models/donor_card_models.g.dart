// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_card_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DonorCardSummaryModel _$DonorCardSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DonorCardSummaryModel(
  totalPoints: (json['total_points'] as num).toInt(),
  totalDonations: (json['total_donations_count'] as num).toInt(),
);

Map<String, dynamic> _$DonorCardSummaryModelToJson(
  _DonorCardSummaryModel instance,
) => <String, dynamic>{
  'total_points': instance.totalPoints,
  'total_donations_count': instance.totalDonations,
};

_DonorLevelModel _$DonorLevelModelFromJson(Map<String, dynamic> json) =>
    _DonorLevelModel(
      levelNumber: (json['level_number'] as num).toInt(),
      minPoints: (json['min_points'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$DonorLevelModelToJson(_DonorLevelModel instance) =>
    <String, dynamic>{
      'level_number': instance.levelNumber,
      'min_points': instance.minPoints,
      'name_ar': instance.nameAr,
      'icon_url': instance.iconUrl,
    };

_DonorBadgeModel _$DonorBadgeModelFromJson(Map<String, dynamic> json) =>
    _DonorBadgeModel(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      descriptionAr: json['description_ar'] as String?,
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$DonorBadgeModelToJson(_DonorBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'description_ar': instance.descriptionAr,
      'icon_url': instance.iconUrl,
    };

_EarnedDonorBadgeModel _$EarnedDonorBadgeModelFromJson(
  Map<String, dynamic> json,
) => _EarnedDonorBadgeModel(
  earnedAt: DateTime.parse(json['earned_at'] as String),
  badge: DonorBadgeModel.fromJson(json['badge'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EarnedDonorBadgeModelToJson(
  _EarnedDonorBadgeModel instance,
) => <String, dynamic>{
  'earned_at': instance.earnedAt.toIso8601String(),
  'badge': instance.badge,
};
