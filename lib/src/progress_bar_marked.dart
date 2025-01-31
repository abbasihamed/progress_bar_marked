import 'package:flutter/material.dart';

part 'paint_progress_bar.dart';

class ProgressBarMarked extends StatelessWidget {
  /// Creating [progressBars] for video and audio and the ability to show specific positions in the progress bar.
  ///
  /// [position] and [duration] must be given a value.

  final Duration position;
  final Duration duration;
  final List<Duration> markers;

  const ProgressBarMarked({
    super.key,
    required this.duration,
    required this.position,
    this.markers = const <Duration>[],
    this.onUpdate,
    this.onUpdateStart,
    this.onUpdateEnd,
    this.strokeHeight = 5,
    this.activeColor = Colors.blue,
    this.deactiveColor = Colors.grey,
    this.markColor = Colors.blue,
    this.thumbColor = Colors.blue,
    this.thumbRadius = 10,
    this.shadowBlur = 3,
    this.shadowColor = Colors.grey,
  });

  /// It will return you the updated [Duration] every time you update the progress bar.
  final Function(Duration duration)? onUpdate;

  /// Specifies the start of the [update]
  final VoidCallback? onUpdateStart;

  /// Indicates the end of the [update]
  final VoidCallback? onUpdateEnd;
  final double strokeHeight;
  final Color deactiveColor;
  final Color activeColor;
  final Color markColor;
  final double thumbRadius;
  final Color thumbColor;
  final Color shadowColor;
  final double shadowBlur;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) =>
          onUpdateStart?.call(),
      onHorizontalDragEnd: (DragEndDetails details) => onUpdateEnd?.call(),
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        final box = context.findRenderObject() as RenderBox;
        final Offset localPosition = box.globalToLocal(details.globalPosition);
        final double progress =
            (localPosition.dx / box.size.width).clamp(0.0, 1.0);
        final Duration newPosition = duration * progress;
        onUpdate?.call(newPosition);
      },
      onTapDown: (TapDownDetails details) {
        final box = context.findRenderObject() as RenderBox;
        final Offset localPosition = box.globalToLocal(details.globalPosition);
        final double progress =
            (localPosition.dx / box.size.width).clamp(0.0, 1.0);
        final Duration newPosition = duration * progress;
        onUpdate?.call(newPosition);
      },
      child: SizedBox(
        height: 40,
        child: CustomPaint(
          size: Size.infinite,
          painter: _PaintProgressPainter(
            progress: position.inMilliseconds / duration.inMilliseconds,
            markers: markers
                .map((m) => m.inMilliseconds / duration.inMilliseconds)
                .toList(),
            context: context,
            deactiveColor: deactiveColor,
            activeColor: activeColor,
            markColor: markColor,
            strokeHeight: strokeHeight,
            thumbRadius: thumbRadius,
            thumbColor: thumbColor,
            shadowBlur: shadowBlur,
            shadowColor: shadowColor,
          ),
        ),
      ),
    );
  }
}
