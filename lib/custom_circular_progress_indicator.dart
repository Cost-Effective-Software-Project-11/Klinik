import 'package:flutter/material.dart';

class RoundedCircularProgressPainter extends CustomPainter {
  final double progress; // Progress value between 0.0 and 1.0
  final Color color; // Primary color of the progress indicator
  final double strokeWidth; // Thickness of the progress indicator

  RoundedCircularProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.1) // Lighten the background color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.2)], // Gradient color effect
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 2;

    // Draw the background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the progress arc
    double angle = 2 * 3.141592653589793238 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793238 / 2, // Start angle
      angle, // Sweep angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedCustomCircularProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const AnimatedCustomCircularProgressIndicator({
    super.key,
    this.size = 48.0,
    this.color = const Color(0xFF6750A4),
    this.strokeWidth = 6.0,
  });

  @override
  // ignore: library_private_types_in_public_api
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
            painter: RoundedCircularProgressPainter(
              progress: _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}
