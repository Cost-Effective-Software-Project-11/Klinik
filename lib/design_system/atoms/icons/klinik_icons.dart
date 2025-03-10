import 'package:flutter/material.dart';
import 'package:flutter_gp5/design_system/molecules/image/svg_image/svg_image.dart';

class KlinikIcons {
  KlinikIcons._();

  static Widget info({Color? color, double? width, double? height}) =>
      SvgImage.asset(
        'assets/icons/information.svg',
        width: width,
        height: height,
        color: color,
      );
}
