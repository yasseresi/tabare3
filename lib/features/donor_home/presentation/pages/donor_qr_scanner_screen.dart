import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_bottom_nav.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/presentation/widgets/qr_page_body.dart';
import '../../../../core/presentation/widgets/qr_scanner_overlay.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../bloc/donor_feed_bloc.dart';

typedef DonorScannerBuilder = Widget Function(ValueChanged<String> onScanned);

enum DonorScannerDestination {
  home,
  requests,
  appointments,
  record,
  profile,
  notifications,
}

/// Scan-first donor redemption: the camera opens immediately, a detected (or
/// manually entered) token is redeemed through [DonorFeedBloc] with the backend
/// inferring request vs campaign, and the screen closes itself on success.
class DonorQrScannerScreen extends StatefulWidget {
  final DonorScannerBuilder? scannerBuilder;
  final ValueChanged<DonorScannerDestination>? onNavigate;

  const DonorQrScannerScreen({super.key, this.scannerBuilder, this.onNavigate});

  @override
  State<DonorQrScannerScreen> createState() => _DonorQrScannerScreenState();
}

class _DonorQrScannerScreenState extends State<DonorQrScannerScreen> {
  MobileScannerController? _controller;
  final TextEditingController _manualController = TextEditingController();
  bool _submitting = false;
  bool _manualOpen = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.scannerBuilder == null) {
      _controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) unawaited(controller.dispose());
    _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanner =
        widget.scannerBuilder?.call(_redeem) ??
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error) => _CameraUnavailable(),
        );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<DonorFeedBloc, DonorFeedState>(
        listenWhen: (previous, current) =>
            (current is DonorFeedLoaded &&
                current.lastMutation == DonorFeedMutation.donationRecorded) ||
            current is DonorFeedError,
        listener: _onFeedState,
        child: Scaffold(
          backgroundColor: ColorManager.transparent,
          bottomNavigationBar: _ScannerNavigation(onNavigate: _navigate),
          body: AppGradientBackground(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSize.s402),
                  child: Column(
                    children: [
                      AppHeader(
                        title: welcomeTitle(),
                        subtitle: AppStrings.donationLifeChance.tr(),
                        notificationsKey: WidgetKeys.donorNotificationsButton,
                        onNotifications: () =>
                            _navigate(DonorScannerDestination.notifications),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p10,
                          ),
                          child: QrPageBody(
                            description: AppStrings.scanQrToComplete.tr(),
                            square: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSize.radiusXXLarge,
                                  ),
                                  child: scanner,
                                ),
                                QrScannerOverlay(
                                  animate: widget.scannerBuilder == null,
                                ),
                                if (_submitting)
                                  Center(
                                    child: CircularProgressIndicator(
                                      key: WidgetKeys.donorScannerProgress,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _ScannerFooter(
                        errorMessage: _errorMessage,
                        manualOpen: _manualOpen,
                        controller: _manualController,
                        submitting: _submitting,
                        onManualToggle: () =>
                            setState(() => _manualOpen = true),
                        onManualSubmit: () => _redeem(_manualController.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        final controller = _controller;
        if (controller != null) await controller.stop();
        _redeem(value);
        return;
      }
    }
  }

  void _redeem(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty || _submitting || !mounted) return;
    // The bloc only accepts a redemption from a settled loaded feed; if it is
    // still loading or in error the event would be dropped, leaving the scanner
    // spinning forever. Surface a retry message and keep scanning instead.
    final state = context.read<DonorFeedBloc>().state;
    if (state is! DonorFeedLoaded || state.isMutating) {
      setState(() => _errorMessage = AppStrings.defaultError.tr());
      unawaited(_controller?.start());
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    context.read<DonorFeedBloc>().add(DonorQrRedeemed(trimmed));
  }

  void _onFeedState(BuildContext context, DonorFeedState state) {
    if (state is DonorFeedLoaded &&
        state.lastMutation == DonorFeedMutation.donationRecorded) {
      Navigator.of(context).maybePop();
      return;
    }
    if (state is DonorFeedError) {
      // The failure already carries a localized message (mapped from the
      // redeem RPC's P0001 code in SupabaseErrorMapper).
      setState(() {
        _submitting = false;
        _errorMessage = state.failure.message.isNotEmpty
            ? state.failure.message
            : AppStrings.defaultError.tr();
      });
      unawaited(_controller?.start());
    }
  }

  void _navigate(DonorScannerDestination destination) {
    widget.onNavigate?.call(destination);
    Navigator.maybePop(context);
  }
}

class _ScannerFooter extends StatelessWidget {
  const _ScannerFooter({
    required this.errorMessage,
    required this.manualOpen,
    required this.controller,
    required this.submitting,
    required this.onManualToggle,
    required this.onManualSubmit,
  });

  final String? errorMessage;
  final bool manualOpen;
  final TextEditingController controller;
  final bool submitting;
  final VoidCallback onManualToggle;
  final VoidCallback onManualSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSize.s12),
              child: Text(
                errorMessage!,
                key: WidgetKeys.donorScannerError,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.error,
                ),
              ),
            ),
          if (!manualOpen)
            TextButton(
              key: WidgetKeys.donorScannerManualToggle,
              onPressed: onManualToggle,
              child: Text(AppStrings.enterCodeManually.tr()),
            )
          else ...[
            TextField(
              key: WidgetKeys.donorScannerManualField,
              controller: controller,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: AppStrings.requestQrToken.tr(),
              ),
            ),
            const SizedBox(height: AppSize.s12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: WidgetKeys.donorScannerManualSubmit,
                onPressed: submitting ? null : onManualSubmit,
                child: Text(AppStrings.redeemQr.tr()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CameraUnavailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Text(
            AppStrings.cameraDenied.tr(),
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontSize: FontSize.s16,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerNavigation extends StatelessWidget {
  const _ScannerNavigation({required this.onNavigate});

  final ValueChanged<DonorScannerDestination> onNavigate;

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(
      items: [
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationHome,
          asset: SvgAssets.navHome,
          selected: false,
          onTap: () => onNavigate(DonorScannerDestination.home),
        ),
        AppBottomNavItem(
          asset: SvgAssets.navRequests,
          selected: false,
          onTap: () => onNavigate(DonorScannerDestination.requests),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationAppointments,
          asset: SvgAssets.navCalendar,
          selected: false,
          onTap: () => onNavigate(DonorScannerDestination.appointments),
        ),
        AppBottomNavItem(
          asset: SvgAssets.navHistory,
          selected: false,
          onTap: () => onNavigate(DonorScannerDestination.record),
        ),
        AppBottomNavItem(
          itemKey: WidgetKeys.donorNavigationProfile,
          asset: SvgAssets.navPerson,
          selected: false,
          onTap: () => onNavigate(DonorScannerDestination.profile),
        ),
      ],
    );
  }
}
