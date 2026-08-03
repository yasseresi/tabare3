import 'package:flutter/material.dart';

import '../../utils/values_manager.dart';
import 'app_gradient_background.dart';
import 'app_header.dart';

/// Standard screen shell: the gradient wash, a floating [AppHeader] pinned to
/// the top and a 402px-wide scrolling column beneath it.
///
/// The header overlaps the scroll view exactly as it does in Figma, so
/// [children] start at [AppPadding.pHeaderOffset] from the top of the screen.
class AppPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotifications;
  final Key? notificationsKey;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  const AppPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onNotifications,
    this.notificationsKey,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget list = ListView(
      padding: const EdgeInsets.only(
        top: AppPadding.pHeaderOffset,
        left: AppPadding.p10,
        right: AppPadding.p10,
        bottom: AppPadding.p32,
      ),
      children: children,
    );
    final refresh = onRefresh;
    if (refresh != null) {
      list = RefreshIndicator(onRefresh: refresh, child: list);
    }

    return AppGradientBackground(
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSize.s402),
              child: list,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSize.s402),
              child: AppHeader(
                title: title,
                subtitle: subtitle,
                onNotifications: onNotifications,
                notificationsKey: notificationsKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
