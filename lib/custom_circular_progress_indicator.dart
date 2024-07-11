import 'package:flutter/material.dart';

class AnimatedCustomCircularProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const AnimatedCustomCircularProgressIndicator({
    super.key,
    this.size = 48.0,
    this.color = const Color(0xFF6750A4),
    this.strokeWidth = 8.0,
  });

  @override
  _AnimatedCustomCircularProgressIndicatorState createState() => _AnimatedCustomCircularProgressIndicatorState();
}

class _AnimatedCustomCircularProgressIndicatorState extends State<AnimatedCustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
            painter: _CircularProgressPainter(
              startAngle: _controller.value * 2 * 3.141592653589793238,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double startAngle;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.startAngle,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.03)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.1)],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 2;

    // Draw the background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the progress arc
    double sweepAngle = 3.141592653589793238 * 1.5; // Constant sweep angle for 3/4 of the circle
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
