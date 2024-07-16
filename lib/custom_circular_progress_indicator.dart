import 'package:flutter/material.dart';

class DynamicCircularProgressPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final Color color;
  final double strokeWidth;

  DynamicCircularProgressPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.02)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.1)], // Gradient color effect
      ).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DynamicCircularProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const DynamicCircularProgressIndicator({
    super.key,
    this.size = 48.0,
    this.color = const Color(0xFF6750A4),
    this.strokeWidth = 8.0,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DynamicCircularProgressIndicatorState createState() =>
      _DynamicCircularProgressIndicatorState();
}

class _DynamicCircularProgressIndicatorState
    extends State<DynamicCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 2 * 3.141592653589793238)
            .animate(_controller);

    _sweepAnimation =
        Tween<double>(begin: 0.2, end: 1.5 * 3.141592653589793238).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: DynamicCircularProgressPainter(
              startAngle: _rotationAnimation.value,
              sweepAngle: _sweepAnimation.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}
