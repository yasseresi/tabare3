import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';

class EditRequestScreen extends StatefulWidget {
  final BloodRequestEntity request;

  const EditRequestScreen({super.key, required this.request});

  @override
  State<EditRequestScreen> createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  late final TextEditingController _unitsController;
  late final TextEditingController _notesController;
  late String _hospitalId;
  late String _bloodType;
  late RequestPriority _priority;
  DateTime? _neededBy;

  @override
  void initState() {
    super.initState();
    _hospitalId = widget.request.hospital.id;
    _bloodType = widget.request.bloodType;
    _priority = widget.request.priority;
    _neededBy = widget.request.neededBy;
    _unitsController = TextEditingController(
      text: widget.request.unitsNeeded.toString(),
    );
    _notesController = TextEditingController(text: widget.request.notes);
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
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == RequestViewStatus.success) {
          Navigator.maybePop(context);
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
          appBar: AppBar(title: Text(AppStrings.editRequest.tr())),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBanner(context),
                    const SizedBox(height: AppSize.s24),
                    _buildPrioritySelector(),
                    const SizedBox(height: AppSize.s16),
                    DropdownButtonFormField<String>(
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
                              child: Text(
                                hospital.nameAr,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _hospitalId = value);
                        }
                      },
                    ),
                    const SizedBox(height: AppSize.s16),
                    DropdownButtonFormField<String>(
                      key: WidgetKeys.requestBloodTypeField,
                      initialValue: _bloodType,
                      decoration: InputDecoration(
                        hintText: AppStrings.selectBloodType.tr(),
                        suffixIcon: const Icon(Icons.bloodtype_outlined),
                      ),
                      items: supportedBloodTypes
                          .map(
                            (bloodType) => DropdownMenuItem(
                              value: bloodType,
                              child: Text(bloodType),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _bloodType = value);
                        }
                      },
                    ),
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
                    const SizedBox(height: AppSize.s24),
                    ElevatedButton(
                      key: WidgetKeys.requestEditSaveButton,
                      onPressed: state.status == RequestViewStatus.submitting
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
                          : Text(AppStrings.saveChanges.tr()),
                    ),
                    const SizedBox(height: AppSize.s12),
                    OutlinedButton(
                      key: WidgetKeys.requestCancelButton,
                      onPressed: state.status == RequestViewStatus.submitting
                          ? null
                          : _showCancellationDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.error,
                        side: BorderSide(color: ColorManager.error),
                      ),
                      child: Text(AppStrings.cancelRequest.tr()),
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

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.primaryDark,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
      ),
      child: Text(
        AppStrings.editRequestBanner.tr(),
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: ColorManager.white),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSize.s8,
      runSpacing: AppSize.s8,
      children: RequestPriority.values.map((priority) {
        final color = _priorityColor(priority);
        return ChoiceChip(
          selected: _priority == priority,
          onSelected: (_) => setState(() => _priority = priority),
          label: Text(_priorityLabel(priority).tr()),
          avatar: Icon(Icons.circle, size: AppSize.s8, color: color),
          selectedColor: color.withValues(alpha: AppOpacity.muted),
        );
      }).toList(),
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
    if (units == null || units <= AppSize.s0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.requiredRequestFields.tr())),
      );
      return;
    }

    context.read<RequestBloc>().add(
      RequestUpdateSubmitted(
        requestId: widget.request.id,
        draft: RequestDraft(
          hospitalId: _hospitalId,
          bloodType: _bloodType,
          priority: _priority,
          unitsNeeded: units,
          neededBy: _neededBy,
          notes: _notesController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _showCancellationDialog() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const _CancellationDialog(),
    );

    if (reason != null && mounted) {
      context.read<RequestBloc>().add(
        RequestCancelSubmitted(requestId: widget.request.id, reason: reason),
      );
    }
  }
}

class _CancellationDialog extends StatefulWidget {
  const _CancellationDialog();

  @override
  State<_CancellationDialog> createState() => _CancellationDialogState();
}

class _CancellationDialogState extends State<_CancellationDialog> {
  final _reasonController = TextEditingController();
  String? _validationMessage;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.cancelRequest.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.confirmCancelRequest.tr(),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: AppSize.s16),
            TextField(
              key: WidgetKeys.requestCancelReasonField,
              controller: _reasonController,
              maxLines: AppSize.s3.toInt(),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: AppStrings.cancellationReason.tr(),
                errorText: _validationMessage,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel.tr()),
        ),
        ElevatedButton(
          key: WidgetKeys.requestCancelConfirmButton,
          onPressed: _confirm,
          child: Text(AppStrings.confirm.tr()),
        ),
      ],
    );
  }

  void _confirm() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(
        () => _validationMessage = AppStrings.cancellationReasonRequired.tr(),
      );
      return;
    }
    Navigator.pop(context, reason);
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
