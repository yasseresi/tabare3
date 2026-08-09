import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/app_info_row.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_pill_button.dart';
import '../../../../core/presentation/widgets/app_progress_bar.dart';
import '../../../../core/presentation/widgets/app_tag_pill.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_detail_bloc.dart';

class RequestDetailScreen extends StatefulWidget {
  final BloodRequestEntity request;
  final VoidCallback? onNotifications;

  const RequestDetailScreen({
    super.key,
    required this.request,
    this.onNotifications,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestDetailBloc>().add(_loadEvent());
  }

  RequestDetailLoadRequested _loadEvent() => RequestDetailLoadRequested(
    requestId: widget.request.id,
    includeCompatibleDonors:
        widget.request.priority == RequestPriority.urgent &&
        widget.request.isActive,
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<RequestDetailBloc, RequestDetailState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        builder: (context, state) => Scaffold(
          backgroundColor: ColorManager.transparent,
          body: AppPage(
            title: welcomeTitle(),
            subtitle: AppStrings.getWellSoon.tr(),
            notificationsKey: WidgetKeys.requesterNotificationsButton,
            onNotifications: widget.onNotifications,
            onRefresh: () async {
              context.read<RequestDetailBloc>().add(_loadEvent());
            },
            children: [
              Text(
                AppStrings.requestDetails.tr(),
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.sectionTitle,
                  lineHeight: LineHeight.h28,
                ),
              ),
              const SizedBox(height: AppSize.s12),
              _RequestSummaryCard(request: widget.request),
              const SizedBox(height: AppSize.s12),
              _BeneficiarySection(request: widget.request),
              const SizedBox(height: AppSize.s12),
              _QrSection(request: widget.request, state: state),
              const SizedBox(height: AppSize.s12),
              _DonorSection(state: state),
              if (widget.request.priority == RequestPriority.urgent &&
                  widget.request.isActive) ...[
                const SizedBox(height: AppSize.s12),
                _InvitationSection(state: state),
                const SizedBox(height: AppSize.s12),
                _CompatibleDonorSection(
                  requestId: widget.request.id,
                  state: state,
                ),
              ],
              if (state.status == RequestDetailStatus.loading) ...[
                const SizedBox(height: AppSize.s20),
                Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestSummaryCard extends StatelessWidget {
  final BloodRequestEntity request;

  const _RequestSummaryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            request.hospital.nameAr,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.cardTitle,
            ),
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.bloodType.tr(),
            value: request.bloodType,
          ),
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.bagsProvided.tr(
              namedArgs: {
                'provided': request.unitsFulfilled.toString(),
                'total': request.unitsNeeded.toString(),
              },
            ),
            value: AppStrings.bagsRatio.tr(
              namedArgs: {
                'provided': request.unitsFulfilled.toString(),
                'total': request.unitsNeeded.toString(),
              },
            ),
          ),
          const SizedBox(height: AppSize.s10),
          AppProgressBar(
            value: request.unitsNeeded == AppSize.s0
                ? AppSize.s0
                : request.unitsFulfilled / request.unitsNeeded,
          ),
        ],
      ),
    );
  }
}

class _BeneficiarySection extends StatelessWidget {
  final BloodRequestEntity request;

  const _BeneficiarySection({required this.request});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: request.isForSomeoneElse
          ? AppStrings.forSomeoneElse.tr()
          : AppStrings.requestForSelf.tr(),
      child: request.isForSomeoneElse
          ? _buildPatientDetails()
          : Text(
              AppStrings.requestForSelf.tr(),
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textSecondary,
              ),
            ),
    );
  }

  Widget _buildPatientDetails() {
    final patient = request.patient;
    if (patient == null) {
      return Text(
        AppStrings.patientDetailsRequired.tr(),
        textAlign: TextAlign.center,
        style: getRegularStyle(
          fontSize: FontSize.s14,
          color: ColorManager.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInfoRow(label: AppStrings.fullName.tr(), value: patient.fullName),
        const SizedBox(height: AppSize.s18),
        AppInfoRow(
          label: AppStrings.nationalId.tr(),
          value: patient.nationalId,
        ),
        const SizedBox(height: AppSize.s18),
        AppInfoRow(label: AppStrings.bloodType.tr(), value: patient.bloodType),
        const SizedBox(height: AppSize.s18),
        AppInfoRow(label: AppStrings.gender.tr(), value: patient.gender),
        const SizedBox(height: AppSize.s18),
        AppInfoRow(
          label: AppStrings.weight.tr(),
          value: '${patient.weight.toStringAsFixed(0)} ${AppStrings.kg.tr()}',
        ),
        const SizedBox(height: AppSize.s18),
        AppInfoRow(
          label: AppStrings.dateOfBirth.tr(),
          value: patient.dateOfBirth,
        ),
        if (patient.chronicDiseases != null &&
            patient.chronicDiseases!.isNotEmpty) ...[
          const SizedBox(height: AppSize.s18),
          AppInfoRow(
            label: AppStrings.chronicDiseases.tr(),
            value: patient.chronicDiseases!,
          ),
        ],
      ],
    );
  }
}

class _QrSection extends StatelessWidget {
  final BloodRequestEntity request;
  final RequestDetailState state;

  const _QrSection({required this.request, required this.state});

  @override
  Widget build(BuildContext context) {
    final qr = state.issuedQr;
    return AppCard(
      child: Column(
        children: [
          Text(
            AppStrings.requestQrTitle.tr(),
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.sectionTitle,
              lineHeight: LineHeight.h28,
            ),
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            AppStrings.requestQrDescription.tr(),
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSize.s14,
              color: ColorManager.textMuted,
            ),
          ),
          if (qr != null) ...[
            const SizedBox(height: AppSize.s20),
            QrImageView(
              key: WidgetKeys.requestQrView,
              data: qr.token,
              version: QrVersions.auto,
              size: AppSize.s220,
              backgroundColor: ColorManager.white,
              eyeStyle: QrEyeStyle(color: ColorManager.primaryDark),
              dataModuleStyle: QrDataModuleStyle(color: ColorManager.nearBlack),
            ),
            const SizedBox(height: AppSize.s10),
            Text(
              AppStrings.qrExpiresAt.tr(
                namedArgs: {
                  'time': intl.DateFormat(
                    AppConstants.requestTimeFormat,
                  ).format(qr.expiresAt.toLocal()),
                },
              ),
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.textMuted,
              ),
            ),
          ],
          const SizedBox(height: AppSize.s18),
          AppPillButton(
            buttonKey: WidgetKeys.requestQrIssueButton,
            label: (qr == null
                    ? AppStrings.generateRequestQr
                    : AppStrings.refreshRequestQr)
                .tr(),
            background: ColorManager.primary,
            onPressed:
                !request.isActive ||
                    state.status == RequestDetailStatus.actionLoading
                ? null
                : () {
                    context.read<RequestDetailBloc>().add(
                      RequestQrIssueRequested(requestId: request.id),
                    );
                  },
          ),
        ],
      ),
    );
  }
}

class _DonorSection extends StatelessWidget {
  final RequestDetailState state;

  const _DonorSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: AppStrings.acceptedDonors.tr(),
      child: state.donors.isEmpty
          ? _EmptySectionMessage(message: AppStrings.noAcceptedDonors.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.donors
                  .map(
                    (donor) => Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p18),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInfoRow(
                              label: donor.fullName,
                              value: donor.bloodType,
                            ),
                          ),
                          const SizedBox(width: AppSize.s12),
                          AppTagPill(
                            label: _appointmentStatus(donor.status).tr(),
                            labelColor: ColorManager.textMuted,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _InvitationSection extends StatelessWidget {
  final RequestDetailState state;

  const _InvitationSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: AppStrings.sentInvitations.tr(),
      child: state.invitations.isEmpty
          ? _EmptySectionMessage(message: AppStrings.noSentInvitations.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.invitations
                  .map(
                    (invitation) => Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p18),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInfoRow(
                              label: invitation.fullName,
                              value: invitation.bloodType,
                            ),
                          ),
                          const SizedBox(width: AppSize.s12),
                          AppTagPill(
                            label: _invitationStatus(invitation.status).tr(),
                            labelColor: ColorManager.textMuted,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _CompatibleDonorSection extends StatelessWidget {
  final String requestId;
  final RequestDetailState state;

  const _CompatibleDonorSection({required this.requestId, required this.state});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: AppStrings.availableDonors.tr(),
      child: state.compatibleDonors.isEmpty
          ? _EmptySectionMessage(message: AppStrings.noCompatibleDonors.tr())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.compatibleDonors
                  .map(
                    (donor) => Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppInfoRow(
                            label: donor.fullName,
                            value: donor.bloodType,
                          ),
                          const SizedBox(height: AppSize.s10),
                          AppPillButton(
                            buttonKey: WidgetKeys.compatibleDonorInviteButton,
                            label: AppStrings.inviteDonor.tr(),
                            background: ColorManager.primary,
                            onPressed:
                                state.status ==
                                    RequestDetailStatus.actionLoading
                                ? null
                                : () {
                                    context.read<RequestDetailBloc>().add(
                                      CompatibleDonorInviteRequested(
                                        requestId: requestId,
                                        donorId: donor.donorId,
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: getSemiBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.sectionTitle,
              lineHeight: LineHeight.h28,
            ),
          ),
          const SizedBox(height: AppSize.s18),
          child,
        ],
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  final String message;

  const _EmptySectionMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: getRegularStyle(
        fontSize: FontSize.s14,
        color: ColorManager.textMuted,
      ),
    );
  }
}

String _appointmentStatus(DonationAppointmentStatus status) => switch (status) {
  DonationAppointmentStatus.pending => AppStrings.pending,
  DonationAppointmentStatus.confirmed => AppStrings.activeStatus,
  DonationAppointmentStatus.completed => AppStrings.completed,
  DonationAppointmentStatus.cancelled => AppStrings.cancelled,
};

String _invitationStatus(DirectInvitationStatus status) => switch (status) {
  DirectInvitationStatus.sent => AppStrings.invitationSent,
  DirectInvitationStatus.accepted => AppStrings.accepted,
  DirectInvitationStatus.rejected => AppStrings.invitationRejected,
  DirectInvitationStatus.expired => AppStrings.invitationExpired,
  DirectInvitationStatus.cancelled => AppStrings.cancelled,
};
