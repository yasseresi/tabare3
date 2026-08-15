import 'package:dio/dio.dart';

import '../../../features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import '../../../features/donor_home/data/models/donor_card_models.dart';
import '../constants/rest_paths.dart';

/// REST implementation of [DonorCardRemoteDataSource] against the Django backend.
///
/// `/donor-card/` returns the summary (points/donations), the current/next level
/// and earned badges — but not the full level ladder the card renders. So the
/// ladder is fetched separately from `/levels/` and merged in.
class DonorCardRestDataSource implements DonorCardRemoteDataSource {
  DonorCardRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<DonorCardModel> getDonorCard() async {
    final card = await dio.get<Map<String, dynamic>>(RestPaths.donorCard);
    final levels = await dio.get<List<dynamic>>(RestPaths.levels);
    final json = card.data ?? const {};

    return DonorCardModel(
      summary: DonorCardSummaryModel(
        totalPoints: _asInt(json['points_balance']) ?? 0,
        totalDonations: _asInt(json['donations_count']) ?? 0,
      ),
      levels: (levels.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(_mapLevel)
          .toList(growable: false),
      badges: (json['badges'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(_mapEarnedBadge)
          .toList(growable: false),
    );
  }

  DonorLevelModel _mapLevel(Map<String, dynamic> json) => DonorLevelModel(
    levelNumber: _asInt(json['level_number']) ?? 0,
    minPoints: _asInt(json['min_points']) ?? 0,
    nameAr: json['title_ar']?.toString() ?? '',
    iconUrl: _nullIfEmpty(json['icon_url']),
  );

  EarnedDonorBadgeModel _mapEarnedBadge(Map<String, dynamic> json) {
    final badge = json['badge'] as Map<String, dynamic>? ?? const {};
    return EarnedDonorBadgeModel(
      earnedAt: DateTime.tryParse(json['awarded_at']?.toString() ?? '') ??
          DateTime.now(),
      badge: DonorBadgeModel(
        id: badge['id']?.toString() ?? '',
        nameAr: badge['name_ar']?.toString() ?? '',
        descriptionAr: _nullIfEmpty(badge['description']),
        iconUrl: _nullIfEmpty(badge['icon_url']),
        threshold: _asInt(badge['level']),
      ),
    );
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  String? _nullIfEmpty(dynamic v) {
    final s = v?.toString();
    return (s == null || s.isEmpty) ? null : s;
  }
}
