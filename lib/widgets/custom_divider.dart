import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double indent;
  final double endIndent;
  final double height;

  const CustomDivider({
    super.key,
    this.thickness = 0.0,
    this.color = Colors.black,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.height = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}
