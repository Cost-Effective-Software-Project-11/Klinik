import 'package:flutter/material.dart';

extension ContextExtention on BuildContext {
  double get _width => MediaQuery.of(this).size.width;
  double get _height => MediaQuery.of(this).size.height;

  double setWidth(double percent) {
    final decimalPercentage = _getDecimalPercentage(percent);
    return _width * decimalPercentage;
  }

  double setHight(double percent) {
    final decimalPercentage = _getDecimalPercentage(percent);
    return _height * decimalPercentage;
  }

  _getDecimalPercentage(double percent) {
    return percent / 100;
  }
}
