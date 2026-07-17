import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabare3/core/utils/string_manager.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final int _selectedIndex = 3; // Notifications tab index

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Header: Greeting (Right) and Bell (Left)
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
                              AppStrings.getWellSoon.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Search Bar
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: AppStrings.searchNotifications.tr(),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        // In RTL, suffixIcon is on the left
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 28,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B1D1D),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  AppStrings.notificationsHeader.tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildNotificationCard(
                      title: AppStrings.donorsCompleted.tr(),
                      description: AppStrings.donorsCompletedDesc.tr(),
                      time: 'منذ 30 د',
                      isSuccess: true,
                    ),
                    const SizedBox(height: 15),
                    _buildNotificationCard(
                      title: AppStrings.newDonorAccepted.tr(),
                      description: 'تم قبول طلب التبرع من قبل خالد بن عبد الله',
                      time: 'منذ 30 د',
                      isSuccess: false,
                    ),
                    const SizedBox(height: 15),
                    _buildNotificationCard(
                      title: AppStrings.newDonorAccepted.tr(),
                      description: 'تم قبول طلب التبرع من قبل احمد لوصيف',
                      time: 'منذ ساعة',
                      isSuccess: false,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    bool isSuccess = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Icon on the right (first in RTL Row)
          isSuccess
              ? Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 30),
                )
              : SvgPicture.asset(
                  'assets/icons/icon8.svg',
                  width: 40,
                  height: 40,
                ),
          const SizedBox(width: 15),
          // Content in the middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Left in RTL is start? No, right is start.
              // We want text aligned to the right, which is "start" in RTL
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Time on the far left (last in RTL Row)
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF8B1D1D),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          _buildPlusItem('assets/icons/icon3.svg', 2),
          _buildNavItem('assets/icons/icon4.svg', 3),
          _buildNavItem('assets/icons/icon5.svg', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) Navigator.pop(context);
      },
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
          width: 26,
          height: 26,
        ),
      ),
    );
  }

  Widget _buildPlusItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {},
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
          width: 26,
          height: 26,
        ),
      ),
    );
  }
}
