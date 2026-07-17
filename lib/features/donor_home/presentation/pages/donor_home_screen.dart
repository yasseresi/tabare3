import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabare3/core/utils/string_manager.dart';
import 'package:tabare3/features/profile/presentation/pages/profile_screen.dart';
import 'package:tabare3/features/requester_home/presentation/pages/notifications_screen.dart';
import 'donor_requests_screen.dart';
import 'donor_appointments_screen.dart';
import 'donor_record_screen.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  int _selectedIndex = 0;
  bool _isEligible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return const DonorRequestsScreen();
      case 2:
        return const DonorAppointmentsScreen();
      case 3:
        return const DonorRecordScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          AppStrings.donationLifeChance.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Donor Stats Card
                _buildDonorStatsCard(),
                const SizedBox(height: 30),
                // Nearby Requests Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.latestNearbyRequests.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Text(
                        AppStrings.seeAll.tr(),
                        style: TextStyle(color: Color(0xFF8B1D1D)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Request Cards
                _buildRequestCard(
                  name: 'علي بن محمد',
                  urgency: AppStrings.veryUrgent.tr(),
                  urgencyColor: Colors.red,
                  bloodType: 'O+',
                  requestDate: '01 جانفي 2026',
                  deadline: '15 جانفي 2026',
                  hospital: 'مستشفى مصطفى باشا',
                  location: 'الجزائر',
                  bagsInfo: AppStrings.bagsProvided.tr(namedArgs: {'count': '1', 'total': '3'}),
                  progress: 0.33,
                ),
                const SizedBox(height: 20),
                _buildRequestCard(
                  name: 'علي بن محمد',
                  urgency: AppStrings.urgent.tr(),
                  urgencyColor: Colors.orange,
                  bloodType: 'O+',
                  requestDate: '01 جانفي 2026',
                  deadline: '15 جانفي 2026',
                  hospital: 'مستشفى مصطفى باشا',
                  location: 'الجزائر',
                  bagsInfo: AppStrings.bagsProvided.tr(namedArgs: {'count': '1', 'total': '3'}),
                  progress: 0.33,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonorStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isEligible = !_isEligible),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isEligible
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isEligible ? AppStrings.eligibleNow.tr() : AppStrings.notEligibleNow.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _isEligible ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: _isEligible ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.hadithIntro.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B1D1D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.hadithRelief.tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/demo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.bloodtype,
                    color: Color(0xFF8B1D1D),
                    size: 80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDonorInfoRow(AppStrings.totalDonations.tr(), '12'),
          _buildDonorInfoRow(AppStrings.requestsNearYou.tr(), '14'),
          _buildDonorInfoRow(
            AppStrings.lastDonation.tr(),
            _isEligible ? '15 جانفي 2025' : '15 جانفي 2026',
          ),
          _buildDonorInfoRow(
            AppStrings.nextDonationAppointment.tr(), '15 جانفي 2026'),
        ],
      ),
    );
  }

  Widget _buildDonorInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String name,
    required String urgency,
    required Color urgencyColor,
    required String bloodType,
    required String requestDate,
    required String deadline,
    required String hospital,
    required String location,
    required String bagsInfo,
    required double progress,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/icon8.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildBadge(urgency, urgencyColor),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(AppStrings.bloodType.tr(), bloodType),
          _buildInfoRow(AppStrings.requestDate.tr(), requestDate),
          _buildInfoRow(AppStrings.deadline.tr(), deadline),
          _buildInfoRow(hospital, location),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bagsInfo,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const Text(
                '1/3',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1D1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8B1D1D),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // For demo, just navigate to requests tab
                setState(() {
                  _selectedIndex = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppStrings.acceptRequest.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/icons/icon1.svg', 0),
          _buildNavItem('assets/icons/icon2.svg', 1),
          _buildPlusItem('assets/icons/icon9.svg', 2),
          _buildNavItem('assets/icons/icon4.svg', 3),
          _buildNavItem('assets/icons/icon5.svg', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B1D1D) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.grey,
            BlendMode.srcIn,
          ),
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildPlusItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B1D1D) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF8B1D1D) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.grey,
            BlendMode.srcIn,
          ),
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
