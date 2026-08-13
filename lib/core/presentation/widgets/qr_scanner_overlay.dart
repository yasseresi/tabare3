import 'package:flutter/material.dart';

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
      duration: AppDurations.scannerScanLine,
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
    final rect = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );

    final bracketPaint = Paint()
      ..color = color
      ..strokeWidth = AppSize.scannerCornerStroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arm = AppSize.scannerCornerLength;
    final radius = AppSize.radiusXXLarge;

    // Top-left.
    _drawCorner(canvas, bracketPaint, rect.topLeft, arm, radius, 1, 1);
    // Top-right.
    _drawCorner(canvas, bracketPaint, rect.topRight, arm, radius, -1, 1);
    // Bottom-right.
    _drawCorner(canvas, bracketPaint, rect.bottomRight, arm, radius, -1, -1);
    // Bottom-left.
    _drawCorner(canvas, bracketPaint, rect.bottomLeft, arm, radius, 1, -1);

    if (!showScanLine) return;

    // Sweeping scan line, fading toward its edges.
    final y = rect.top + rect.height * progress;
    final lineRect = Rect.fromLTWH(
      rect.left,
      y - AppSize.scannerScanLineHeight / 2,
      rect.width,
      AppSize.scannerScanLineHeight,
    );
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color,
          color.withValues(alpha: 0),
        ],
      ).createShader(lineRect);
    canvas.drawRect(lineRect, linePaint);
  }

  void _drawCorner(
    Canvas canvas,
    Paint paint,
    Offset corner,
    double arm,
    double radius,
    double dx,
    double dy,
  ) {
    final path = Path()
      // Arm along the horizontal edge.
      ..moveTo(corner.dx + dx * (radius + arm), corner.dy)
      ..lineTo(corner.dx + dx * radius, corner.dy)
      // Rounded elbow through the corner point.
      ..quadraticBezierTo(
        corner.dx,
        corner.dy,
        corner.dx,
        corner.dy + dy * radius,
      )
      // Arm along the vertical edge.
      ..lineTo(corner.dx, corner.dy + dy * (radius + arm));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScannerPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.showScanLine != showScanLine ||
      oldDelegate.color != color;
}
