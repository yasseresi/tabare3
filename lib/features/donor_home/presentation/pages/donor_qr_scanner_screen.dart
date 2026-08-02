import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/widget_keys.dart';
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSize.s402),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppPadding.p32,
                        AppPadding.p32,
                        AppPadding.p32,
                        AppPadding.p20,
                      ),
                      child: _ScannerHeader(
                        onNotifications: () =>
                            _navigate(DonorScannerDestination.notifications),
                      ),
                    ),
                    Text(
                      AppStrings.scanQrTitle.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppSize.s24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSize.s10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p10,
                      ),
                      child: Text(
                        AppStrings.scanQrDescription.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorManager.textMuted,
                          fontSize: AppSize.s20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.s40),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final scanSize = math.min(
                            constraints.maxWidth - AppPadding.p20,
                            constraints.maxHeight,
                          );
                          return Center(
                            child: SizedBox(
                              width: scanSize,
                              height: scanSize,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppSize.radiusXXLarge,
                                    ),
                                    child: scanner,
                                  ),
                                  IgnorePointer(
                                    child: CustomPaint(
                                      painter: _QrScanFramePainter(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

class _ScannerHeader extends StatelessWidget {
  const _ScannerHeader({required this.onNotifications});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeUser.tr(),
                style: const TextStyle(
                  fontSize: AppSize.s18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                AppStrings.donationLifeChance.tr(),
                style: TextStyle(
                  color: ColorManager.textMuted,
                  fontSize: AppSize.s14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotifications,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(AppPadding.p8),
            backgroundColor: ColorManager.surfaceAlt,
            shape: const CircleBorder(),
          ),
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.notifications_none_rounded, size: AppSize.s24),
        ),
      ],
    );
  }
}

class _ScannerNavigation extends StatelessWidget {
  const _ScannerNavigation({required this.onNavigate});

  final ValueChanged<DonorScannerDestination> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s80,
      child: ColoredBox(
        color: ColorManager.white,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ScannerNavigationItem(
                navKey: WidgetKeys.donorNavigationHome,
                asset: SvgAssets.icon1,
                destination: DonorScannerDestination.home,
                onNavigate: onNavigate,
              ),
              _ScannerNavigationItem(
                asset: SvgAssets.icon2,
                destination: DonorScannerDestination.requests,
                onNavigate: onNavigate,
              ),
              _ScannerNavigationItem(
                navKey: WidgetKeys.donorNavigationAppointments,
                asset: SvgAssets.icon3,
                destination: DonorScannerDestination.appointments,
                onNavigate: onNavigate,
              ),
              _ScannerNavigationItem(
                asset: SvgAssets.icon4,
                destination: DonorScannerDestination.record,
                onNavigate: onNavigate,
              ),
              _ScannerNavigationItem(
                navKey: WidgetKeys.donorNavigationProfile,
                asset: SvgAssets.icon5,
                destination: DonorScannerDestination.profile,
                onNavigate: onNavigate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerNavigationItem extends StatelessWidget {
  const _ScannerNavigationItem({
    this.navKey,
    required this.asset,
    required this.destination,
    required this.onNavigate,
  });

  final Key? navKey;
  final String asset;
  final DonorScannerDestination destination;
  final ValueChanged<DonorScannerDestination> onNavigate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: navKey,
      onPressed: () => onNavigate(destination),
      style: IconButton.styleFrom(backgroundColor: ColorManager.transparent),
      icon: SvgPicture.asset(
        asset,
        width: AppSize.s35,
        height: AppSize.s35,
        colorFilter: ColorFilter.mode(ColorManager.mediumGrey, BlendMode.srcIn),
      ),
    );
  }
}

class _QrScanFramePainter extends CustomPainter {
  final Color color;

  const _QrScanFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppSize.s30
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final inset = AppSize.s52;
    final corner = AppSize.s52;
    final right = size.width - inset;
    final bottom = size.height - inset;
    final center = size.height / AppSize.s2;

    canvas.drawLine(Offset(inset, inset + corner), Offset(inset, inset), paint);
    canvas.drawLine(Offset(inset, inset), Offset(inset + corner, inset), paint);
    canvas.drawLine(Offset(right - corner, inset), Offset(right, inset), paint);
    canvas.drawLine(Offset(right, inset), Offset(right, inset + corner), paint);
    canvas.drawLine(
      Offset(inset, bottom - corner),
      Offset(inset, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(inset, bottom),
      Offset(inset + corner, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(right - corner, bottom),
      Offset(right, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(right, bottom - corner),
      Offset(right, bottom),
      paint,
    );
    canvas.drawLine(Offset(inset, center), Offset(right, center), paint);
  }

  @override
  bool shouldRepaint(covariant _QrScanFramePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
