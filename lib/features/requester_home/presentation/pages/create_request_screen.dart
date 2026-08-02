import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';

class CreateRequestScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  const CreateRequestScreen({
    super.key,
    this.onSuccess,
    this.onNotifications,
    this.onProfile,
  });

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _unitsController = TextEditingController();
  final _notesController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _patientNationalIdController = TextEditingController();
  final _patientWeightController = TextEditingController();
  final _patientChronicDiseasesController = TextEditingController();
  String? _hospitalId;
  String? _bloodType;
  DateTime? _neededBy;
  DateTime? _patientDateOfBirth;
  String _patientGender = AppConstants.genderMale;
  BeneficiaryType _beneficiaryType = BeneficiaryType.self;
  RequestPriority _priority = RequestPriority.normal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showProfileNotice();
    });
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _notesController.dispose();
    _patientNameController.dispose();
    _patientNationalIdController.dispose();
    _patientWeightController.dispose();
    _patientChronicDiseasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestBloc, RequestState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status != RequestViewStatus.loading,
      listener: (context, state) {
        if (state.status == RequestViewStatus.success) {
          _showSuccessDialog();
        } else if (state.status == RequestViewStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.defaultError.tr()),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.white,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorManager.welcomeGradientStart,
                    ColorManager.welcomeGradientEnd,
                  ],
                ),
              ),
              child: Material(
                color: ColorManager.transparent,
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: AppSize.s402),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p10,
                          vertical: AppPadding.p32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: AppSize.s46),
                            _buildBanner(context),
                            const SizedBox(height: AppSize.s24),
                            Text(
                              AppStrings.urgencyLevel.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSize.s12),
                            _buildPrioritySelector(),
                            const SizedBox(height: AppSize.s24),
                            _buildHospitalField(state),
                            const SizedBox(height: AppSize.s16),
                            _buildBloodTypeField(),
                            const SizedBox(height: AppSize.s16),
                            if (_beneficiaryType == BeneficiaryType.other) ...[
                              _buildPatientFields(context),
                              const SizedBox(height: AppSize.s16),
                            ],
                            TextField(
                              key: WidgetKeys.requestUnitsField,
                              controller: _unitsController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: AppStrings.bagsRequired.tr(),
                                suffixIcon: const Icon(
                                  Icons.bloodtype_outlined,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSize.s16),
                            _buildDeadlineField(context),
                            const SizedBox(height: AppSize.s16),
                            TextField(
                              key: WidgetKeys.requestNotesField,
                              controller: _notesController,
                              maxLines: AppSize.s4.toInt(),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: AppStrings.notes.tr(),
                                suffixIcon: const Icon(Icons.notes_outlined),
                              ),
                            ),
                            if (state.hospitals.isEmpty &&
                                state.status != RequestViewStatus.loading) ...[
                              const SizedBox(height: AppSize.s12),
                              Text(
                                AppStrings.noVerifiedHospitals.tr(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: ColorManager.error),
                              ),
                            ],
                            const SizedBox(height: AppSize.s24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    key: WidgetKeys.requestSubmitButton,
                                    onPressed:
                                        state.status ==
                                                RequestViewStatus.submitting ||
                                            state.hospitals.isEmpty
                                        ? null
                                        : _submit,
                                    child:
                                        state.status ==
                                            RequestViewStatus.submitting
                                        ? SizedBox(
                                            width: AppSize.s24,
                                            height: AppSize.s24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: AppSize.s2,
                                              color: ColorManager.white,
                                            ),
                                          )
                                        : Text(AppStrings.next.tr()),
                                  ),
                                ),
                                const SizedBox(width: AppSize.s12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _clear,
                                    child: Text(AppStrings.clearFields.tr()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeUser.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                AppStrings.getWellSoon.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          key: WidgetKeys.requesterNotificationsButton,
          onPressed:
              widget.onNotifications ??
              () => Navigator.pushNamed(context, Routes.notificationsRoute),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(AppPadding.p8),
            backgroundColor: ColorManager.surfaceAlt,
            minimumSize: const Size.square(AppSize.s40),
            maximumSize: const Size.square(AppSize.s40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const CircleBorder(),
          ),
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.notifications_none_rounded, size: AppSize.s24),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [ColorManager.primary, ColorManager.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.createRequestBanner.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: ColorManager.white),
                ),
                const SizedBox(height: AppSize.s8),
                Text(
                  AppStrings.requestFormDescription.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ColorManager.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSize.s12),
          Icon(
            Icons.volunteer_activism_outlined,
            size: AppSize.s60,
            color: ColorManager.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSize.s8,
      runSpacing: AppSize.s8,
      children: RequestPriority.values.map((priority) {
        final selected = priority == _priority;
        final color = _priorityColor(priority);
        return ChoiceChip(
          selected: selected,
          onSelected: (_) => setState(() => _priority = priority),
          label: Text(_priorityLabel(priority).tr()),
          avatar: Icon(Icons.circle, size: AppSize.s8, color: color),
          selectedColor: color.withValues(alpha: AppOpacity.muted),
          side: BorderSide(color: selected ? color : ColorManager.borderGrey),
        );
      }).toList(),
    );
  }

  Widget _buildHospitalField(RequestState state) {
    return DropdownButtonFormField<String>(
      key: WidgetKeys.requestHospitalField,
      initialValue: _hospitalId,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: AppStrings.selectHospital.tr(),
        suffixIcon: const Icon(Icons.local_hospital_outlined),
      ),
      items: state.hospitals
          .map(
            (hospital) => DropdownMenuItem(
              value: hospital.id,
              child: Text(hospital.nameAr, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _hospitalId = value),
    );
  }

  Widget _buildBloodTypeField() {
    return DropdownButtonFormField<String>(
      key: WidgetKeys.requestBloodTypeField,
      initialValue: _bloodType,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: AppStrings.selectBloodType.tr(),
        suffixIcon: const Icon(Icons.bloodtype_outlined),
      ),
      items: supportedBloodTypes
          .map(
            (bloodType) =>
                DropdownMenuItem(value: bloodType, child: Text(bloodType)),
          )
          .toList(),
      onChanged: (value) => setState(() => _bloodType = value),
    );
  }

  Widget _buildPatientFields(BuildContext context) {
    final dateLabel = _patientDateOfBirth == null
        ? AppStrings.dateOfBirth.tr()
        : intl.DateFormat(
            AppConstants.requestDateFormat,
          ).format(_patientDateOfBirth!.toLocal());
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
      ),
      child: Column(
        children: [
          TextField(
            controller: _patientNameController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.patientName.tr(),
              suffixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: AppSize.s12),
          TextField(
            controller: _patientNationalIdController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.nationalId.tr(),
              suffixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: AppSize.s12),
          DropdownButtonFormField<String>(
            initialValue: _patientGender,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: AppStrings.gender.tr(),
              suffixIcon: const Icon(Icons.person_outline_rounded),
            ),
            items: [
              DropdownMenuItem(
                value: AppConstants.genderMale,
                child: Text(AppStrings.male.tr()),
              ),
              DropdownMenuItem(
                value: AppConstants.genderFemale,
                child: Text(AppStrings.female.tr()),
              ),
            ],
            onChanged: (value) =>
                setState(() => _patientGender = value ?? _patientGender),
          ),
          const SizedBox(height: AppSize.s12),
          TextField(
            controller: _patientWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.weight.tr(),
              suffixIcon: const Icon(Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: AppSize.s12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(dateLabel, textAlign: TextAlign.right),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () => _pickPatientDateOfBirth(context),
          ),
          const SizedBox(height: AppSize.s12),
          TextField(
            controller: _patientChronicDiseasesController,
            textAlign: TextAlign.right,
            maxLines: AppSize.s4.toInt(),
            decoration: InputDecoration(
              hintText: AppStrings.chronicDiseases.tr(),
              suffixIcon: const Icon(Icons.medical_information_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineField(BuildContext context) {
    final label = _neededBy == null
        ? AppStrings.optionalDeadline.tr()
        : intl.DateFormat(
            AppConstants.requestDateFormat,
          ).format(_neededBy!.toLocal());
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p4,
      ),
      tileColor: ColorManager.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
      ),
      title: Text(label),
      trailing: const Icon(Icons.calendar_today_outlined),
      onTap: () => _pickDeadline(context),
    );
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(
      const Duration(days: AppConstants.requestCalendarStartOffsetDays),
    );
    final selected = await showDatePicker(
      context: context,
      initialDate: _neededBy ?? firstDate,
      firstDate: firstDate,
      lastDate: now.add(
        const Duration(days: AppConstants.requestCalendarRangeDays),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _neededBy = selected);
    }
  }

  Future<void> _pickPatientDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _patientDateOfBirth ?? now,
      firstDate: DateTime(now.year - AppConstants.maxDonorAge),
      lastDate: now,
    );
    if (selected != null && mounted) {
      setState(() => _patientDateOfBirth = selected);
    }
  }

  void _submit() {
    final units = int.tryParse(_unitsController.text.trim());
    if (_hospitalId == null ||
        _bloodType == null ||
        units == null ||
        units <= AppSize.s0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.requiredRequestFields.tr())),
      );
      return;
    }

    final patient = _patientDraftOrNull();
    if (_beneficiaryType == BeneficiaryType.other && patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.patientDetailsRequired.tr())),
      );
      return;
    }

    context.read<RequestBloc>().add(
      RequestCreateSubmitted(
        RequestDraft(
          hospitalId: _hospitalId!,
          beneficiaryType: _beneficiaryType,
          patient: patient,
          bloodType: _bloodType!,
          priority: _priority,
          unitsNeeded: units,
          neededBy: _neededBy,
          notes: _notesController.text.trim(),
        ),
      ),
    );
  }

  PatientDraft? _patientDraftOrNull() {
    final weight = double.tryParse(_patientWeightController.text.trim());
    if (_beneficiaryType != BeneficiaryType.other ||
        _bloodType == null ||
        _patientNameController.text.trim().isEmpty ||
        _patientNationalIdController.text.trim().isEmpty ||
        weight == null ||
        weight <= AppSize.s0 ||
        _patientDateOfBirth == null) {
      return null;
    }
    return PatientDraft(
      fullName: _patientNameController.text.trim(),
      nationalId: _patientNationalIdController.text.trim(),
      bloodType: _bloodType!,
      weight: weight,
      chronicDiseases: _patientChronicDiseasesController.text.trim(),
      gender: _patientGender,
      dateOfBirth: intl.DateFormat(
        AppConstants.requestPatientDateFormat,
      ).format(_patientDateOfBirth!),
    );
  }

  void _clear() {
    setState(() {
      _hospitalId = null;
      _bloodType = null;
      _neededBy = null;
      _priority = RequestPriority.normal;
      _unitsController.clear();
      _notesController.clear();
      _patientNameController.clear();
      _patientNationalIdController.clear();
      _patientWeightController.clear();
      _patientChronicDiseasesController.clear();
      _patientDateOfBirth = null;
      _patientGender = AppConstants.genderMale;
    });
  }

  void _showProfileNotice() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: ColorManager.transparent,
          elevation: AppSize.s0,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Container(
            width: AppSize.s320,
            padding: const EdgeInsets.all(AppSize.s40),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppSize.s40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  SvgAssets.warning,
                  width: AppSize.s60,
                  height: AppSize.s60,
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.profileDataTitle.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.titleMedium
                      ?.copyWith(
                        color: ColorManager.welcomeText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.profileDataNotice.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                    color: ColorManager.welcomeText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _showBeneficiaryDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s11_6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusDialogAction,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.confirm.tr()),
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      (widget.onProfile ??
                              () => Navigator.pushNamed(
                                context,
                                Routes.requesterProfileRoute,
                              ))
                          .call();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorManager.welcomeText,
                      foregroundColor: ColorManager.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s11_6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusDialogAction,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.updateProfile.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBeneficiaryDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: ColorManager.transparent,
          elevation: AppSize.s0,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Container(
            width: AppSize.s320,
            padding: const EdgeInsets.all(AppSize.s40),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppSize.s40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  SvgAssets.warning,
                  width: AppSize.s60,
                  height: AppSize.s60,
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.requestBeneficiaryTitle.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.titleMedium
                      ?.copyWith(
                        color: ColorManager.welcomeText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.requestBeneficiaryBody.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                    color: ColorManager.welcomeText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: ElevatedButton(
                    key: WidgetKeys.requestForSelfButton,
                    onPressed: () {
                      setState(() => _beneficiaryType = BeneficiaryType.self);
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s11_6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusDialogAction,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.requestForSelf.tr()),
                  ),
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: TextButton(
                    key: WidgetKeys.requestForOtherButton,
                    onPressed: () {
                      setState(() => _beneficiaryType = BeneficiaryType.other);
                      Navigator.pop(dialogContext);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorManager.welcomeText,
                      foregroundColor: ColorManager.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s11_6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusDialogAction,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.requestForOther.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: ColorManager.dialogScrim,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: ColorManager.transparent,
          elevation: AppSize.s0,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Container(
            width: AppSize.s320,
            padding: const EdgeInsets.all(AppSize.s40),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppSize.s40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  SvgAssets.successCheck,
                  width: AppSize.s60,
                  height: AppSize.s60,
                ),
                const SizedBox(height: AppSize.s10),
                Text(
                  AppStrings.requestCreated.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.titleMedium
                      ?.copyWith(
                        color: ColorManager.welcomeText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSize.s10),
                Image.asset(
                  ImageAssets.icon6,
                  width: AppSize.s76,
                  height: AppSize.s76,
                ),
                const SizedBox(height: AppSize.s10),
                SizedBox(
                  width: AppSize.s174,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      widget.onSuccess?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s11_6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusDialogAction,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.myRequests.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _priorityLabel(RequestPriority priority) => switch (priority) {
  RequestPriority.normal => AppStrings.normal,
  RequestPriority.semiUrgent => AppStrings.semiUrgent,
  RequestPriority.urgent => AppStrings.veryUrgent,
};

Color _priorityColor(RequestPriority priority) => switch (priority) {
  RequestPriority.normal => ColorManager.success,
  RequestPriority.semiUrgent => ColorManager.warning,
  RequestPriority.urgent => ColorManager.error,
};
