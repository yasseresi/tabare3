import '../models/donor_card_models.dart';

/// Backend-agnostic contract for the donor card (points, level, badges).
///
/// Implementations live under `datasources/<backend>/`.
abstract class DonorCardRemoteDataSource {
  Future<DonorCardModel> getDonorCard();
}
