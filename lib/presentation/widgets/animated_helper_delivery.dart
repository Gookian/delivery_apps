import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:delivery_apps/util/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedHelperDelivery extends StatelessWidget {
  final bool isStartAnimated;
  final int distance;
  final ManeuverType maneuver;
  final String? street;

  const AnimatedHelperDelivery({
    super.key,
    required this.isStartAnimated,
    required this.distance,
    required this.maneuver,
    this.street
  });

  String _getManeuverIcon(ManeuverType maneuver) {
    switch (maneuver) {
      case ManeuverType.directly:
        return SvgIcons.forward;
      case ManeuverType.left:
        return SvgIcons.left;
      case ManeuverType.right:
        return SvgIcons.right;
      case ManeuverType.reversal:
        return SvgIcons.reversal;
      case ManeuverType.smoothlyLeft:
        return SvgIcons.slightLeft;
      case ManeuverType.smoothlyRight:
        return SvgIcons.slightRight;
    }
  }

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
                    SvgPicture.asset(
                      _getManeuverIcon(maneuver),
                      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                      width: 40,
                      height: 40,
                    ),
                    //Icon(Icons.roundabout_left, size: 40, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Text(
                      distance < 1000 ? '$distance м' : '${(distance / 1000).toStringAsFixed(1)} км',
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                street != null && street != '' ? const SizedBox(height: 8) : const SizedBox(),
                street != null && street != '' ? Text(
                  street!,
                  style: Theme.of(context).textTheme.bodySmall,
                ) : const SizedBox(),
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