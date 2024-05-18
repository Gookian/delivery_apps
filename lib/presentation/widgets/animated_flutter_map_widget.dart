import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class AnimatedFlutterMap extends StatefulWidget {
  const AnimatedFlutterMap({
    super.key,
    required this.options,
    required this.children
  });

  final MapOptions options;
  final List<Widget> children;

  @override
  State<StatefulWidget> createState() => AnimatedFlutterMapState();
}

class AnimatedFlutterMapState extends State<AnimatedFlutterMap> with TickerProviderStateMixin {
  late final AnimatedMapController animatedMapController;


  // List<AnimatedMarker> _getAnimatedMarker() {
  //   if (widget.position != null) {
  //     return [
  //       AnimatedMarker(
  //         point: LatLng(widget.position!.latitude, widget.position!.longitude),
  //         alignment: Alignment.center,
  //         builder: (_, animation) {
  //           final size = 50.0 * animation.value;
  //           return Icon(
  //             Icons.navigation,
  //             color: Colors.blue,
  //             size: size,
  //           );
  //         },
  //       )
  //     ];
  //   }
  //
  //   return [];
  // }

  @override
  void initState() {
    animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    super.initState();
  }

  @override
  void dispose() {
    animatedMapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: animatedMapController.mapController,
      options: widget.options,
      children: widget.children
    );
  }
}