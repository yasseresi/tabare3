import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/logout_dialog.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/role_selection_screen.dart';
import '../../../donor_home/presentation/pages/donor_card_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _accountStatus = true;

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => LogoutDialog(
        title: AppStrings.confirmLogout.tr(),
        message: AppStrings.confirmLogoutMessage.tr(),
        confirmLabel: AppStrings.logout.tr(),
        cancelLabel: AppStrings.cancel.tr(),
        onConfirm: () {
          context.read<AuthBloc>().add(SignOutRequested());
        },
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.chooseLanguage.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(AppStrings.arabic.tr(), true),
                _buildLanguageOption('English', false),
                _buildLanguageOption('Français', false),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.profile.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        icon: Icon(
                          _isEditing ? Icons.check : Icons.edit_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Profile Image and Info
                _buildProfileHeader(),
                const SizedBox(height: 30),
                // Quick Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAction(
                        icon: Icons.credit_card,
                        label: AppStrings.donorCard.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonorCardScreen(),
                            ),
                          );
                        },
                      ),
                      _buildQuickAction(
                        icon: Icons.history,
                        label: AppStrings.record.tr(),
                        onTap: () {},
                      ),
                      _buildQuickAction(
                        icon: Icons.notifications_none,
                        label: AppStrings.notifications.tr(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Main Info Sections
                _buildSection(
                  title: AppStrings.personalInfo.tr(),
                  child: _buildPersonalInfo(),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: AppStrings.accountSettings.tr(),
                  child: _buildAccountSettings(),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: AppStrings.aboutApp.tr(),
                  child: _buildAboutSection(),
                ),
                const SizedBox(height: 40),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        foregroundColor: const Color(0xFF8B1D1D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded),
                          const SizedBox(width: 10),
                          Text(
                            AppStrings.logout.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8B1D1D), width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/images/demo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B1D1D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'أحمد لوصيف',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          AppStrings.donationLifeChance.tr(),
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFF8B1D1D)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        _buildInfoRow(
          AppStrings.fullName.tr(),
          'أحمد لوصيف',
          Icons.person_outline,
        ),
        const Divider(height: 30),
        _buildInfoRow(
          AppStrings.dateOfBirth.tr(),
          '12 ماي 1995',
          Icons.calendar_today_outlined,
        ),
        const Divider(height: 30),
        _buildInfoRow(AppStrings.bloodType.tr(), 'O+', Icons.opacity),
        const Divider(height: 30),
        _buildInfoRow(
          AppStrings.governorate.tr(),
          'قسنطينة',
          Icons.location_on_outlined,
          isDropdown: _isEditing,
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildInfoRow(
          AppStrings.phoneNumberLabel.tr(),
          '0676 24 41 89',
          Icons.phone_outlined,
        ),
        const Divider(height: 30),
        _buildInfoRow(
          AppStrings.accountType.tr(),
          '${AppStrings.iNeedBlood.tr()} / ${AppStrings.iAmDonor.tr()}',
          Icons.person_pin_outlined,
          isDropdown: _isEditing,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RoleSelectionScreen(),
              ),
            );
          },
        ),
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Switch(
              value: _accountStatus,
              onChanged: (value) {
                setState(() {
                  _accountStatus = value;
                });
              },
              activeColor: Colors.green,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.accountStatus.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _accountStatus
                          ? AppStrings.accountStatusSubtitle.tr()
                          : AppStrings.notActive.tr(),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 30),
        _buildInfoRow(
          AppStrings.changeLanguage.tr(),
          AppStrings.arabic.tr(),
          Icons.language_outlined,
          isDropdown: true,
          onTap: _showLanguageDialog,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _buildInfoRow(AppStrings.aboutUs.tr(), '', Icons.info_outline),
        const Divider(height: 30),
        _buildInfoRow(
          AppStrings.privacyPolicyLabel.tr(),
          '',
          Icons.privacy_tip_outlined,
        ),
        const Divider(height: 30),
        _buildInfoRow(AppStrings.appValues.tr(), '', Icons.star_outline),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    bool isDropdown = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isDropdown && _isEditing)
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20)
          else if (onTap != null)
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
              size: 16,
            )
          else
            const SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (value.isNotEmpty)
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 15),
                Icon(icon, color: Colors.grey, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String title, bool isSelected) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.right),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF8B1D1D))
          : null,
      onTap: () => Navigator.pop(context),
    );
  }
}
