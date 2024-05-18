import 'package:delivery_apps/api/osrm/models/trip_information.dart';
import 'package:delivery_apps/api/osrm/models/route.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

abstract class HomeState {}

class HomeEmptyState extends HomeState {}

class HomeLoadingState extends HomeState {}

class DeliverySelectionState extends HomeState {
  final List<MarkerData> dataMarkers;
  final List<Delivery> deliveries;
  final Delivery? selectedDelivery;
  final bool isStartAppearanceAnimated;
  final bool isSelectedAnimated;
  final List<AnimatedMarker> animatedMarkers;

  DeliverySelectionState({
    required this.dataMarkers,
    required this.deliveries,
    this.selectedDelivery,
    this.isStartAppearanceAnimated = false,
    this.isSelectedAnimated = false,
    this.animatedMarkers = const []
  });

  DeliverySelectionState copyWith({
    List<MarkerData>? dataMarkers,
    List<Delivery>? deliveries,
    Delivery? selectedDelivery,
    bool? isStartAppearanceAnimated,
    bool? isSelectedAnimated,
    List<AnimatedMarker>? animatedMarkers
  }) =>
    DeliverySelectionState(
      dataMarkers: dataMarkers ?? this.dataMarkers,
      deliveries: deliveries ?? this.deliveries,
      selectedDelivery: selectedDelivery ?? this.selectedDelivery,
      isStartAppearanceAnimated: isStartAppearanceAnimated ?? this.isStartAppearanceAnimated,
      isSelectedAnimated: isSelectedAnimated ?? this.isSelectedAnimated,
      animatedMarkers: animatedMarkers ?? this.animatedMarkers
    );

  DeliverySelectionState resetCopyWith({Delivery? selectedDelivery}) =>
    DeliverySelectionState(
      dataMarkers: dataMarkers,
      deliveries: deliveries,
      selectedDelivery: selectedDelivery,
      isStartAppearanceAnimated: isStartAppearanceAnimated,
      isSelectedAnimated: isSelectedAnimated,
      animatedMarkers: animatedMarkers
    );
}

class TripRouteState extends HomeState {
  final Delivery delivery; //TODO Лишнеее
  final models.Route route;
  final int speed;
  final int distance;
  final int duration;
  final DateTime time;

  TripRouteState({
    required this.delivery,
    required this.route,
    required this.distance,
    required this.duration,
    required this.time,
    this.speed = 0,
  });

  TripRouteState copyWith({
    int? speed,
    int? distance,
    int? duration,
    DateTime? time,
  }) =>
      TripRouteState(
          delivery: delivery,
          route: route,
          speed: speed ?? this.speed,
          distance: distance ?? this.distance,
          duration: duration ?? this.duration,
          time: time ?? this.time
      );
}

class ProceedToStartOfDeliveryState extends HomeState {
  final models.Route route;
  final int speed;
  final int distance;
  final int duration;
  final DateTime time;

  ProceedToStartOfDeliveryState({
    required this.route,
    required this.distance,
    required this.duration,
    required this.time,
    this.speed = 0,
  });

  ProceedToStartOfDeliveryState copyWith({
    models.Route? routeToStartDelivery,
    int? speed,
    int? distance,
    int? duration,
    DateTime? time,
  }) =>
      ProceedToStartOfDeliveryState(
          route: route,
          speed: speed ?? this.speed,
          distance: distance ?? this.distance,
          duration: duration ?? this.duration,
          time: time ?? this.time
      );
}

class HomeErrorState extends HomeState {}

class MarkerData {
  final DeliveryPoint data;
  final IconData icon;
  final Color color;
  final Size size;
  final Alignment alignment;

  MarkerData({
    required this.data,
    required this.icon,
    required this.color,
    required this.size,
    required this.alignment
  });
}

class Delivery {
  final DeliveryPoint from;
  final DeliveryPoint to;
  final TripInformation tripInfo;

  Delivery({
    required this.from,
    required this.to,
    required this.tripInfo
  });
}

class DeliveryPoint {
  final String name;
  final LatLng position;

  DeliveryPoint({
    required this.name,
    required this.position,
  });
}