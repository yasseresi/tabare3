import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_page.dart';
import '../../../../core/presentation/widgets/app_search_field.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import '../widgets/requester_request_card.dart';

class RequestsScreen extends StatefulWidget {
  final VoidCallback? onNotifications;
  final ValueChanged<BloodRequestEntity>? onEdit;
  final ValueChanged<BloodRequestEntity>? onDetail;

  const RequestsScreen({
    super.key,
    this.onNotifications,
    this.onEdit,
    this.onDetail,
  });

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state.status == RequestViewStatus.loading ||
              state.status == RequestViewStatus.initial) {
            return AppGradientBackground(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            );
          }
          if (state.status == RequestViewStatus.failure) {
            return AppGradientBackground(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? AppStrings.defaultError.tr()),
                    const SizedBox(height: AppSize.s12),
                    ElevatedButton(
                      key: WidgetKeys.requestsRetryButton,
                      onPressed: () {
                        context.read<RequestBloc>().add(
                          const RequestsLoadRequested(),
                        );
                      },
                      child: Text(AppStrings.retryAgain.tr()),
                    ),
                  ],
                ),
              ),
            );
          }
          final requests = _filter(state.requests);
          return AppPage(
            title: welcomeTitle(),
            subtitle: AppStrings.getWellSoon.tr(),
            onNotifications: widget.onNotifications,
            onRefresh: () async {
              context.read<RequestBloc>().add(const RequestsLoadRequested());
            },
            children: [
              AppSearchField(
                hintText: AppStrings.searchRequests.tr(),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSize.s12),
              if (requests.isEmpty)
                AppEmptyState(
                  title: AppStrings.noRequestsNow.tr(),
                  message: AppStrings.noRequestsDescription.tr(),
                )
              else
                ...requests.map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p15),
                    child: RequesterRequestCard(
                      request: request,
                      ownerName: currentUserFullName(),
                      viewDonorsKey: WidgetKeys.requestDetailsButton,
                      editKey: WidgetKeys.requestEditButton,
                      onViewDonors: () => _openDetail(context, request),
                      onEdit: request.isActive
                          ? () => _editRequest(context, request)
                          : null,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<BloodRequestEntity> _filter(List<BloodRequestEntity> requests) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return requests;
    return requests
        .where(
          (request) =>
              request.hospital.nameAr.toLowerCase().contains(query) ||
              request.bloodType.toLowerCase().contains(query) ||
              (request.patient?.fullName.toLowerCase().contains(query) ??
                  false),
        )
        .toList();
  }

  void _openDetail(BuildContext context, BloodRequestEntity request) {
    if (widget.onDetail != null) {
      widget.onDetail!(request);
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.requestDetailRoute,
      arguments: request,
    );
  }

  void _editRequest(BuildContext context, BloodRequestEntity request) {
    if (widget.onEdit != null) {
      widget.onEdit!(request);
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.editRequestRoute,
      arguments: request,
    );
  }
}
