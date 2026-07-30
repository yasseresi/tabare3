import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_detail_bloc.dart';

class RequestDetailScreen extends StatefulWidget {
  final BloodRequestEntity request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestDetailBloc>().add(
      RequestDetailLoadRequested(
        requestId: widget.request.id,
        includeCompatibleDonors:
            widget.request.priority == RequestPriority.urgent &&
            widget.request.isActive,
      ),
    );
  }

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
          appBar: AppBar(title: Text(AppStrings.requestDetails.tr())),
          body: SafeArea(
            child: state.status == RequestDetailStatus.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      context.read<RequestDetailBloc>().add(
                        RequestDetailLoadRequested(
                          requestId: widget.request.id,
                          includeCompatibleDonors:
                              widget.request.priority ==
                                  RequestPriority.urgent &&
                              widget.request.isActive,
                        ),
                      );
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(AppPadding.p20),
                      children: [
                        _RequestSummaryCard(request: widget.request),
                        const SizedBox(height: AppSize.s24),
                        _QrSection(request: widget.request, state: state),
                        const SizedBox(height: AppSize.s24),
                        _DonorSection(state: state),
                        if (widget.request.priority == RequestPriority.urgent &&
                            widget.request.isActive) ...[
                          const SizedBox(height: AppSize.s24),
                          _InvitationSection(state: state),
                          const SizedBox(height: AppSize.s24),
                          _CompatibleDonorSection(
                            requestId: widget.request.id,
                            state: state,
                          ),
                        ],
                      ],
                    ),
                  ),
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
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            request.hospital.nameAr,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSize.s16),
          _DetailRow(
            label: AppStrings.bloodType.tr(),
            value: request.bloodType,
          ),
          _DetailRow(
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
          const SizedBox(height: AppSize.s8),
          LinearProgressIndicator(
            value: request.unitsFulfilled / request.unitsNeeded,
            minHeight: AppSize.s8,
            backgroundColor: ColorManager.progressTrack,
            valueColor: AlwaysStoppedAnimation(ColorManager.progressFill),
            borderRadius: BorderRadius.circular(AppSize.radiusSmall),
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            AppStrings.requestQrTitle.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            AppStrings.requestQrDescription.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: ColorManager.textMuted),
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
            const SizedBox(height: AppSize.s8),
            Text(
              AppStrings.qrExpiresAt.tr(
                namedArgs: {
                  'time': intl.DateFormat(
                    AppConstants.requestTimeFormat,
                  ).format(qr.expiresAt.toLocal()),
                },
              ),
            ),
          ],
          const SizedBox(height: AppSize.s16),
          ElevatedButton(
            key: WidgetKeys.requestQrIssueButton,
            onPressed:
                !request.isActive ||
                    state.status == RequestDetailStatus.actionLoading
                ? null
                : () {
                    context.read<RequestDetailBloc>().add(
                      RequestQrIssueRequested(requestId: request.id),
                    );
                  },
            child: Text(
              (qr == null
                      ? AppStrings.generateRequestQr
                      : AppStrings.refreshRequestQr)
                  .tr(),
            ),
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
          ? Text(AppStrings.noAcceptedDonors.tr(), textAlign: TextAlign.center)
          : Column(
              children: state.donors
                  .map(
                    (donor) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: ColorManager.primaryLight,
                        child: Icon(
                          Icons.bloodtype_outlined,
                          color: ColorManager.primaryDark,
                        ),
                      ),
                      title: Text(donor.fullName),
                      subtitle: Text(donor.bloodType),
                      trailing: Text(_appointmentStatus(donor.status).tr()),
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
          ? Text(AppStrings.noSentInvitations.tr(), textAlign: TextAlign.center)
          : Column(
              children: state.invitations
                  .map(
                    (invitation) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(invitation.fullName),
                      subtitle: Text(invitation.bloodType),
                      trailing: Text(_invitationStatus(invitation.status).tr()),
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
          ? Text(
              AppStrings.noCompatibleDonors.tr(),
              textAlign: TextAlign.center,
            )
          : Column(
              children: state.compatibleDonors
                  .map(
                    (donor) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(donor.fullName),
                      subtitle: Text(donor.bloodType),
                      trailing: ElevatedButton(
                        key: WidgetKeys.compatibleDonorInviteButton,
                        onPressed:
                            state.status == RequestDetailStatus.actionLoading
                            ? null
                            : () {
                                context.read<RequestDetailBloc>().add(
                                  CompatibleDonorInviteRequested(
                                    requestId: requestId,
                                    donorId: donor.donorId,
                                  ),
                                );
                              },
                        child: Text(AppStrings.inviteDonor.tr()),
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
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSize.s16),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: ColorManager.primaryDark),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: ColorManager.white,
  borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
  border: Border.all(color: ColorManager.borderGrey),
  boxShadow: [
    BoxShadow(
      color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
      blurRadius: AppSize.s20,
      offset: const Offset(AppSize.s0, AppSize.s10),
    ),
  ],
);

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
