import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:tabare3/core/utils/string_manager.dart';

class DonorCardInfoScreen extends StatelessWidget {
  const DonorCardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.welcomeUser.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppStrings.donationLifeChance.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Title Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.deepPurple,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        AppStrings.donorCard.tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Purple Drop Character
                Image.asset(
                  'assets/images/avatar.png',
                  height: 164,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.water_drop,
                    size: 150,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 30),
                // Info Section
                _buildSection(
                  title: AppStrings.whatIsDonorCard.tr(),
                  content: AppStrings.donorCardExplanation.tr(),
                ),
                const SizedBox(height: 30),
                // How to earn points
                _buildSectionTitle(AppStrings.howToEarnPoints.tr()),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildPointChip(
                      AppStrings.bloodDonation.tr(),
                      '+8',
                      Colors.green,
                    ),
                    _buildPointChip(
                      AppStrings.appointmentCommitment.tr(),
                      '+2',
                      Colors.green,
                    ),
                    _buildPointChip(
                      AppStrings.cancellationLabel.tr(),
                      '-5',
                      Colors.red,
                    ),
                    _buildPointChip(
                      AppStrings.urgentDonation.tr(),
                      '+10',
                      Colors.green,
                    ),
                    _buildPointChip(
                      AppStrings.threeMonthsInactive.tr(),
                      '-3',
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Levels
                _buildSectionTitle(AppStrings.levels.tr()),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _buildLevelRow(AppStrings.dropOfHope.tr(), '0-10'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow(AppStrings.activeDonor.tr(), '10-50'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow(AppStrings.committedDonor.tr(), '50-90'),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow(
                        AppStrings.distinguishedDonor.tr(),
                        '90-120',
                      ),
                      const Divider(color: Colors.white10, height: 20),
                      _buildLevelRow(AppStrings.deserveReward.tr(), '+120'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  Widget _buildPointChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRow(String label, String range) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.deepPurpleAccent),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          range,
          style: const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
