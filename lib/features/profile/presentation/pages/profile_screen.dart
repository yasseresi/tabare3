import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/presentation/widgets/logout_dialog.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/assets_manager.dart';
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
  final bool showRecipientIdentityDetails;
  final VoidCallback? onAbout;
  final VoidCallback? onDonorCard;
  final VoidCallback? onNotifications;
  final VoidCallback? onQrCode;

  const ProfileScreen({
    super.key,
    this.showRecipientIdentityDetails = true,
    this.onAbout,
    this.onDonorCard,
    this.onNotifications,
    this.onQrCode,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appTextDirection(context),
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBg,
        body: AppGradientBackground(
          key: WidgetKeys.profileGradientBackground,
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
                  showRecipientIdentityDetails: showRecipientIdentityDetails,
                  onAbout: onAbout,
                  onDonorCard: onDonorCard,
                  onNotifications: onNotifications,
                  onQrCode: onQrCode,
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
  final bool showRecipientIdentityDetails;
  final VoidCallback? onAbout;
  final VoidCallback? onDonorCard;
  final VoidCallback? onNotifications;
  final VoidCallback? onQrCode;

  const _ProfileContent({
    required this.profile,
    required this.isEditing,
    required this.showRecipientIdentityDetails,
    required this.onAbout,
    required this.onDonorCard,
    required this.onNotifications,
    required this.onQrCode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppPadding.p32),
      child: Column(
        children: [
          _buildHeader(context),
          // Figma floats the header over the page and starts the content at
          // y=150; the inline header measures 128.
          const SizedBox(height: AppSize.s22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarSection(context),
                const SizedBox(height: AppSize.s12),
                _buildAccountSection(context),
                const SizedBox(height: AppSize.s12),
                _buildPersonalSection(context),
                // Edit mode drops the read-only QR and app-info groups.
                if (!isEditing) ...[
                  if (onQrCode != null) ...[
                    const SizedBox(height: AppSize.s12),
                    _buildQrSection(context),
                  ],
                  const SizedBox(height: AppSize.s12),
                  _buildAppSection(context),
                ],
              ],
            ),
          ),
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

    return AppHeader(
      title: '${AppStrings.welcome.tr()}، $firstName',
      subtitle: subtitle,
      notificationsKey: WidgetKeys.profileNotificationsButton,
      onNotifications:
          onNotifications ??
          () => Navigator.pushNamed(context, Routes.notificationsRoute),
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
            lineHeight: LineHeight.h28,
          ),
        ),
        Text(
          profile.username,
          style: getRegularStyle(
            fontSize: FontSize.s14,
            color: ColorManager.lightGrey,
            lineHeight: LineHeight.h20,
          ),
        ),
        const SizedBox(height: AppSize.s5),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isEditing) {
      return _ProfileChip(
        label: AppStrings.saveChanges.tr(),
        icon: SvgAssets.profileEdit,
        iconSize: AppSize.s15,
        onTap: () => context.read<ProfileBloc>().add(SaveProfile(profile)),
      );
    }

    final editChip = _ProfileChip(
      label: AppStrings.edit.tr(),
      icon: SvgAssets.profileEdit,
      onTap: () => context.read<ProfileBloc>().add(const ToggleEditMode()),
    );

    if (!profile.isDonor) return editChip;

    // Figma renders `تعديل` on the reading side and `بطاقة المتبرع` after it.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        editChip,
        const SizedBox(width: AppSize.s12),
        _ProfileChip(
          label: AppStrings.donorCard.tr(),
          icon: SvgAssets.giftCard,
          iconWidth: AppSize.s16_67,
          iconHeight: AppSize.s12_5,
          onTap:
              onDonorCard ??
              () => Navigator.pushNamed(context, Routes.donorCardRoute),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return ProfileSection(
      title: AppStrings.accountInfo.tr(),
      children: [
        ProfileRow(
          label: AppStrings.phoneNumberLabel.tr(),
          value: profile.phone,
          icon: SvgAssets.profilePhone,
          onTap: _editTap(
            context,
            AppStrings.phoneNumberLabel.tr(),
            profile.phone,
            (v) => _updateProfile(context, phone: v),
          ),
        ),
        ProfileRow(
          label: AppStrings.accountType.tr(),
          value: _roleLabel(profile),
          icon: SvgAssets.profileAccountType,
          trailing: isEditing
              ? const ProfileRowChevron(pointsDown: true)
              : null,
          onTap: isEditing ? () => _showRoleBottomSheet(context) : null,
        ),
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
        // Identity fields are read-only, so edit mode drops them entirely.
        if (showRecipientIdentityDetails && !isEditing) ...[
          ProfileRow(
            label: AppStrings.dateOfBirth.tr(),
            value: _formattedBirthDate(context),
            icon: SvgAssets.profileBirthDate,
          ),
          ProfileRow(
            label: AppStrings.gender.tr(),
            value: profile.gender == AppConstants.genderFemale
                ? AppStrings.female.tr()
                : AppStrings.male.tr(),
            icon: SvgAssets.profileGender,
          ),
          ProfileRow(
            label: AppStrings.nationalId.tr(),
            value: profile.nationalId ?? AppStrings.notAvailable.tr(),
            icon: SvgAssets.profileNationalId,
            stackValue: true,
          ),
          ProfileRow(
            label: AppStrings.bloodType.tr(),
            value: profile.bloodType,
            icon: SvgAssets.profileBloodType,
          ),
        ],
        ProfileRow(
          label: AppStrings.weight.tr(),
          value: profile.weight != null
              ? '${profile.weight} ${AppStrings.kg.tr()}'
              : '',
          icon: SvgAssets.profileWeight,
          onTap: isEditing
              ? () => ProfileFieldEditors.pickWeight(
                  context,
                  profile.weight,
                  (v) => _updateProfile(context, weight: v),
                )
              : null,
        ),
        ProfileRow(
          label: AppStrings.governorate.tr(),
          value: profile.city,
          icon: SvgAssets.profileWilaya,
          onTap: isEditing
              ? () => ProfileFieldEditors.pickWilaya(
                  context,
                  profile.city,
                  (v) => _updateProfile(context, city: v),
                )
              : null,
        ),
        ProfileRow(
          label: AppStrings.chronicDiseases.tr(),
          value: profile.chronicDiseases ?? AppStrings.notAvailable.tr(),
          icon: SvgAssets.profileDiseases,
          height: AppSize.s105,
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

  String _formattedBirthDate(BuildContext context) {
    final parsed = DateTime.tryParse(profile.dateOfBirth);
    if (parsed == null) return profile.dateOfBirth;
    return intl.DateFormat.yMMMMd(context.locale.languageCode).format(parsed);
  }

  Widget _buildQrSection(BuildContext context) {
    return ProfileSection(
      title: AppStrings.qrSection.tr(),
      children: [
        ProfileRow(
          key: WidgetKeys.profileQrRow,
          label: profile.isDonor
              ? AppStrings.scanQrCode.tr()
              : AppStrings.qrSection.tr(),
          value: '',
          icon: SvgAssets.profileQr,
          trailing: const ProfileRowChevron(),
          onTap: onQrCode,
        ),
      ],
    );
  }

  /// Figma renders the app-info group as a bare card with no section title.
  Widget _buildAppSection(BuildContext context) {
    return ProfileSection(
      children: [
        ProfileRow(
          label: AppStrings.appInfo.tr(),
          value: '',
          icon: SvgAssets.profileInfo,
          trailing: const ProfileRowChevron(),
          onTap:
              onAbout ??
              () => Navigator.pushNamed(context, Routes.aboutAppRoute),
        ),
        ProfileRow(
          label: AppStrings.logout.tr(),
          value: '',
          icon: SvgAssets.profileLogout,
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

  void _updateProfile(
    BuildContext context, {
    String? fullName,
    String? phone,
    double? weight,
    String? city,
    String? chronicDiseases,
  }) {
    final updated = profile.copyWith(
      fullName: fullName ?? profile.fullName,
      phone: phone ?? profile.phone,
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
      child: Container(
        width: AppSize.s96,
        height: AppSize.s96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.surface,
          border: Border.all(color: ColorManager.white, width: AppSize.s4),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
              blurRadius: AppSize.s2,
              offset: const Offset(AppSize.s0, AppSize.s1),
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

/// Figma `Address Row > Button`: white pill with an `#E8EFF3` hairline, 17/7
/// padding and the glyph trailing the label.
class _ProfileChip extends StatelessWidget {
  final String label;
  final String icon;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final VoidCallback onTap;

  const _ProfileChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconSize,
    this.iconWidth,
    this.iconHeight,
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
          border: Border.all(color: ColorManager.donorCardChipBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
                lineHeight: LineHeight.h20,
              ),
            ),
            const SizedBox(width: AppSize.s8),
            SizedBox(
              width: AppSize.s20,
              height: AppSize.s20,
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: iconWidth ?? iconSize ?? AppSize.s20,
                  height: iconHeight ?? iconSize ?? AppSize.s20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
