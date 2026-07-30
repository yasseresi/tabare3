import 'package:equatable/equatable.dart';

class DonorLevelEntity extends Equatable {
  final int levelNumber;
  final int minPoints;
  final String nameAr;
  final String? iconUrl;

  const DonorLevelEntity({
    required this.levelNumber,
    required this.minPoints,
    required this.nameAr,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [levelNumber, minPoints, nameAr, iconUrl];
}

class DonorBadgeEntity extends Equatable {
  final String id;
  final String nameAr;
  final String? descriptionAr;
  final String? iconUrl;
  final DateTime earnedAt;

  const DonorBadgeEntity({
    required this.id,
    required this.nameAr,
    this.descriptionAr,
    this.iconUrl,
    required this.earnedAt,
  });

  @override
  List<Object?> get props => [id, nameAr, descriptionAr, iconUrl, earnedAt];
}

class DonorCardEntity extends Equatable {
  final int totalPoints;
  final int totalDonations;
  final List<DonorLevelEntity> levels;
  final List<DonorBadgeEntity> badges;

  const DonorCardEntity({
    required this.totalPoints,
    required this.totalDonations,
    required this.levels,
    required this.badges,
  });

  DonorLevelEntity? get currentLevel {
    DonorLevelEntity? current;
    for (final level in levels) {
      if (level.minPoints <= totalPoints &&
          (current == null || level.minPoints > current.minPoints)) {
        current = level;
      }
    }
    return current;
  }

  DonorLevelEntity? get nextLevel {
    DonorLevelEntity? next;
    for (final level in levels) {
      if (level.minPoints > totalPoints &&
          (next == null || level.minPoints < next.minPoints)) {
        next = level;
      }
    }
    return next;
  }

  double get levelProgress {
    final current = currentLevel;
    final next = nextLevel;
    if (current == null || next == null) return next == null ? 1 : 0;
    final range = next.minPoints - current.minPoints;
    if (range <= 0) return 1;
    return ((totalPoints - current.minPoints) / range).clamp(0, 1);
  }

  @override
  List<Object?> get props => [totalPoints, totalDonations, levels, badges];
}
