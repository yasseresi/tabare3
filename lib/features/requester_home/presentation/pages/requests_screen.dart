import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';
import 'edit_request_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.myRequests.tr(),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSize.s8),
                    TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: AppStrings.searchRequests.tr(),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) => _buildContent(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RequestState state) {
    if (state.status == RequestViewStatus.loading ||
        state.status == RequestViewStatus.initial) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }

    if (state.status == RequestViewStatus.failure) {
      return _MessageState(
        icon: Icons.error_outline,
        message: state.errorMessage ?? AppStrings.defaultError.tr(),
        action: ElevatedButton(
          key: WidgetKeys.requestsRetryButton,
          onPressed: () {
            context.read<RequestBloc>().add(const RequestsLoadRequested());
          },
          child: Text(AppStrings.retryAgain.tr()),
        ),
      );
    }

    final query = _searchController.text.trim().toLowerCase();
    final requests = state.requests.where((request) {
      if (query.isEmpty) return true;
      return request.hospital.nameAr.toLowerCase().contains(query) ||
          request.bloodType.toLowerCase().contains(query);
    }).toList();

    if (requests.isEmpty) {
      return _MessageState(
        icon: Icons.bloodtype_outlined,
        message: AppStrings.noRequestsYet.tr(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RequestBloc>().add(const RequestsLoadRequested());
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p20,
          AppPadding.p4,
          AppPadding.p20,
          AppPadding.p100,
        ),
        itemCount: requests.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSize.s16),
        itemBuilder: (context, index) => _RequestCard(request: requests[index]),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BloodRequestEntity request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final progress = request.unitsNeeded <= AppSize.s0
        ? AppSize.s0
        : request.unitsFulfilled / request.unitsNeeded;
    final dateFormat = intl.DateFormat(AppConstants.requestDateFormat);

    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
            blurRadius: AppSize.s20,
            offset: const Offset(AppSize.s0, AppSize.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s50,
                height: AppSize.s50,
                decoration: BoxDecoration(
                  color: ColorManager.surface,
                  borderRadius: BorderRadius.circular(AppSize.radiusLarge),
                ),
                child: Icon(
                  Icons.local_hospital_outlined,
                  color: ColorManager.primary,
                ),
              ),
              const SizedBox(width: AppSize.s12),
              Expanded(
                child: Text(
                  request.hospital.nameAr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _StatusChip(
                label: _priorityLabel(request.priority).tr(),
                color: _priorityColor(request.priority),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s20),
          _InfoRow(label: AppStrings.bloodType.tr(), value: request.bloodType),
          _InfoRow(
            label: AppStrings.requestDate.tr(),
            value: dateFormat.format(request.createdAt.toLocal()),
          ),
          if (request.neededBy != null)
            _InfoRow(
              label: AppStrings.deadline.tr(),
              value: dateFormat.format(request.neededBy!.toLocal()),
            ),
          const SizedBox(height: AppSize.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.bagsProvided.tr(
                  namedArgs: {
                    'provided': request.unitsFulfilled.toString(),
                    'total': request.unitsNeeded.toString(),
                  },
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                AppStrings.bagsRatio.tr(
                  namedArgs: {
                    'provided': request.unitsFulfilled.toString(),
                    'total': request.unitsNeeded.toString(),
                  },
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorManager.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radiusSmall),
            child: LinearProgressIndicator(
              value: progress.clamp(AppSize.s0, AppSize.s1).toDouble(),
              minHeight: AppSize.s8,
              backgroundColor: ColorManager.progressTrack,
              valueColor: AlwaysStoppedAnimation(ColorManager.progressFill),
            ),
          ),
          const SizedBox(height: AppSize.s20),
          ElevatedButton(
            key: WidgetKeys.requestDetailsButton,
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.requestDetailRoute,
                arguments: request,
              );
            },
            child: Text(AppStrings.requestDetails.tr()),
          ),
          if (request.isActive) ...[
            const SizedBox(height: AppSize.s8),
            OutlinedButton(
              key: WidgetKeys.requestEditButton,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<RequestBloc>(),
                      child: EditRequestScreen(request: request),
                    ),
                  ),
                );
              },
              child: Text(AppStrings.editRequest.tr()),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.muted),
        borderRadius: BorderRadius.circular(AppSize.radiusLarge),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: FontSize.s10,
          fontWeight: FontWeightManager.bold,
          color: color,
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? action;

  const _MessageState({required this.icon, required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSize.s76, color: ColorManager.primaryLight),
            const SizedBox(height: AppSize.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSize.s20),
              action!,
            ],
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
  RequestPriority.normal => ColorManager.success,
  RequestPriority.semiUrgent => ColorManager.warning,
  RequestPriority.urgent => ColorManager.error,
};
