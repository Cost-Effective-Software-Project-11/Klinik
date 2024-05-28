// ignore_for_file: prefer_conditional_assignment

import 'package:flutter/material.dart';

class _MediaQueryCache {
  static double? _screenWidth;
  static double? _screenHeight;

  static double getScreenWidth(BuildContext context) {
    if (_screenWidth == null) {
      _screenWidth = MediaQuery.of(context).size.width;
    }
    return _screenWidth!;
  }

  static double getScreenHeight(BuildContext context) {
    if (_screenHeight == null) {
      _screenHeight = MediaQuery.of(context).size.height;
    }
    return _screenHeight!;
  }
}

extension BuildContextExtensions on BuildContext {
  double widthPercentage(double percentage) {
    assert(percentage >= 0 && percentage <= 100);
    double screenWidth = _MediaQueryCache.getScreenWidth(this);
    return screenWidth * _getDecimalPercentage(percentage);
  }

  double heightPercentage(double percentage) {
    assert(percentage >= 0 && percentage <= 100);
    double screenHeight = _MediaQueryCache.getScreenHeight(this);
    return screenHeight * _getDecimalPercentage(percentage);
  }

  double _getDecimalPercentage(double percentage) {
    return percentage / 100;
  }
}
