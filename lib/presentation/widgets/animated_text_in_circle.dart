import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:flutter/material.dart';

class AnimatedTextInCircle extends StatelessWidget {
  final bool isStartAnimated;
  final String text;

  const AnimatedTextInCircle({
    super.key,
    required this.isStartAnimated,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
        duration: const Duration(seconds: 1),
        curve: const SpringCurve(),
        scale: isStartAnimated ? 1 : 0,
        child: SizedBox(
          width: 80,
          height: 80,
          child: Material(
            elevation: 20,
            type: MaterialType.circle,
            color: Theme.of(context).colorScheme.background,
            child: Container(
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 32,
                    fontFamily: "montserrat",
                    color: Theme.of(context).colorScheme.background
                ),
              ),
            ),
          ),
        )
    );
  }
}