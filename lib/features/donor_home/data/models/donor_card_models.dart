import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/donor_card_entity.dart';

part 'donor_card_models.freezed.dart';
part 'donor_card_models.g.dart';

@freezed
abstract class DonorCardSummaryModel with _$DonorCardSummaryModel {
  const factory DonorCardSummaryModel({
    @JsonKey(name: 'total_points') required int totalPoints,
    @JsonKey(name: 'total_donations_count') required int totalDonations,
  }) = _DonorCardSummaryModel;

  factory DonorCardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DonorCardSummaryModelFromJson(json);
}

@freezed
abstract class DonorLevelModel with _$DonorLevelModel {
  const DonorLevelModel._();

  const factory DonorLevelModel({
    @JsonKey(name: 'level_number') required int levelNumber,
    @JsonKey(name: 'min_points') required int minPoints,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _DonorLevelModel;

  factory DonorLevelModel.fromJson(Map<String, dynamic> json) =>
      _$DonorLevelModelFromJson(json);

  DonorLevelEntity toEntity() => DonorLevelEntity(
    levelNumber: levelNumber,
    minPoints: minPoints,
    nameAr: nameAr,
    iconUrl: iconUrl,
  );
}

@freezed
abstract class DonorBadgeModel with _$DonorBadgeModel {
  const factory DonorBadgeModel({
    required String id,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'description_ar') String? descriptionAr,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _DonorBadgeModel;

  factory DonorBadgeModel.fromJson(Map<String, dynamic> json) =>
      _$DonorBadgeModelFromJson(json);
}

@freezed
abstract class EarnedDonorBadgeModel with _$EarnedDonorBadgeModel {
  const EarnedDonorBadgeModel._();

  const factory EarnedDonorBadgeModel({
    @JsonKey(name: 'earned_at') required DateTime earnedAt,
    required DonorBadgeModel badge,
  }) = _EarnedDonorBadgeModel;

  factory EarnedDonorBadgeModel.fromJson(Map<String, dynamic> json) =>
      _$EarnedDonorBadgeModelFromJson(json);

  DonorBadgeEntity toEntity() => DonorBadgeEntity(
    id: badge.id,
    nameAr: badge.nameAr,
    descriptionAr: badge.descriptionAr,
    iconUrl: badge.iconUrl,
    earnedAt: earnedAt,
  );
}

@freezed
abstract class DonorCardModel with _$DonorCardModel {
  const DonorCardModel._();

  const factory DonorCardModel({
    required DonorCardSummaryModel summary,
    required List<DonorLevelModel> levels,
    required List<EarnedDonorBadgeModel> badges,
  }) = _DonorCardModel;

  DonorCardEntity toEntity() => DonorCardEntity(
    totalPoints: summary.totalPoints,
    totalDonations: summary.totalDonations,
    levels: levels.map((level) => level.toEntity()).toList(),
    badges: badges.map((badge) => badge.toEntity()).toList(),
  );
}
