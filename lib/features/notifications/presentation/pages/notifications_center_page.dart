import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/app_empty_state.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/presentation/widgets/app_search_field.dart';
import '../../../../core/presentation/widgets/app_section_header.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';

/// Figma notification centre (donor node 114:258, recipient node 240:1612):
/// search bar, centred `الاشعارات` title and a 10-gap stack of type cards.
class NotificationsCenterPage extends StatefulWidget {
  /// Switches the header subtitle between the donor and recipient copy.
  final bool isDonor;

  const NotificationsCenterPage({super.key, this.isDonor = false});

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
        body: AppGradientBackground(
          child: Column(
            children: [
              AppHeader(
                title: welcomeTitle(),
                subtitle: widget.isDonor
                    ? AppStrings.donationLifeChance.tr()
                    : AppStrings.getWellSoon.tr(),
              ),
              // Figma floats the header and starts the content at y=150;
              // the inline header measures 128.
              const SizedBox(height: AppSize.s22),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p10,
                  ),
                  child: Column(
                    children: [
                      AppSearchField(
                        hintText: AppStrings.searchNotifications.tr(),
                        controller: _searchController,
                        onChanged: (value) => context
                            .read<NotificationsBloc>()
                            .add(NotificationsSearchChanged(value)),
                      ),
                      const SizedBox(height: AppSize.s12),
                      AppSectionHeader(
                        title: AppStrings.notificationsHeader.tr(),
                        centered: true,
                      ),
                      const SizedBox(height: AppSize.s12),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading || state is NotificationsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationsError) {
          return Center(child: Text(state.failure.message));
        }

        final loaded = state as NotificationsLoaded;
        if (loaded.visibleNotifications.isEmpty) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: AppPadding.p60),
              child: AppEmptyState(
                illustration: ImageAssets.emptyNotifications,
                title: AppStrings.noNotifications.tr(),
                message: AppStrings.noNotificationsDescription.tr(),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: AppPadding.p32),
          itemCount: loaded.visibleNotifications.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSize.s10),
          itemBuilder: (context, index) {
            final notification = loaded.visibleNotifications[index];
            return _NotificationCard(
              notification: notification,
              onTap: () => context.read<NotificationsBloc>().add(
                NotificationReadRequested(notification.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard.list(
        padding: const EdgeInsets.all(AppPadding.pNotificationCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _NotificationLeading(type: notification.type),
                const SizedBox(width: AppSize.s5),
                Expanded(
                  child: Text(
                    notification.title,
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      color: ColorManager.cardTitle,
                      lineHeight: LineHeight.h19,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s5),
                SizedBox(
                  width: AppSize.s40,
                  child: Text(
                    _timeAgo(notification.createdAt.toLocal()),
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s10_5,
                      color: ColorManager.primary,
                      lineHeight: LineHeight.h14,
                    ).copyWith(letterSpacing: AppSize.letterSpacingCard),
                  ),
                ),
              ],
            ),
            Text(
              notification.body,
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.textMuted,
              ).copyWith(letterSpacing: AppSize.letterSpacingCard),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime createdAt) {
    final elapsed = DateTime.now().difference(createdAt);
    if (elapsed.inMinutes < 1) return AppStrings.timeAgoNow.tr();
    if (elapsed.inMinutes < Duration.minutesPerHour) {
      return AppStrings.timeAgoMinutes.tr(
        namedArgs: {'count': '${elapsed.inMinutes}'},
      );
    }
    if (elapsed.inHours < 2) return AppStrings.timeAgoHour.tr();
    if (elapsed.inHours < Duration.hoursPerDay) {
      return AppStrings.timeAgoHours.tr(
        namedArgs: {'count': '${elapsed.inHours}'},
      );
    }
    return AppStrings.timeAgoDays.tr(
      namedArgs: {'count': '${elapsed.inDays}'},
    );
  }
}

/// 48x48 slot holding the 40x40 glyph Figma picks per notification type.
class _NotificationLeading extends StatelessWidget {
  final String type;

  const _NotificationLeading({required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s48,
      height: AppSize.s48,
      child: Center(
        child: SvgPicture.asset(
          _assetForType,
          width: AppSize.s40,
          height: AppSize.s40,
        ),
      ),
    );
  }

  String get _assetForType => switch (type) {
    NotificationTypes.thankYou => SvgAssets.notificationThanks,
    NotificationTypes.participationAccepted => SvgAssets.notificationAccepted,
    NotificationTypes.appointmentReminder => SvgAssets.notificationAppointment,
    _ => SvgAssets.notificationBloodBag,
  };
}
