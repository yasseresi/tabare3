import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsCenterPage extends StatefulWidget {
  const NotificationsCenterPage({super.key});

  @override
  State<NotificationsCenterPage> createState() =>
      _NotificationsCenterPageState();
}

class _NotificationsCenterPageState extends State<NotificationsCenterPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(const NotificationsRequested());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p10,
                vertical: AppPadding.p32,
              ),
              child: Column(
                children: [
                  _PageHeader(controller: _searchController),
                  const SizedBox(height: AppSize.s24),
                  Expanded(
                    child: BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state) {
                        if (state is NotificationsLoading ||
                            state is NotificationsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is NotificationsError) {
                          return Center(child: Text(state.failure.message));
                        }

                        final loaded = state as NotificationsLoaded;
                        if (loaded.visibleNotifications.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.noNotifications.tr(),
                              style: TextStyle(
                                fontSize: AppSize.s16,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.textSecondary,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: loaded.visibleNotifications.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSize.s14),
                          itemBuilder: (context, index) {
                            final notification =
                                loaded.visibleNotifications[index];
                            return _NotificationCard(
                              notification: notification,
                              onTap: () {
                                context.read<NotificationsBloc>().add(
                                  NotificationReadRequested(notification.id),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final TextEditingController controller;

  const _PageHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeUser.tr(),
                  style: TextStyle(
                    fontSize: AppSize.s20,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
                Text(
                  AppStrings.getWellSoon.tr(),
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    color: ColorManager.textMuted,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: ColorManager.surfaceAlt,
                borderRadius: BorderRadius.circular(AppSize.radiusCircle),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: ColorManager.primaryDark,
                size: AppSize.s24,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s46),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          onChanged: (value) => context.read<NotificationsBloc>().add(
            NotificationsSearchChanged(value),
          ),
          decoration: InputDecoration(
            hintText: AppStrings.searchNotifications.tr(),
            hintStyle: TextStyle(
              color: ColorManager.lightGrey,
              fontSize: AppSize.s15,
            ),
            suffixIcon: Icon(
              Icons.search,
              color: ColorManager.lightGrey,
              size: AppSize.s26,
            ),
            filled: true,
            fillColor: ColorManager.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
              vertical: AppPadding.p14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
              borderSide: BorderSide(color: ColorManager.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
              borderSide: BorderSide(color: ColorManager.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusButton),
              borderSide: BorderSide(color: ColorManager.primaryDark),
            ),
          ),
        ),
        const SizedBox(height: AppSize.s16),
        Text(
          AppStrings.notificationsHeader.tr(),
          style: const TextStyle(
            fontSize: AppSize.s20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManager.scaffoldBg,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.s28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: notification.isRead
                ? ColorManager.white
                : ColorManager.surfaceWarm,
            borderRadius: BorderRadius.circular(AppSize.s28),
            border: Border.all(color: ColorManager.borderGrey),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: AppOpacity.subtle),
                blurRadius: AppSize.s18,
                offset: const Offset(AppSize.s0, AppSize.s10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationLeading(type: notification.type),
              const SizedBox(width: AppSize.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: AppSize.s17,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.black,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: AppSize.s10,
                            height: AppSize.s10,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSize.s8),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: AppSize.s14,
                        height: AppSize.s1_5,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSize.s12),
                    Text(
                      DateFormat(
                        AppConstants.notificationDateTimeFormat,
                      ).format(notification.createdAt.toLocal()),
                      style: TextStyle(
                        fontSize: AppSize.s12,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationLeading extends StatelessWidget {
  final String type;

  const _NotificationLeading({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == NotificationTypes.thankYou ||
        type == NotificationTypes.participationAccepted) {
      return Container(
        width: AppSize.s40,
        height: AppSize.s40,
        decoration: BoxDecoration(
          color: ColorManager.success,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: ColorManager.white, size: AppSize.s24),
      );
    }

    return SvgPicture.asset(
      SvgAssets.icon8,
      width: AppSize.s40,
      height: AppSize.s40,
    );
  }
}
