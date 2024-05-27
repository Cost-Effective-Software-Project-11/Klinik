import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
   // Convert width percentage to pixel value
  double widthPercentage(double percentage) {
    assert(percentage >= 0 && percentage <= 100);
    return MediaQuery.of(this).size.width * (percentage / 100);
  }
  // Convert height percentage to pixel value
  double heightPercentage(double percentage) {
    assert(percentage >= 0 && percentage <= 100);
    return MediaQuery.of(this).size.height * (percentage / 100);
  }
}
