import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:flutter/material.dart';

class AnimatedHelperDelivery extends StatelessWidget {
  final bool isStartAnimated;
  final int distance;
  final String street;
  final ManeuverType maneuver;

  const AnimatedHelperDelivery({
    super.key,
    required this.isStartAnimated,
    required this.distance,
    required this.street,
    required this.maneuver,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
        duration: const Duration(seconds: 1),
        curve: const SpringCurve(),
        scale: isStartAnimated ? 1 : 0,
        child: Material(
          elevation: 20,
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.roundabout_left, size: 40, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Text(
                      distance < 1000 ? '$distance м' : '${(distance / 1000).toStringAsFixed(1)} км',
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  street,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        )
    );
  }
}

enum ManeuverType {
  directly,
  left,
  right,
  reversal,
  smoothlyLeft,
  smoothlyRight,
}