import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/values_manager.dart';

typedef DonorScannerBuilder = Widget Function(ValueChanged<String> onScanned);

class DonorQrScannerScreen extends StatefulWidget {
  final DonorScannerBuilder? scannerBuilder;

  const DonorQrScannerScreen({super.key, this.scannerBuilder});

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
        appBar: AppBar(title: Text(AppStrings.scanQrTitle.tr())),
        body: Stack(
          fit: StackFit.expand,
          children: [
            scanner,
            Center(
              child: Container(
                width: AppSize.s260,
                height: AppSize.s260,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorManager.white,
                    width: AppSize.s3,
                  ),
                  borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(AppMargin.m20),
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: ColorManager.black.withValues(
                    alpha: AppOpacity.strong,
                  ),
                  borderRadius: BorderRadius.circular(AppSize.radiusXLarge),
                ),
                child: Text(
                  AppStrings.scanQrDescription.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorManager.white),
                ),
              ),
            ),
          ],
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
}
