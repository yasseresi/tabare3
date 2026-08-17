import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/algerian_wilayas.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/adaptive_pickers.dart';
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
import '../widgets/request_cancellation_dialog.dart';
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
  // Null when the request has no hospital attached — the user must pick one
  // before the edit can be submitted.
  String? _hospitalId;
  late String _bloodType;
  late RequestPriority _priority;
  DateTime? _neededBy;

  @override
  void initState() {
    super.initState();
    _hospitalId = widget.request.hospital?.id;
    _wilayaController.text = _wilayaNameFor(widget.request.hospital?.wilayaId);
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
        // Read the live status from the bloc: once a cancellation lands, the
        // bloc replaces this request with a cancelled copy. Reading
        // `widget.request` would leave the switch green forever and re-open
        // the cancel dialog on every tap. The API has no reopen endpoint, so
        // the switch is one-way — deactivate only.
        final currentRequest = state.requests.firstWhere(
          (request) => request.id == widget.request.id,
          orElse: () => widget.request,
        );
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
                    SearchableWilayaField(
                      controller: _wilayaController,
                      // Wilaya drives the hospital list; rebuild and drop any
                      // hospital picked under the previous wilaya.
                      onChanged: (_) => setState(() => _hospitalId = null),
                    ),
                    RequestDropdownField<String>(
                      fieldKey: WidgetKeys.requestHospitalField,
                      value: hospitals.any(
                        (hospital) => hospital.id == _hospitalId,
                      )
                          ? _hospitalId
                          : null,
                      hintText: _wilayaSelected
                          ? AppStrings.hospitalNameField.tr()
                          : AppStrings.selectWilayaFirst.tr(),
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
                  isActive: currentRequest.isActive,
                  onChanged: state.status == RequestViewStatus.submitting
                      ? null
                      : (next) async {
                          if (next) {
                            // Re-activate the request (server-side). Ask for
                            // confirmation or call directly depending on policy.
                            context.read<RequestBloc>().add(
                                  RequestReactivateSubmitted(
                                    requestId: widget.request.id,
                                  ),
                                );
                          } else {
                            final reason = await showRequestCancellationDialog(context);
                            if (reason != null && mounted) {
                              context.read<RequestBloc>().add(
                                    RequestCancelSubmitted(
                                      requestId: widget.request.id,
                                      reason: reason,
                                    ),
                                  );
                            }
                          }
                        },
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

  /// True once the field holds a recognised wilaya name.
  bool get _wilayaSelected =>
      algerianWilayas.contains(_wilayaController.text.trim());

  /// Wilaya name for a 1-based wilaya id, or empty when unknown.
  String _wilayaNameFor(int? wilayaId) {
    if (wilayaId == null) return '';
    final index = wilayaId - AppSize.s1.toInt();
    if (index < AppSize.s0 || index >= algerianWilayas.length) return '';
    return algerianWilayas[index];
  }

  /// Hospitals narrowed to the wilaya typed into the Figma `الولاية` field —
  /// a view-level filter over the list the bloc already loaded. Empty until a
  /// wilaya is chosen so the picker never lists every hospital in the country.
  List<HospitalEntity> _visibleHospitals(RequestState state) {
    final index = algerianWilayas.indexOf(_wilayaController.text.trim());
    if (index < AppSize.s0) return const [];
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
    final selected = await showAdaptiveDatePicker(
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
      _hospitalId = widget.request.hospital?.id;
      _bloodType = widget.request.bloodType;
      _priority = widget.request.priority;
      _neededBy = widget.request.neededBy;
      _wilayaController.text = _wilayaNameFor(widget.request.hospital?.wilayaId);
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
    final hospitalId = _hospitalId;
    if (units == null || units <= AppSize.s0 || hospitalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.requiredRequestFields.tr())),
      );
      return;
    }

    context.read<RequestBloc>().add(
      RequestUpdateSubmitted(
        requestId: widget.request.id,
        draft: RequestDraft(
          hospitalId: hospitalId,
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
    final reason = await showRequestCancellationDialog(context);

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
