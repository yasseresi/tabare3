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
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import '../widgets/request_form_fields.dart';

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
  final _wilayaController = TextEditingController();
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
    _wilayaController.dispose();
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
        final hospitals = _visibleHospitals(state);
        final neededBy = _neededBy;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.transparent,
            body: AppPage(
              title: welcomeTitle(),
              subtitle: AppStrings.getWellSoon.tr(),
              notificationsKey: WidgetKeys.requesterNotificationsButton,
              onNotifications:
                  widget.onNotifications ??
                  () => Navigator.pushNamed(context, Routes.notificationsRoute),
              children: [
                HeroBanner(
                  title: AppStrings.editRequestBanner.tr(),
                  message: AppStrings.requestFormDescription.tr(),
                ),
                const SizedBox(height: AppSize.s12),
                RequestUrgencySelector<RequestPriority>(
                  title: AppStrings.urgencyLevel.tr(),
                  selected: _priority,
                  unselectedBackground: ColorManager.surfaceLight,
                  onSelected: (priority) => setState(() => _priority = priority),
                  options: RequestPriority.values
                      .map(
                        (priority) => RequestUrgencyOption(
                          value: priority,
                          label: _priorityLabel(priority).tr(),
                          dotColor: _priorityColor(priority),
                        ),
                      )
                      .toList(),
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
                    SearchableWilayaField(controller: _wilayaController),
                    RequestDropdownField<String>(
                      fieldKey: WidgetKeys.requestHospitalField,
                      value: hospitals.any(
                        (hospital) => hospital.id == _hospitalId,
                      )
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
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _hospitalId = value);
                        }
                      },
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
                      hintText: AppStrings.notes.tr(),
                      prefixSvg: SvgAssets.requestNote,
                      controller: _notesController,
                      isMultiline: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s12),
                _RequestStatusToggle(
                  isActive: widget.request.isActive,
                  onChanged: state.status == RequestViewStatus.submitting
                      ? null
                      : (_) => _showCancellationDialog(),
                ),
                const SizedBox(height: AppSize.s12),
                RequestFooterButtons(
                  clearLabel: AppStrings.clearFields.tr(),
                  onClear: _clear,
                  actionLabel: AppStrings.save.tr(),
                  actionKey: WidgetKeys.requestEditSaveButton,
                  isBusy: state.status == RequestViewStatus.submitting,
                  onAction: state.status == RequestViewStatus.submitting
                      ? null
                      : _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Hospitals narrowed to the wilaya typed into the Figma `الولاية` field —
  /// a view-level filter over the list the bloc already loaded.
  List<HospitalEntity> _visibleHospitals(RequestState state) {
    final index = algerianWilayas.indexOf(_wilayaController.text.trim());
    if (index < AppSize.s0) return state.hospitals;
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

  void _clear() {
    setState(() {
      _hospitalId = widget.request.hospital.id;
      _bloodType = widget.request.bloodType;
      _priority = widget.request.priority;
      _neededBy = widget.request.neededBy;
      _wilayaController.clear();
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
        child: AppDialog.success(
          title: AppStrings.editSuccess.tr(),
          actionLabel: AppStrings.homePage.tr(),
          onAction: () {
            Navigator.pop(dialogContext);
            if (widget.onComplete != null) {
              widget.onComplete!();
            } else {
              Navigator.maybePop(context);
            }
          },
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

/// Figma `Button - Mode`: the `حالة الطلب` label with the active/closed switch
/// that opens the cancellation flow.
class _RequestStatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const _RequestStatusToggle({required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        bottom: AppPadding.p21,
        left: AppPadding.p20,
        right: AppPadding.p20,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorManager.surfaceLight,
            width: AppSize.s1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.requestStatus.tr(),
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: ColorManager.black,
                  ),
                ),
                Text(
                  AppStrings.activeOrClosed.tr(),
                  style: getMediumStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.navInactive,
                  ),
                ),
              ],
            ),
          ),
          _StatusSwitch(isActive: isActive, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const _StatusSwitch({required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final action = onChanged;
    return InkWell(
      key: WidgetKeys.requestCancelButton,
      onTap: action == null ? null : () => action(!isActive),
      borderRadius: BorderRadius.circular(AppSize.radiusCircle),
      child: SizedBox(
        width: AppSize.s44,
        height: AppSize.s24,
        child: Stack(
          children: [
            Container(
              width: AppSize.s44,
              height: AppSize.s24,
              decoration: BoxDecoration(
                color: isActive
                    ? ColorManager.success
                    : ColorManager.toggleTrack,
                borderRadius: BorderRadius.circular(AppSize.radiusCircle),
              ),
            ),
            Positioned(
              top: AppSize.s2,
              left: isActive ? AppSize.s2 : AppSize.s22,
              child: Container(
                width: AppSize.s20,
                height: AppSize.s20,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.toggleKnobBorder,
                    width: AppSize.s1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  RequestPriority.normal => ColorManager.urgencyNormal,
  RequestPriority.semiUrgent => ColorManager.urgencyUrgent,
  RequestPriority.urgent => ColorManager.urgencyCritical,
};
