import 'package:delivery_apps/api/osrm/models/trip_information.dart';
import 'package:delivery_apps/api/osrm/models/route.dart' as models;
import 'package:delivery_apps/api/osrm/models/step.dart' as models;
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
  final models.Step currentStep;
  final models.Step nextStep;
  final int currentStepId;
  final bool isAnimatedHelperDelivery;
  final bool isArrivedForUnloading;
  final bool isProcessOfUnloading;
  final Duration? currentWaitingDuration;

  TripRouteState({
    required this.delivery,
    required this.route,
    required this.distance,
    required this.duration,
    required this.time,
    required this.currentStep,
    required this.nextStep,
    required this.currentStepId,
    this.speed = 0,
    this.isAnimatedHelperDelivery = false,
    this.isArrivedForUnloading = false,
    this.isProcessOfUnloading = false,
    this.currentWaitingDuration,
  });

  TripRouteState copyWith({
    int? speed,
    int? distance,
    int? duration,
    DateTime? time,
    models.Step? currentStep,
    models.Step? nextStep,
    int? currentStepId,
    bool? isAnimatedHelperDelivery,
    bool? isArrivedForUnloading,
    bool? isProcessOfUnloading,
    Duration? currentWaitingDuration,
  }) =>
      TripRouteState(
          delivery: delivery,
          route: route,
          speed: speed ?? this.speed,
          distance: distance ?? this.distance,
          duration: duration ?? this.duration,
          time: time ?? this.time,
          currentStep: currentStep ?? this.currentStep,
          nextStep: nextStep ?? this.nextStep,
          currentStepId: currentStepId ?? this.currentStepId,
          isAnimatedHelperDelivery : isAnimatedHelperDelivery ?? this.isAnimatedHelperDelivery,
         isArrivedForUnloading: isArrivedForUnloading ?? this.isArrivedForUnloading,
          isProcessOfUnloading: isProcessOfUnloading ?? this.isProcessOfUnloading,
          currentWaitingDuration: currentWaitingDuration ?? currentWaitingDuration,
      );
}

class ProceedToStartOfDeliveryState extends HomeState {
  final models.Route route;
  final int speed;
  final int distance;
  final int duration;
  final DateTime time;
  final models.Step currentStep;
  final models.Step nextStep;
  final int currentStepId;
  final Delivery selectedDelivery;
  final bool isAnimatedHelperDelivery;
  final bool isArrivedForLoading;
  final bool isLoadingProcess;
  final Duration? currentWaitingDuration;

  ProceedToStartOfDeliveryState({
    required this.route,
    required this.distance,
    required this.duration,
    required this.time,
    required this.currentStep,
    required this.nextStep,
    required this.currentStepId,
    required this.selectedDelivery,
    this.speed = 0,
    this.isAnimatedHelperDelivery = false,
    this.isArrivedForLoading = false,
    this.isLoadingProcess = false,
    this.currentWaitingDuration,
  });

  ProceedToStartOfDeliveryState copyWith({
    models.Route? routeToStartDelivery,
    int? speed,
    int? distance,
    int? duration,
    DateTime? time,
    models.Step? currentStep,
    models.Step? nextStep,
    int? currentStepId,
    bool? isAnimatedHelperDelivery,
    bool? isArrivedForLoading,
    bool? isLoadingProcess,
    Duration? currentWaitingDuration,
    Delivery? selectedDelivery
  }) =>
      ProceedToStartOfDeliveryState(
          route: route,
          speed: speed ?? this.speed,
          distance: distance ?? this.distance,
          duration: duration ?? this.duration,
          time: time ?? this.time,
          currentStep: currentStep ?? this.currentStep,
          nextStep: nextStep ?? this.nextStep,
          currentStepId: currentStepId ?? this.currentStepId,
          isAnimatedHelperDelivery: isAnimatedHelperDelivery ?? this.isAnimatedHelperDelivery,
          isArrivedForLoading: isArrivedForLoading ?? this.isArrivedForLoading,
          isLoadingProcess: isLoadingProcess ?? this.isLoadingProcess,
          currentWaitingDuration: currentWaitingDuration ?? currentWaitingDuration,
          selectedDelivery: selectedDelivery ?? this.selectedDelivery,
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