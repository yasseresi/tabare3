import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:tabare3/core/utils/string_manager.dart';
import 'donor_card_info_screen.dart';

class DonorCardScreen extends StatelessWidget {
  const DonorCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A), // Dark background from image
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
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
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
                const SizedBox(height: 20),
                // Level Chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLevelChip(AppStrings.dropOfHope.tr(), false),
                    _buildLevelChip(AppStrings.activeDonor.tr(), true),
                    _buildLevelChip(AppStrings.committedDonor.tr(), false),
                    _buildLevelChip(AppStrings.distinguishedDonor.tr(), false),
                    _buildLevelChip(AppStrings.deserveReward.tr(), false),
                  ],
                ),
                const SizedBox(height: 30),
                // Active Level Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.activeDonor.tr(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          _buildPointsBadge('18 نقطة'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        AppStrings.donorCardMotivation.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.6,
                          minHeight: 12,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '10 نقطة',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            '12 نقطة للمستوى التالي',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '30 نقطة',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.earnedBadges.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildBadgeCard(AppStrings.dropOfHope.tr(), '10 نقطة')),
                    const SizedBox(width: 15),
                    Expanded(child: _buildBadgeCard(AppStrings.activeDonor.tr(), '50 نقطة')),
                  ],
                ),
                const SizedBox(height: 30),
                // Info Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonorCardInfoScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppStrings.whatIsDonorCard.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

  Widget _buildLevelChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.deepPurpleAccent.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.deepPurpleAccent : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: isActive ? Colors.deepPurpleAccent : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge(String points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        points,
        style: const TextStyle(
          color: Colors.deepPurpleAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String title, String points) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: _buildPointsBadge(points)),
          Image.asset(
            'assets/images/reward.png',
            height: 60,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.emoji_events_rounded,
              size: 60,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
