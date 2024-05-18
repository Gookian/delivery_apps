import 'dart:math';

import 'package:flutter/animation.dart';

class SpringCurve extends Curve {
  final double a;
  final double w;

  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4
  });

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}