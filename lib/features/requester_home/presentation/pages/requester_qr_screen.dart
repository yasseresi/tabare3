import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/presentation/widgets/qr_page_body.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../bloc/request_detail_bloc.dart';

/// Full-screen `رمز QR` page for the recipient: issues a QR for their active
/// request so a donor can scan it to confirm the donation.
class RequesterQrScreen extends StatefulWidget {
  final BloodRequestEntity? request;
  final VoidCallback? onNotifications;

  const RequesterQrScreen({super.key, this.request, this.onNotifications});

  @override
  State<RequesterQrScreen> createState() => _RequesterQrScreenState();
}

class _RequesterQrScreenState extends State<RequesterQrScreen> {
  @override
  void initState() {
    super.initState();
    final request = widget.request;
    if (request != null) {
      context.read<RequestDetailBloc>().add(
        RequestQrIssueRequested(requestId: request.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppGradientBackground(
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSize.s402),
                child: Column(
                  children: [
                    AppHeader(
                      title: AppStrings.welcomeUser.tr(),
                      subtitle: AppStrings.getWellSoon.tr(),
                      onNotifications: widget.onNotifications,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p10,
                        ),
                        child: QrPageBody(
                          description: AppStrings.showQrDescription.tr(),
                          square: BlocBuilder<
                            RequestDetailBloc,
                            RequestDetailState
                          >(
                            builder: (context, state) =>
                                _buildSquare(context, state),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSquare(BuildContext context, RequestDetailState state) {
    if (widget.request == null) {
      return _Message(text: AppStrings.noRequestsYet.tr());
    }
    final qr = state.issuedQr;
    if (qr == null) {
      if (state.status == RequestDetailStatus.failure) {
        return _Message(
          text: state.errorMessage ?? AppStrings.defaultError.tr(),
        );
      }
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }
    return Center(
      child: QrImageView(
        key: WidgetKeys.requestQrView,
        data: qr.token,
        version: QrVersions.auto,
        size: AppSize.s320,
        backgroundColor: ColorManager.transparent,
        eyeStyle: QrEyeStyle(color: ColorManager.black),
        dataModuleStyle: QrDataModuleStyle(color: ColorManager.black),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;

  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: getMediumStyle(
          fontSize: FontSize.s16,
          color: ColorManager.textMuted,
        ),
      ),
    );
  }
}
