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

class EditRequestScreen extends StatefulWidget {
  final BloodRequestEntity request;
  final VoidCallback? onComplete;
  final VoidCallback? onNotifications;

  const EditRequestScreen({
    super.key,
    required this.request,
    this.onComplete,
    this.onNotifications,
  });

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
            body: Container(
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
                          const SizedBox(height: AppSize.s16),
                          DropdownButtonFormField<String>(
                            key: WidgetKeys.requestHospitalField,
                            initialValue: _hospitalId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: AppStrings.selectHospital.tr(),
                              suffixIcon: const Icon(
                                Icons.local_hospital_outlined,
                              ),
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
                            isExpanded: true,
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
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  key: WidgetKeys.requestEditSaveButton,
                                  onPressed:
                                      state.status ==
                                          RequestViewStatus.submitting
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
                                      : Text(AppStrings.saveChanges.tr()),
                                ),
                              ),
                              const SizedBox(width: AppSize.s20),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _clear,
                                  child: Text(AppStrings.clearFields.tr()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSize.s12),
                          TextButton(
                            key: WidgetKeys.requestCancelButton,
                            onPressed:
                                state.status == RequestViewStatus.submitting
                                ? null
                                : _showCancellationDialog,
                            style: TextButton.styleFrom(
                              foregroundColor: ColorManager.error,
                            ),
                            child: Text(AppStrings.cancelRequest.tr()),
                          ),
                        ],
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
                style: const TextStyle(
                  fontSize: AppSize.s18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                AppStrings.getWellSoon.tr(),
                style: TextStyle(
                  color: ColorManager.textMuted,
                  fontSize: AppSize.s14,
                  fontWeight: FontWeight.w600,
                ),
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
                  AppStrings.editRequestBanner.tr(),
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
    return Material(
      color: ColorManager.transparent,
      child: ListTile(
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
      ),
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

  void _clear() {
    setState(() {
      _hospitalId = widget.request.hospital.id;
      _bloodType = widget.request.bloodType;
      _priority = widget.request.priority;
      _neededBy = widget.request.neededBy;
      _unitsController.text = widget.request.unitsNeeded.toString();
      _notesController.text = widget.request.notes ?? '';
    });
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
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
            padding: const EdgeInsets.all(AppPadding.p40),
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
                  AppStrings.editSuccess.tr(),
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
                      if (widget.onComplete != null) {
                        widget.onComplete!();
                      } else {
                        Navigator.maybePop(context);
                      }
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
                    child: Text(AppStrings.homePage.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
