import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:flutter/material.dart';

class AnimatedVerticalBox extends StatelessWidget {
  final bool isStartAnimated;
  final List<Widget> children;

  const AnimatedVerticalBox({
    super.key,
    required this.isStartAnimated,
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(seconds: 1),
      curve: const SpringCurve(),
      scale: isStartAnimated ? 1 : 0,
      child: Container(
          margin: const EdgeInsets.all(20),
          child: Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              ),
            ),
          )
      ),
    );
  }
}