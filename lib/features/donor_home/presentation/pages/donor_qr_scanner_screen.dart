import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/widget_keys.dart';
import '../../../../core/presentation/widgets/app_bottom_nav.dart';
import '../../../../core/presentation/widgets/app_gradient_background.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/presentation/widgets/qr_page_body.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';

typedef DonorScannerBuilder = Widget Function(ValueChanged<String> onScanned);

enum DonorScannerDestination {
  home,
  requests,
  appointments,
  record,
  profile,
  notifications,
}

class DonorQrScannerScreen extends StatefulWidget {
  final DonorScannerBuilder? scannerBuilder;
  final ValueChanged<DonorScannerDestination>? onNavigate;

  const DonorQrScannerScreen({super.key, this.scannerBuilder, this.onNavigate});

  @override
  State<DonorQrScannerScreen> createState() => _DonorQrScannerScreenState();
}

class _DonorQrScannerScreenState extends State<DonorQrScannerScreen> {
  MobileScannerController? _controller;
  bool _handled = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanner =
        widget.scannerBuilder?.call(_finish) ??
        MobileScanner(controller: _controller, onDetect: _onDetect);
    return Directionality(
      textDirection: TextDirection.rtl,
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
                      title: AppStrings.welcomeUser.tr(),
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
                              IgnorePointer(
                                child: SvgPicture.asset(
                                  SvgAssets.qrScanFrame,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
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

  Future<void> _onDetect(BarcodeCapture capture) async {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        final controller = _controller;
        if (controller != null) await controller.stop();
        _finish(value);
        return;
      }
    }
  }

  void _finish(String token) {
    if (_handled || !mounted) return;
    _handled = true;
    Navigator.pop(context, token);
  }

  void _navigate(DonorScannerDestination destination) {
    widget.onNavigate?.call(destination);
    Navigator.maybePop(context);
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
