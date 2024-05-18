import 'package:flutter/material.dart';

class CustomLocationMarker extends StatelessWidget {
  final Color color;

  final Widget? child;

  const CustomLocationMarker({
    super.key,
    this.color = const Color(0xFF2196F3),
    this.child,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Color(0xFFFFFFFF),
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: const EdgeInsets.all(1),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    ),
  );
}