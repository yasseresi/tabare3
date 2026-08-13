import 'package:flutter/material.dart';

import '../../constants/app_dimensions.dart';
import '../../utils/color_manager.dart';
import '../../utils/values_manager.dart';

/// Clean scanner overlay drawn over the live camera preview: four rounded
/// corner brackets marking the target area and a soft scan line sweeping
/// vertically. Purely decorative, so it never intercepts pointer events.
class QrScannerOverlay extends StatefulWidget {
  /// Whether the scan line sweeps. Disabled when a fake scanner is injected
  /// (widget tests) so the endlessly-repeating animation never stalls
  /// `pumpAndSettle`; the corner brackets still render statically.
  final bool animate;

  const QrScannerOverlay({super.key, this.animate = true});

  @override
  State<QrScannerOverlay> createState() => _QrScannerOverlayState();
}

class _QrScannerOverlayState extends State<QrScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.scannerScanLine,
    );
    if (widget.animate) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ScannerPainter(
              progress: _controller.value,
              showScanLine: widget.animate,
              color: ColorManager.primary,
            ),
          );
        },
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({
    required this.progress,
    required this.showScanLine,
    required this.color,
  });

  final double progress;
  final bool showScanLine;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = AppSize.scannerInset;
    final target = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );

    _paintCornerBrackets(canvas, target);
    if (showScanLine) _paintScanLine(canvas, target);
  }

  void _paintCornerBrackets(Canvas canvas, Rect target) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppSize.scannerCornerStroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Each corner is paired with the direction its arms run in, so one bracket
    // path serves all four.
    final brackets = <(Offset, Offset)>[
      (target.topLeft, const Offset(1, 1)),
      (target.topRight, const Offset(-1, 1)),
      (target.bottomRight, const Offset(-1, -1)),
      (target.bottomLeft, const Offset(1, -1)),
    ];
    for (final (corner, inward) in brackets) {
      canvas.drawPath(_bracketPath(corner, inward), paint);
    }
  }

  Path _bracketPath(Offset corner, Offset inward) {
    final arm = AppSize.scannerCornerLength;
    final radius = AppSize.radiusXXLarge;
    return Path()
      // Arm along the horizontal edge.
      ..moveTo(corner.dx + inward.dx * (radius + arm), corner.dy)
      ..lineTo(corner.dx + inward.dx * radius, corner.dy)
      // Rounded elbow through the corner point.
      ..quadraticBezierTo(
        corner.dx,
        corner.dy,
        corner.dx,
        corner.dy + inward.dy * radius,
      )
      // Arm along the vertical edge.
      ..lineTo(corner.dx, corner.dy + inward.dy * (radius + arm));
  }

  /// Sweeping scan line, fading toward its edges.
  void _paintScanLine(Canvas canvas, Rect target) {
    final y = target.top + target.height * progress;
    final lineRect = Rect.fromLTWH(
      target.left,
      y - AppSize.scannerScanLineHeight / 2,
      target.width,
      AppSize.scannerScanLineHeight,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: AppOpacity.transparent),
          color,
          color.withValues(alpha: AppOpacity.transparent),
        ],
      ).createShader(lineRect);
    canvas.drawRect(lineRect, paint);
  }

  @override
  bool shouldRepaint(_ScannerPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.showScanLine != showScanLine ||
      oldDelegate.color != color;
}
