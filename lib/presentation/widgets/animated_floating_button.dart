import 'package:flutter/material.dart';
import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData iconData;
  final bool isStartAnimated;
  final MaterialColor? color;

  const AnimatedFloatingButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.isStartAnimated,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(seconds: 1),
      curve: const SpringCurve(),
      scale: isStartAnimated ? 1 : 0,
      child: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: ThemeModeHandler.of(context)?.themeMode == ThemeMode.light ?
              color?.shade500 ?? Theme.of(context).colorScheme.background :
              color?.shade900 ?? Theme.of(context).colorScheme.background,
            child: ClipRRect(
              child: Icon(iconData, size: 20, color: color == null ? Theme.of(context).colorScheme.secondary : Colors.white),
            )
        ),
      ),
    );
  }

}