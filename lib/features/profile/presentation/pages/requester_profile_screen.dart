import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:tabare3/core/utils/string_manager.dart';

class RequesterProfileScreen extends StatefulWidget {
  const RequesterProfileScreen({super.key});

  @override
  State<RequesterProfileScreen> createState() => _RequesterProfileScreenState();
}

class _RequesterProfileScreenState extends State<RequesterProfileScreen> {
  bool _isEditing = false;
  bool _accountStatus = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildProfileInfo(),
                const SizedBox(height: 20),
                _buildSectionHeader(AppStrings.accountInfo.tr()),
                _buildAccountInfo(),
                const SizedBox(height: 20),
                _buildSectionHeader(AppStrings.personalInfo.tr()),
                _buildPersonalInfo(),
                const SizedBox(height: 20),
                _buildAppInfo(),
                const SizedBox(height: 100), // Padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Row(
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
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            image: const DecorationImage(
              image: AssetImage('assets/images/demo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'احمد لوصيف',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Text(
          'louciftamer3@gmail.com',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isEditing ? AppStrings.saveChanges.tr() : AppStrings.edit.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(_isEditing ? Icons.check : Icons.edit_outlined, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            _buildListItem(
              icon: Icons.phone_outlined,
              label: AppStrings.phoneNumberLabel.tr(),
              value: '0676 24 41 89',
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.person_pin_outlined,
              label: AppStrings.accountType.tr(),
              value: '${AppStrings.iNeedBlood.tr()} / ${AppStrings.iAmDonor.tr()}',
              isDropdown: _isEditing,
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildSwitchItem(
              icon: Icons.notifications_none_outlined,
              label: AppStrings.accountStatus.tr(),
              subtitle: AppStrings.accountStatusSubtitle.tr(),
              value: _accountStatus,
              onChanged: (val) => setState(() => _accountStatus = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            _buildListItem(
              icon: Icons.calendar_today_outlined,
              label: AppStrings.dateOfBirth.tr(),
              value: '27 نوفمبر 2005',
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.person_outline,
              label: AppStrings.gender.tr(),
              value: AppStrings.male.tr(),
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.badge_outlined,
              label: AppStrings.nationalId.tr(),
              value: '10101010101010101010',
              isLongValue: true,
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.opacity,
              label: AppStrings.bloodType.tr(),
              value: 'O+',
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.monitor_weight_outlined,
              label: AppStrings.weight.tr(),
              value: '80 kg',
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.location_city_outlined,
              label: AppStrings.governorate.tr(),
              value: 'الجزائر العاصمة',
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            _buildListItem(
              icon: Icons.coronavirus_outlined,
              label: AppStrings.chronicDiseasesLabel.tr(),
              value: '/',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
              size: 16,
            ),
            const Spacer(),
            Text(
              AppStrings.appInformation.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 15),
            Icon(Icons.info_outline, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String label,
    required String value,
    bool isDropdown = false,
    bool isLongValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          if (isLongValue)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            )
          else ...[
            if (isDropdown)
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 20,
              ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 15),
          Icon(icon, color: Colors.grey, size: 24),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Icon(icon, color: Colors.grey, size: 24),
        ],
      ),
    );
  }
}
