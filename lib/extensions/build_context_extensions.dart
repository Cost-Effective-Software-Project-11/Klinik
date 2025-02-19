import 'package:flutter/material.dart';

extension ContextExtention on BuildContext {
  double get _width => MediaQuery.of(this).size.width;
  double get _height => MediaQuery.of(this).size.height;

  double setWidth(double percent) {
    final decimalPercentage = _getDecimalPercentage(percent);
    return _width * decimalPercentage;
  }

  double setHeight(double percent) {
    final decimalPercentage = _getDecimalPercentage(percent);
    return _height * decimalPercentage;
  }

  double setRadius(BuildContext context, double percent) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseDimension =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    final decimalPercentage = _getDecimalPercentage(percent);
    return baseDimension * decimalPercentage;
  }

  _getDecimalPercentage(double percent) {
    return percent / 100;
  }
  void showFailureSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(message, textAlign: TextAlign.center),
        ),
      );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Text(message, textAlign: TextAlign.center),
        ),
      );
  }

  void push(Widget screen) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (ctx) => screen,
      ),
    );
  }

  void pushReplacement(Widget screen) {
    Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => screen,
      ),
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
