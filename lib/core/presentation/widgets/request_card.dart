import 'package:flutter/material.dart';

import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/font_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';
import 'app_card.dart';
import 'app_info_row.dart';
import 'app_progress_bar.dart';
import 'app_tag_pill.dart';

/// A single label/value line rendered inside a [RequestCard].
class RequestCardDetail {
  final String label;
  final String value;
  final Color? valueColor;

  const RequestCardDetail({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

/// The blood-request list card shared by the donor feed, the recipient's
/// request list and the appointment/record screens: patient illustration and
/// name, an urgency chip, a stack of detail rows, a fulfilment bar and a
/// trailing action button.
class RequestCard extends StatelessWidget {
  final String title;
  final String? urgencyLabel;
  final Color? urgencyColor;
  final List<RequestCardDetail> details;
  final double? progress;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? actionColor;
  final Key? actionKey;
  final Widget? footer;

  const RequestCard({
    super.key,
    required this.title,
    this.urgencyLabel,
    this.urgencyColor,
    this.details = const [],
    this.progress,
    this.actionLabel,
    this.onAction,
    this.actionColor,
    this.actionKey,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.list(
      child: Column(
        children: [
          _TitleRow(
            title: title,
            urgencyLabel: urgencyLabel,
            urgencyColor: urgencyColor,
          ),
          for (final detail in details) ...[
            const SizedBox(height: AppSize.s18),
            AppInfoRow(
              label: detail.label,
              value: detail.value,
              valueColor: detail.valueColor,
            ),
          ],
          if (progress != null) ...[
            const SizedBox(height: AppSize.s18),
            AppProgressBar(value: progress!),
          ],
          if (footer != null) ...[
            const SizedBox(height: AppSize.s18),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final String? urgencyLabel;
  final Color? urgencyColor;

  const _TitleRow({
    required this.title,
    this.urgencyLabel,
    this.urgencyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          ImageAssets.requestAvatar,
          width: AppSize.s50,
          height: AppSize.s50,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: AppSize.s16),
        Expanded(
          child: Text(
            title,
            style: getBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.cardTitle,
              lineHeight: LineHeight.h19,
            ),
          ),
        ),
        if (urgencyLabel != null) ...[
          const SizedBox(width: AppSize.s16),
          AppTagPill(
            label: urgencyLabel!,
            dotColor: urgencyColor,
            labelColor: ColorManager.navInactive,
          ),
        ],
      ],
    );
  }
}
