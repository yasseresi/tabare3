import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/route_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_bloc.dart';

class DonorHistoryScreen extends StatelessWidget {
  const DonorHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            if (state.status == RequestViewStatus.initial ||
                state.status == RequestViewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == RequestViewStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? AppStrings.error.tr()),
              );
            }
            if (state.requests.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.noRequestsYet.tr(),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppPadding.p20),
              itemCount: state.requests.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSize.s16),
              itemBuilder: (context, index) {
                return _DonorRequestCard(request: state.requests[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _DonorRequestCard extends StatelessWidget {
  final BloodRequestEntity request;

  const _DonorRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppSize.radiusXXLarge),
        border: Border.all(color: ColorManager.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            request.hospital.nameAr,
            style: const TextStyle(
              fontSize: AppSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          _InfoRow(label: AppStrings.bloodType.tr(), value: request.bloodType),
          _InfoRow(
            label: AppStrings.bagsRatio.tr(
              namedArgs: {
                LocalizationArgs.provided: request.unitsFulfilled.toString(),
                LocalizationArgs.total: request.unitsNeeded.toString(),
              },
            ),
            value: request.status == BloodRequestStatus.fulfilled
                ? AppStrings.doneStatus.tr()
                : AppStrings.activeStatus.tr(),
          ),
          const SizedBox(height: AppSize.s16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.requestDetailRoute,
                arguments: request,
              );
            },
            child: Text(AppStrings.requestDetails.tr()),
          ),
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
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: ColorManager.textMuted)),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorManager.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
