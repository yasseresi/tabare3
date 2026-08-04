import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/algerian_wilayas.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/hero_banner.dart';
import '../../../../core/presentation/widgets/searchable_wilaya_field.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import '../widgets/request_form_fields.dart';

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
  final _wilayaController = TextEditingController();
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

  /// The third-party flow is two Figma screens: the patient identity step and
  /// the request step. The `for myself` flow only ever shows the second one.
  bool _isPatientStep = false;

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
    _wilayaController.dispose();
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.transparent,
            body: AppPage(
              title: AppStrings.welcomeUser.tr(),
              subtitle: AppStrings.getWellSoon.tr(),
              notificationsKey: WidgetKeys.requesterNotificationsButton,
              onNotifications:
                  widget.onNotifications ??
                  () => Navigator.pushNamed(context, Routes.notificationsRoute),
              children: _isPatientStep
                  ? _buildPatientStep()
                  : _buildRequestStep(state),
            ),
          ),
        );
      },
    );
  }

  /// Figma `776:188` — the third-party patient identity step.
  List<Widget> _buildPatientStep() {
    final dateOfBirth = _patientDateOfBirth;
    return [
      HeroBanner(
        title: AppStrings.createRequestBanner.tr(),
        message: AppStrings.otherRequestDescription.tr(),
      ),
      const SizedBox(height: AppSize.s12),
      RequestFormSection(
        hintColor: ColorManager.lightGrey,
        children: [
          AppTextField(
            hintText: AppStrings.username.tr(),
            prefixSvg: SvgAssets.person,
            controller: _patientNameController,
          ),
          AppTextField(
            hintText: AppStrings.nationalId.tr(),
            prefixSvg: SvgAssets.idSerialNumber,
            controller: _patientNationalIdController,
            keyboardType: TextInputType.number,
          ),
          RequestDropdownField<String>(
            value: _patientGender,
            hintText: AppStrings.gender.tr(),
            prefixSvg: SvgAssets.person,
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
          RequestPickerField(
            label: dateOfBirth == null
                ? AppStrings.dateOfBirth.tr()
                : intl.DateFormat(
                    AppConstants.requestDateFormat,
                  ).format(dateOfBirth.toLocal()),
            prefixSvg: SvgAssets.calendarDate,
            isPlaceholder: dateOfBirth == null,
            onTap: () => _pickPatientDateOfBirth(context),
          ),
          AppTextField(
            hintText: AppStrings.weight.tr(),
            prefixSvg: SvgAssets.weight,
            controller: _patientWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          RequestDropdownField<String>(
            value: _bloodType,
            hintText: AppStrings.bloodType.tr(),
            prefixSvg: SvgAssets.bloodType,
            items: supportedBloodTypes
                .map(
                  (bloodType) =>
                      DropdownMenuItem(value: bloodType, child: Text(bloodType)),
                )
                .toList(),
            onChanged: (value) => setState(() => _bloodType = value),
          ),
          AppTextField(
            hintText: AppStrings.chronicDiseases.tr(),
            prefixSvg: SvgAssets.requestNote,
            controller: _patientChronicDiseasesController,
            isMultiline: true,
          ),
        ],
      ),
      const SizedBox(height: AppSize.s12),
      RequestFooterButtons(
        clearLabel: AppStrings.clearFields.tr(),
        onClear: _clear,
        actionLabel: AppStrings.next.tr(),
        onAction: () => setState(() => _isPatientStep = false),
      ),
    ];
  }

  /// Figma `774:79` (for myself) and `776:342` (for someone else).
  List<Widget> _buildRequestStep(RequestState state) {
    final isForOther = _beneficiaryType == BeneficiaryType.other;
    final hospitals = _visibleHospitals(state);
    final neededBy = _neededBy;
    return [
      HeroBanner(
        title: AppStrings.createRequestBanner.tr(),
        message: isForOther
            ? AppStrings.otherRequestDescription.tr()
            : AppStrings.requestFormDescription.tr(),
      ),
      const SizedBox(height: AppSize.s12),
      RequestUrgencySelector<RequestPriority>(
        title: AppStrings.urgencyLevel.tr(),
        selected: _priority,
        unselectedBackground: ColorManager.white,
        onSelected: (priority) => setState(() => _priority = priority),
        options: _priorityOptions(),
      ),
      const SizedBox(height: AppSize.s12),
      RequestFormSection(
        children: [
          AppTextField(
            key: WidgetKeys.requestUnitsField,
            hintText: AppStrings.bagsRequired.tr(),
            prefixSvg: SvgAssets.requestBags,
            controller: _unitsController,
            keyboardType: TextInputType.number,
          ),
          if (!isForOther)
            SearchableWilayaField(controller: _wilayaController),
          RequestDropdownField<String>(
            fieldKey: WidgetKeys.requestHospitalField,
            value: hospitals.any((hospital) => hospital.id == _hospitalId)
                ? _hospitalId
                : null,
            hintText: AppStrings.hospitalNameField.tr(),
            prefixSvg: SvgAssets.requestHospital,
            items: hospitals
                .map(
                  (hospital) => DropdownMenuItem(
                    value: hospital.id,
                    child: Text(
                      hospital.nameAr,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _hospitalId = value),
          ),
          if (!isForOther)
            RequestDropdownField<String>(
              fieldKey: WidgetKeys.requestBloodTypeField,
              value: _bloodType,
              hintText: AppStrings.bloodType.tr(),
              prefixSvg: SvgAssets.bloodType,
              items: supportedBloodTypes
                  .map(
                    (bloodType) => DropdownMenuItem(
                      value: bloodType,
                      child: Text(bloodType),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _bloodType = value),
            ),
          RequestPickerField(
            label: neededBy == null
                ? AppStrings.deadlineField.tr()
                : intl.DateFormat(
                    AppConstants.requestDateFormat,
                  ).format(neededBy.toLocal()),
            prefixSvg: SvgAssets.calendarDate,
            isPlaceholder: neededBy == null,
            onTap: () => _pickDeadline(context),
          ),
          AppTextField(
            key: WidgetKeys.requestNotesField,
            hintText: isForOther
                ? AppStrings.requestReason.tr()
                : AppStrings.notes.tr(),
            prefixSvg: SvgAssets.requestNote,
            controller: _notesController,
            isMultiline: true,
          ),
        ],
      ),
      if (state.hospitals.isEmpty &&
          state.status != RequestViewStatus.loading) ...[
        const SizedBox(height: AppSize.s12),
        Text(
          AppStrings.noVerifiedHospitals.tr(),
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontSize: FontSize.s12,
            color: ColorManager.error,
          ),
        ),
      ],
      const SizedBox(height: AppSize.s12),
      RequestFooterButtons(
        clearLabel: AppStrings.clearFields.tr(),
        onClear: _clear,
        actionLabel: AppStrings.next.tr(),
        actionKey: WidgetKeys.requestSubmitButton,
        isBusy: state.status == RequestViewStatus.submitting,
        onAction:
            state.status == RequestViewStatus.submitting ||
                state.hospitals.isEmpty
            ? null
            : _submit,
      ),
    ];
  }

  List<RequestUrgencyOption<RequestPriority>> _priorityOptions() =>
      RequestPriority.values
          .map(
            (priority) => RequestUrgencyOption(
              value: priority,
              label: _priorityLabel(priority).tr(),
              dotColor: _priorityColor(priority),
            ),
          )
          .toList();

  /// Hospitals narrowed to the wilaya typed into the Figma `الولاية` field —
  /// a view-level filter over the list the bloc already loaded.
  List<HospitalEntity> _visibleHospitals(RequestState state) {
    final index = algerianWilayas.indexOf(_wilayaController.text.trim());
    if (index < AppSize.s0.toInt()) return state.hospitals;
    final wilayaId = index + AppSize.s1.toInt();
    return state.hospitals
        .where((hospital) => hospital.wilayaId == wilayaId)
        .toList();
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
      _wilayaController.clear();
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
        child: AppDialog.warning(
          title: AppStrings.profileDataTitle.tr(),
          message: AppStrings.profileDataNotice.tr(),
          actionLabel: AppStrings.confirm.tr(),
          onAction: () {
            Navigator.pop(dialogContext);
            _showBeneficiaryDialog();
          },
          secondaryLabel: AppStrings.updateProfile.tr(),
          onSecondaryAction: () {
            Navigator.pop(dialogContext);
            (widget.onProfile ??
                    () => Navigator.pushNamed(
                      context,
                      Routes.requesterProfileRoute,
                    ))
                .call();
          },
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
        child: AppDialog.warning(
          title: AppStrings.requestBeneficiaryTitle.tr(),
          message: AppStrings.requestBeneficiaryBody.tr(),
          actionLabel: AppStrings.requestForSelf.tr(),
          actionKey: WidgetKeys.requestForSelfButton,
          onAction: () {
            setState(() {
              _beneficiaryType = BeneficiaryType.self;
              _isPatientStep = false;
            });
            Navigator.pop(dialogContext);
          },
          secondaryLabel: AppStrings.requestForOther.tr(),
          secondaryKey: WidgetKeys.requestForOtherButton,
          onSecondaryAction: () {
            setState(() {
              _beneficiaryType = BeneficiaryType.other;
              _isPatientStep = true;
            });
            Navigator.pop(dialogContext);
          },
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
        child: AppDialog.success(
          title: AppStrings.requestCreated.tr(),
          actionLabel: AppStrings.myRequests.tr(),
          onAction: () {
            Navigator.pop(dialogContext);
            widget.onSuccess?.call();
          },
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
  RequestPriority.normal => ColorManager.urgencyNormal,
  RequestPriority.semiUrgent => ColorManager.urgencyUrgent,
  RequestPriority.urgent => ColorManager.urgencyCritical,
};
