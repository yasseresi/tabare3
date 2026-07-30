import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/presentation/widgets/logout_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_field_editors.dart';
import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appTextDirection(context),
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBg,
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: _profileListener,
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileLoaded) {
                return _ProfileContent(
                  profile: state.profile,
                  isEditing: state.isEditing,
                );
              }
              if (state is ProfileError) {
                return Center(child: Text(state.failure.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _profileListener(BuildContext context, ProfileState state) {
    if (state is ProfileRoleChanged) {
      final route = state.profile.isDonor
          ? Routes.donorHomeRoute
          : Routes.requesterHomeRoute;
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileEntity profile;
  final bool isEditing;

  const _ProfileContent({required this.profile, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppPadding.p32),
      child: Column(
        children: [
          const SizedBox(height: AppSize.s60),
          _buildHeader(context),
          const SizedBox(height: AppSize.s24),
          _buildAvatarSection(context),
          const SizedBox(height: AppSize.s24),
          _buildAccountSection(context),
          const SizedBox(height: AppSize.s20),
          _buildPersonalSection(context),
          const SizedBox(height: AppSize.s20),
          _buildAppSection(context),
          const SizedBox(height: AppSize.s40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final subtitle = profile.isDonor
        ? AppStrings.donationLifeChance.tr()
        : AppStrings.getWellSoon.tr();
    final firstName = profile.fullName.split(' ').first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p8),
            decoration: BoxDecoration(
              color: ColorManager.surfaceAlt,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: AppSize.s2,
                  offset: const Offset(0, AppSize.s1),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: AppSize.s24,
              color: ColorManager.textPrimary,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppStrings.welcome.tr()}، $firstName',
                style: getBoldStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.textPrimary,
                ),
              ),
              const SizedBox(height: AppSize.s4),
              Text(
                subtitle,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Column(
      children: [
        _AvatarPicker(profile: profile),
        const SizedBox(height: AppSize.s16),
        Text(
          profile.fullName,
          style: getSemiBoldStyle(
            fontSize: FontSize.s20,
            color: ColorManager.textPrimary,
          ),
        ),
        const SizedBox(height: AppSize.s4),
        Text(
          profile.email,
          style: getRegularStyle(
            fontSize: FontSize.s14,
            color: ColorManager.lightGrey,
          ),
        ),
        const SizedBox(height: AppSize.s16),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isEditing) {
      return _PillButton(
        label: AppStrings.saveChanges.tr(),
        icon: Icons.check,
        onTap: () => context.read<ProfileBloc>().add(SaveProfile(profile)),
      );
    }

    if (profile.isDonor) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PillButton(
            label: AppStrings.donorCard.tr(),
            icon: Icons.card_giftcard,
            onTap: () => Navigator.pushNamed(context, Routes.donorCardRoute),
          ),
          const SizedBox(width: AppSize.s12),
          _PillButton(
            label: AppStrings.edit.tr(),
            icon: Icons.edit_outlined,
            onTap: () =>
                context.read<ProfileBloc>().add(const ToggleEditMode()),
          ),
        ],
      );
    }

    return _PillButton(
      label: AppStrings.edit.tr(),
      icon: Icons.edit_outlined,
      onTap: () => context.read<ProfileBloc>().add(const ToggleEditMode()),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return ProfileSection(
      title: AppStrings.accountInfo.tr(),
      children: [
        ProfileRow(
          label: AppStrings.phoneNumberLabel.tr(),
          value: profile.phone,
          iconData: Icons.phone_outlined,
          onTap: _editTap(
            context,
            AppStrings.phoneNumberLabel.tr(),
            profile.phone,
            (v) => _updateProfile(context, phone: v),
          ),
        ),
        _Divider(),
        ProfileRow(
          label: AppStrings.accountType.tr(),
          value: _roleLabel(profile),
          iconData: Icons.bloodtype_outlined,
          trailing: isEditing
              ? Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorManager.textSecondary,
                )
              : null,
          onTap: isEditing ? () => _showRoleBottomSheet(context) : null,
        ),
        _Divider(),
        AccountStatusToggle(
          value: profile.isActive,
          onChanged: (v) =>
              context.read<ProfileBloc>().add(AccountStatusToggled(v)),
        ),
      ],
    );
  }

  Widget _buildPersonalSection(BuildContext context) {
    return ProfileSection(
      title: AppStrings.personalInfo.tr(),
      children: [
        if (isEditing) ...[
          ProfileRow(
            label: AppStrings.dateOfBirth.tr(),
            value: _formatDate(context, profile.dateOfBirth),
            iconData: Icons.calendar_today_outlined,
            onTap: () => ProfileFieldEditors.pickDateOfBirth(
              context,
              profile.dateOfBirth,
              (v) => _updateProfile(context, dateOfBirth: v),
            ),
          ),
          _Divider(),
          ProfileRow(
            label: AppStrings.gender.tr(),
            value: _genderLabel(profile.gender),
            iconData: Icons.person_outline,
            onTap: () => ProfileFieldEditors.pickGender(
              context,
              profile.gender,
              (v) => _updateProfile(context, gender: v),
            ),
          ),
          _Divider(),
          ProfileRow(
            label: AppStrings.nationalId.tr(),
            value: profile.nationalId ?? '',
            iconData: Icons.badge_outlined,
            stackValue: true,
            onTap: _editTap(
              context,
              AppStrings.nationalId.tr(),
              profile.nationalId ?? '',
              (v) => _updateProfile(context, nationalId: v),
            ),
          ),
          _Divider(),
          ProfileRow(
            label: AppStrings.bloodType.tr(),
            value: profile.bloodType,
            iconData: Icons.opacity,
            onTap: () => ProfileFieldEditors.pickBloodType(
              context,
              profile.bloodType,
              (v) => _updateProfile(context, bloodType: v),
            ),
          ),
          _Divider(),
        ],
        ProfileRow(
          label: AppStrings.weight.tr(),
          value: profile.weight != null
              ? '${profile.weight} ${AppStrings.kg.tr()}'
              : '',
          iconData: Icons.monitor_weight_outlined,
          onTap: isEditing
              ? () => ProfileFieldEditors.pickWeight(
                  context,
                  profile.weight,
                  (v) => _updateProfile(context, weight: v),
                )
              : null,
        ),
        _Divider(),
        ProfileRow(
          label: AppStrings.governorate.tr(),
          value: profile.city,
          iconData: Icons.location_on_outlined,
          onTap: isEditing
              ? () => ProfileFieldEditors.pickWilaya(
                  context,
                  profile.city,
                  (v) => _updateProfile(context, city: v),
                )
              : null,
        ),
        _Divider(),
        ProfileRow(
          label: AppStrings.chronicDiseases.tr(),
          value: profile.chronicDiseases ?? '/',
          iconData: Icons.healing_outlined,
          onTap: _editTap(
            context,
            AppStrings.chronicDiseases.tr(),
            profile.chronicDiseases ?? '',
            (v) => _updateProfile(context, chronicDiseases: v),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return ProfileSection(
      title: AppStrings.appInfo.tr(),
      children: [
        ProfileRow(
          label: AppStrings.aboutApp.tr(),
          value: '',
          iconData: Icons.info_outline,
          trailing: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: AppSize.s16,
            color: ColorManager.textSecondary,
          ),
          onTap: () => Navigator.pushNamed(context, Routes.aboutAppRoute),
        ),
        _Divider(),
        ProfileRow(
          label: AppStrings.logout.tr(),
          value: '',
          iconData: Icons.logout,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  VoidCallback? _editTap(
    BuildContext context,
    String label,
    String initialValue,
    void Function(String) onSaved,
  ) => isEditing
      ? () => _editField(context, label, initialValue, onSaved)
      : null;

  String _roleLabel(ProfileEntity profile) {
    if (profile.isDonor) return AppStrings.iAmDonor.tr();
    if (profile.isRecipient) return AppStrings.iNeedBlood.tr();
    return '';
  }

  String _genderLabel(String gender) {
    return gender == 'female' ? AppStrings.female.tr() : AppStrings.male.tr();
  }

  String _formatDate(BuildContext context, String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat.yMMMMd(context.locale.toString()).format(parsed);
  }

  void _updateProfile(
    BuildContext context, {
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? nationalId,
    String? bloodType,
    double? weight,
    String? city,
    String? chronicDiseases,
  }) {
    final updated = profile.copyWith(
      fullName: fullName ?? profile.fullName,
      phone: phone ?? profile.phone,
      dateOfBirth: dateOfBirth ?? profile.dateOfBirth,
      gender: gender ?? profile.gender,
      nationalId: nationalId == null
          ? profile.nationalId
          : (nationalId.isEmpty ? null : nationalId),
      bloodType: bloodType ?? profile.bloodType,
      weight: weight ?? profile.weight,
      city: city ?? profile.city,
      chronicDiseases: chronicDiseases == null
          ? profile.chronicDiseases
          : (chronicDiseases.isEmpty ? null : chronicDiseases),
    );
    context.read<ProfileBloc>().add(ProfileFieldChanged(updated));
  }

  void _editField(
    BuildContext context,
    String label,
    String initialValue,
    ValueChanged<String> onChanged,
  ) {
    final controller = TextEditingController(text: initialValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppPadding.p20,
          right: AppPadding.p20,
          top: AppPadding.p20,
        ),
        child: Directionality(
          textDirection: appTextDirection(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: getBoldStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.textPrimary,
                ),
              ),
              const SizedBox(height: AppSize.s16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.s16),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onChanged(controller.text);
                    Navigator.pop(context);
                  },
                  child: Text(AppStrings.save.tr()),
                ),
              ),
              const SizedBox(height: AppSize.s20),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Directionality(
        textDirection: appTextDirection(context),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: AppSize.s80,
              ),
              const SizedBox(height: AppSize.s20),
              Text(
                AppStrings.confirmRoleUpdate.tr(),
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: FontSize.s20,
                  color: ColorManager.textSecondary,
                ),
              ),
              const SizedBox(height: AppSize.s15),
              Text(
                AppStrings.roleSwitchWarning.tr(),
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.textSecondary,
                ),
              ),
              const SizedBox(height: AppSize.s30),
              SizedBox(
                width: AppSize.s220,
                height: AppSize.s50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.read<ProfileBloc>().add(
                      const ChangeRoleRequested(
                        isDonor: false,
                        isRecipient: true,
                      ),
                    );
                  },
                  child: Text(AppStrings.iNeedBlood.tr()),
                ),
              ),
              const SizedBox(height: AppSize.s10),
              SizedBox(
                width: AppSize.s220,
                height: AppSize.s50,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.read<ProfileBloc>().add(
                      const ChangeRoleRequested(
                        isDonor: true,
                        isRecipient: false,
                      ),
                    );
                  },
                  child: Text(AppStrings.iAmDonor.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => LogoutDialog(
        title: AppStrings.confirmLogout.tr(),
        message: AppStrings.confirmLogoutMessage.tr(),
        confirmLabel: AppStrings.logout.tr(),
        cancelLabel: AppStrings.cancel.tr(),
        onConfirm: () => context.read<AuthBloc>().add(SignOutRequested()),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final ProfileEntity profile;

  const _AvatarPicker({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: AppSize.s96,
            height: AppSize.s96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.surface,
              border: Border.all(color: ColorManager.white, width: AppSize.s4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: AppSize.s2,
                  offset: const Offset(0, AppSize.s1),
                ),
              ],
            ),
            child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      profile.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _FallbackAvatar(profile.fullName),
                    ),
                  )
                : _FallbackAvatar(profile.fullName),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.p6),
              decoration: BoxDecoration(
                color: ColorManager.primaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: AppSize.s18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !context.mounted) return;

    final file = File(picked.path);
    final length = await file.length();
    if (length > 10 * 1024 * 1024) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.imageTooLarge.tr())));
      return;
    }
    if (!context.mounted) return;
    context.read<ProfileBloc>().add(AvatarSelected(picked.path));
  }
}

class _FallbackAvatar extends StatelessWidget {
  final String fullName;

  const _FallbackAvatar(this.fullName);

  @override
  Widget build(BuildContext context) {
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: getSemiBoldStyle(
          fontSize: FontSize.s40,
          color: ColorManager.primaryDark,
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p17,
          vertical: AppPadding.p7,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppSize.radiusCircle),
          border: Border.all(color: ColorManager.borderGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textPrimary,
              ),
            ),
            const SizedBox(width: AppSize.s8),
            Icon(icon, size: AppSize.s15, color: ColorManager.textPrimary),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: AppSize.s1,
      color: ColorManager.dividerGrey,
      indent: AppPadding.p20,
      endIndent: AppPadding.p20,
    );
  }
}
