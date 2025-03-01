import 'package:flutter/material.dart';
import '../atoms/colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.width = double.infinity,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.height,
  });

  final double width;
  final double? height;
  final Widget child;
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: const [
            primary100,
            primary200,
            primary300,
          ],
          stops: const [0.5, 0.75, 1],
        ),
      ),
      child: child,
    );
  }
}
