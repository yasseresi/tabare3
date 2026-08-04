import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/donor_card_models.dart';
import '../donor_card_remote_data_source.dart';

const donorCardSummarySelectColumns = 'total_points,total_donations_count';
const donorLevelSelectColumns = 'level_number,min_points,name_ar,icon_url';
const donorBadgeSelectColumns =
    'earned_at,badge:badges!user_badges_badge_id_fkey('
    'id,name_ar,description_ar,icon_url,threshold)';

class DonorCardSupabaseDataSource implements DonorCardRemoteDataSource {
  final SupabaseClient client;

  DonorCardSupabaseDataSource({required this.client});

  @override
  Future<DonorCardModel> getDonorCard() async {
    final userId = client.auth.currentUser!.id;
    final summaryRow = await client
        .from('users')
        .select(donorCardSummarySelectColumns)
        .eq('id', userId)
        .single();
    final levelRows = await client
        .from('levels')
        .select(donorLevelSelectColumns)
        .order('min_points');
    final badgeRows = await client
        .from('user_badges')
        .select(donorBadgeSelectColumns)
        .eq('user_id', userId)
        .order('earned_at', ascending: false);

    return DonorCardModel(
      summary: DonorCardSummaryModel.fromJson(summaryRow),
      levels: levelRows.map(DonorLevelModel.fromJson).toList(),
      badges: badgeRows.map(EarnedDonorBadgeModel.fromJson).toList(),
    );
  }
}
