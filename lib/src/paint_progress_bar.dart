part of 'progress_bar_marked.dart';

class _PaintProgressPainter extends CustomPainter {
  final double progress;
  final double strokeHeight;
  final double thumbRadius;
  final Color deactiveColor;
  final Color activeColor;
  final Color markColor;
  final Color thumbColor;
  final Color shadowColor;
  final double shadowBlur;
  final List<double> markers;
  final BuildContext context;

  const _PaintProgressPainter({
    required this.progress,
    required this.markers,
    required this.thumbRadius,
    required this.context,
    required this.deactiveColor,
    required this.activeColor,
    required this.strokeHeight,
    required this.markColor,
    required this.thumbColor,
    required this.shadowBlur,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width.isNaN ||
        size.height.isNaN ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    // Validate progress
    final double validProgress = progress.clamp(0.0, 1.0);

    final double yCenter = size.height / 2;

    // Draw background
    final backgroundPaint = Paint()
      ..color = deactiveColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(Offset(0, yCenter - strokeHeight / 2),
            Offset(size.width, yCenter + strokeHeight / 2)),
      ),
      backgroundPaint,
    );

    // Draw progress
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(0, yCenter - strokeHeight / 2),
          Offset(size.width * validProgress, yCenter + strokeHeight / 2),
        ),
      ),
      progressPaint,
    );

    // Draw markers
    final markerPaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.fill;

    for (final markerPosition in markers) {
      final double validMarkerPosition = markerPosition.clamp(0.0, 1.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * validMarkerPosition, yCenter),
            width: 4,
            height: strokeHeight,
          ),
          Radius.circular(2),
        ),
        markerPaint,
      );
    }

    // Draw thumb
    final thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;
    //  Draw shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    final thumbCenter = Offset(size.width * validProgress, yCenter);
    // Draw thumb shadow
    canvas.drawCircle(thumbCenter, thumbRadius, shadowPaint);

    // Draw thumb
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _PaintProgressPainter oldDelegate) {
    return progress != oldDelegate.progress || markers != oldDelegate.markers;
  }
}
