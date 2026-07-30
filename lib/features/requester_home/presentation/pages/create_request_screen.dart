import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';

class CreateRequestScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const CreateRequestScreen({super.key, this.onSuccess});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _unitsController = TextEditingController();
  final _notesController = TextEditingController();
  String? _hospitalId;
  String? _bloodType;
  DateTime? _neededBy;
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
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: AppSize.s24),
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
                    TextField(
                      key: WidgetKeys.requestUnitsField,
                      controller: _unitsController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: AppStrings.bagsRequired.tr(),
                        suffixIcon: const Icon(Icons.bloodtype_outlined),
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSize.s24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            key: WidgetKeys.requestSubmitButton,
                            onPressed:
                                state.status == RequestViewStatus.submitting ||
                                    state.hospitals.isEmpty
                                ? null
                                : _submit,
                            child: state.status == RequestViewStatus.submitting
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
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.primaryDark,
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

    context.read<RequestBloc>().add(
      RequestCreateSubmitted(
        RequestDraft(
          hospitalId: _hospitalId!,
          bloodType: _bloodType!,
          priority: _priority,
          unitsNeeded: units,
          neededBy: _neededBy,
          notes: _notesController.text.trim(),
        ),
      ),
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
    });
  }

  void _showProfileNotice() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: ColorManager.error,
          size: AppSize.s76,
        ),
        title: Text(
          AppStrings.profileDataTitle.tr(),
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppStrings.profileDataNotice.tr(),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.confirm.tr()),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamed(context, Routes.requesterProfileRoute);
            },
            child: Text(AppStrings.updateProfile.tr()),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: ColorManager.success,
          size: AppSize.s76,
        ),
        content: Text(
          AppStrings.requestCreated.tr(),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              widget.onSuccess?.call();
            },
            child: Text(AppStrings.myRequests.tr()),
          ),
        ],
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
