import 'dart:async';
import 'dart:math';

import 'package:delivery_apps/api/logistic/logistic_api_client.dart';
import 'package:delivery_apps/api/logistic/models/order_pick_up_point.dart';
import 'package:delivery_apps/api/logistic/models/sorting_center.dart';
import 'package:delivery_apps/api/logistic/models/warehouse.dart';
import 'package:delivery_apps/api/osrm/osrm_api_client.dart';
import 'package:delivery_apps/domain/usecases/%D1%81heck_that_point_is_within_trigger_radius_use_case.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_state.dart';
import 'package:delivery_apps/presentation/widgets/animated_flutter_map_widget.dart';
import 'package:delivery_apps/repositories/token_repository.dart';
import 'package:delivery_apps/util/extensions/polyline_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoadingState());

  StreamSubscription<Position>? _positionStream;
  Timer? _timer;

  final mapKey = GlobalKey<AnimatedFlutterMapState>();
  final apiClient = OsrmApiClient(Dio());
  final client = LogisticApiClient(Dio());
  final _checkTriggerUseCase = CheckThatPointIsWithinTriggerRadiusUseCase();
  final locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 2,
    forceLocationManager: true,
    intervalDuration: const Duration(milliseconds: 500),
  );

  List<MarkerData> get dataMarkers =>
      state is DeliverySelectionState ?
      (state as DeliverySelectionState).dataMarkers :
      [];

  List<Delivery> get deliveries =>
      state is DeliverySelectionState ?
      (state as DeliverySelectionState).deliveries :
      [];

  Delivery? get selectedDelivery =>
      state is DeliverySelectionState ?
      (state as DeliverySelectionState).selectedDelivery :
      null;

  List<Delivery> _deliveriesLoaded = [];
  Future<List<Delivery>> getDeliveries(List<MarkerData> dataMarkers) async => [
    /*await _getDeliveryFromTo(from: 0, to: 3, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 6, to: 0, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 0, to: 1, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 0, to: 2, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 9, to: 11, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 10, to: 8, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 0, to: 4, dataMarkers: dataMarkers),
    await _getDeliveryFromTo(from: 0, to: 5, dataMarkers: dataMarkers),
    Delivery(
        from: DeliveryPoint(name: "Дом", position: const LatLng(56.504428050349595, 84.94338200533163)),
        to: DeliveryPoint(name: "Универ", position: const LatLng(56.45121716272401, 84.96377131658873)),
        tripInfo: await apiClient.getOsrmResponse(84.94338200533163, 56.504428050349595, 84.96377131658873, 56.45121716272401, 'full', 3, true, false, 'polyline')
    ),
    Delivery(
        from: DeliveryPoint(name: "Дом", position: const LatLng(56.504428050349595, 84.94338200533163)),
        to: DeliveryPoint(name: "Дом", position: const LatLng(56.504428050349595, 84.94338200533163)),
        tripInfo: await apiClient.getOsrmResponse(84.94338200533163, 56.504428050349595, 84.94338200533163, 56.504428050349595, 'full', 3, true, false, 'polyline')
    ),
    Delivery(
        from: DeliveryPoint(name: "Тест 1", position: const LatLng(56.50444, 84.94696)),
        to: DeliveryPoint(name: "Тест 2", position: const LatLng(56.49863, 84.94696)),
        tripInfo: await apiClient.getOsrmResponse(84.94696, 56.50444, 84.94696, 56.49863, 'full', 3, true, false, 'polyline')
    ),*/
    Delivery(
        from: DeliveryPoint(name: "Тест 3", position: const LatLng(56.49669721170988,84.98338795153803)),
        to: DeliveryPoint(name: "Тест 4", position: const LatLng(56.44680720757942,85.02591436460935)),
        tripInfo: await apiClient.getOsrmResponse(84.98338795153803, 56.49669721170988, 85.02591436460935, 56.44680720757942, 'full', 3, true, false, 'polyline')
    ),
  ];

  Future<Delivery> _getDeliveryFromTo({from, to, required List<MarkerData> dataMarkers}) async {
    return Delivery(
        from: dataMarkers[from].data,
        to: dataMarkers[to].data,
        tripInfo: await apiClient.getOsrmResponse(
            dataMarkers[from].data.position.longitude,
            dataMarkers[from].data.position.latitude,
            dataMarkers[to].data.position.longitude,
            dataMarkers[to].data.position.latitude,
            'full', 3,
            true,
            false,
            'polyline'
        )
    );
  }

  List<MarkerData> getMarkerDataWarehouses(List<Warehouse> warehouses) {
    return warehouses.asMap().map((key, value) {
      return MapEntry(key, MarkerData(
          data: DeliveryPoint(name: value.name, position: LatLng(value.latitude, value.longitude)),
          icon: Icons.place_rounded,
          color: Colors.pink,
          size: const Size.square(40),
          alignment: Alignment.topCenter
      ));
    }).values.toList();
  }

  List<MarkerData> getMarkerDataOrderPickUpPoints(List<OrderPickUpPoint> warehouses) {
    return warehouses.asMap().map((key, value) {
      return MapEntry(key, MarkerData(
          data: DeliveryPoint(name: value.name, position: LatLng(value.latitude, value.longitude)),
          icon: Icons.place_rounded,
          color: Colors.deepPurple,
          size: const Size.square(40),
          alignment: Alignment.topCenter
      ));
    }).values.toList();
  }

  List<MarkerData> getMarkerDataSortingCenters(List<SortingCenter> warehouses) {
    return warehouses.asMap().map((key, value) {
      return MapEntry(key, MarkerData(
          data: DeliveryPoint(name: value.name, position: LatLng(value.latitude, value.longitude)),
          icon: Icons.place_rounded,
          color: Colors.blue,
          size: const Size.square(40),
          alignment: Alignment.topCenter
      ));
    }).values.toList();
  }

  Future<void> load() async {
    List<MarkerData> dataMarkers = [];

    final warehouses = await client.getWarehouses(TokenRepository.token ?? "");
    final orderPickUpPoints = await client.getOrderPickUpPoints(TokenRepository.token ?? "");
    final sortingCenters = await client.getSortingCenters(TokenRepository.token ?? "");

    dataMarkers.addAll(getMarkerDataWarehouses(warehouses));
    dataMarkers.addAll(getMarkerDataOrderPickUpPoints(orderPickUpPoints));
    dataMarkers.addAll(getMarkerDataSortingCenters(sortingCenters));

    _deliveriesLoaded = await getDeliveries(dataMarkers);

    final createdState = DeliverySelectionState(dataMarkers: dataMarkers, deliveries: _deliveriesLoaded);
    emit(createdState);

    Future.delayed(const Duration(milliseconds: 250), () {
      emit(createdState.copyWith(isStartAppearanceAnimated: true));
    });
  }

  // TODO Возможно временная функция
  Future<void> reload() async {
    List<MarkerData> dataMarkers = [];

    final warehouses = await client.getWarehouses(TokenRepository.token ?? "");
    final orderPickUpPoints = await client.getOrderPickUpPoints(TokenRepository.token ?? "");
    final sortingCenters = await client.getSortingCenters(TokenRepository.token ?? "");

    dataMarkers.addAll(getMarkerDataWarehouses(warehouses));
    dataMarkers.addAll(getMarkerDataOrderPickUpPoints(orderPickUpPoints));
    dataMarkers.addAll(getMarkerDataSortingCenters(sortingCenters));

    final createdState = DeliverySelectionState(dataMarkers: dataMarkers, deliveries: _deliveriesLoaded);
    emit(createdState);

    Future.delayed(const Duration(milliseconds: 250), () {
      emit(createdState.copyWith(isStartAppearanceAnimated: true));
    });
  }

  void addAnimatedMarker(AnimatedMarker value) {
    // TODO Доделать функционал подсказок на маркерах
    var currentState = state;

    if (currentState is DeliverySelectionState) {
      List<AnimatedMarker> markers = [];
      markers.addAll(currentState.animatedMarkers);
      markers.add(value);

      emit(currentState.copyWith(animatedMarkers: markers));
    }
  }

  final StreamController _streamController = StreamController<LocationMarkerHeading?>();
  Timer? _timerStream;
  Position? oldPosition;
  Stream<LocationMarkerHeading?>? getHeadingStream() {
    _timerStream ??= Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
            final position = await determinePosition();
            final headingInRadians = (position.heading * (pi / 180));
            final headingAccuracyInRadians = (position.headingAccuracy * (pi / 180));
            late final LocationMarkerHeading locationMarkerHeading;
            if (headingInRadians != 0) {
              oldPosition = position;
              locationMarkerHeading = LocationMarkerHeading(heading: headingInRadians, accuracy: headingAccuracyInRadians);
            } else {
              if (oldPosition != null) {
                final oldHeadingInRadians = (oldPosition!.heading * (pi / 180));
                final oldHeadingAccuracyInRadians = (oldPosition!.headingAccuracy * (pi / 180));
                locationMarkerHeading = LocationMarkerHeading(heading: oldHeadingInRadians, accuracy: oldHeadingAccuracyInRadians);
              } else {
                locationMarkerHeading = LocationMarkerHeading(heading: 0, accuracy: 0);
              }
            }
            _streamController.add(locationMarkerHeading);
          });

    if (_streamController.stream is Stream<LocationMarkerHeading?>) {
      return _streamController.stream as Stream<LocationMarkerHeading?>;
    } else {
      _timerStream?.cancel();
      return null;
    }
  }

  void openRoute(int index) {
    var currentState = state;

    if (currentState is DeliverySelectionState) {
      try {
        final createdState = currentState.copyWith(selectedDelivery: currentState.deliveries[index]);
        emit(createdState);

        Future.delayed(const Duration(milliseconds: 1000), () {
          emit(createdState.copyWith(isSelectedAnimated: true));
        });
      } on RangeError {
        debugPrint('Индекс находится за пределами списка'); // Обработка исключения RangeError
      }
    }
  }

  void closeRoute() {
    var currentState = state;

    if (currentState is DeliverySelectionState) {
      final createdState = currentState.copyWith(isSelectedAnimated: false);
      emit(createdState);

      Future.delayed(const Duration(milliseconds: 1000), () {
        emit(createdState.resetCopyWith(selectedDelivery: null));
      });
    }
  }

  LatLng getVisibleBounds() {
    final bottomRight = mapKey.currentState?.animatedMapController.mapController.camera.visibleBounds.southEast;
    final topLeft = mapKey.currentState?.animatedMapController.mapController.camera.visibleBounds.northWest;

    return LatLng(topLeft!.latitude - bottomRight!.latitude, -1 * (topLeft.longitude - bottomRight.longitude));
  }

  void testHintRouteStep() {
    // TODO Удалить после тестов
    var currentState = state as ProceedToStartOfDeliveryState;
    final index = currentState.currentStepId + 1;

    currentState = currentState.copyWith(isAnimatedHelperDelivery: false);
    emit(currentState);

    Future.delayed(const Duration(milliseconds: 1000), () {
      currentState = currentState.copyWith(
          currentStep: currentState.route.legs[0].steps[index],
          nextStep: currentState.route.legs[0].steps[index + 1],
          currentStepId: index,
          isAnimatedHelperDelivery: false
      );
      emit(currentState);
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      currentState = currentState.copyWith(isAnimatedHelperDelivery: true);
      emit(currentState);
    });
  }

  Future<void> clickArrivedForLoading() async {
    var currentState = state;

    if (currentState is ProceedToStartOfDeliveryState) {
      await _positionStream?.cancel();

      currentState = currentState.copyWith(isLoadingProcess: true, currentWaitingDuration: const Duration());
      emit(currentState);

      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        final duration = Duration(seconds: ((currentState as ProceedToStartOfDeliveryState).currentWaitingDuration?.inSeconds ?? 0) + 1);
        currentState = (currentState as ProceedToStartOfDeliveryState).copyWith(currentWaitingDuration: duration);
        emit(currentState);
      });
    }
  }

  Future<void> clickArrivedForUnloading() async {
    var currentState = state;

    if (currentState is TripRouteState) {
      await _positionStream?.cancel();

      currentState = currentState.copyWith(isProcessOfUnloading: true, currentWaitingDuration: const Duration());
      emit(currentState);

      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        final duration = Duration(seconds: ((currentState as TripRouteState).currentWaitingDuration?.inSeconds ?? 0) + 1);
        currentState = (currentState as TripRouteState).copyWith(currentWaitingDuration: duration);
        emit(currentState);
      });
    }
  }

  Future<void> startProceedToStartOfDelivery() async {
    final geoPosition = await determinePosition();
    final tripInfo = await apiClient.getOsrmResponse(geoPosition.longitude, geoPosition.latitude, selectedDelivery!.tripInfo.waypoints[0].location[0], selectedDelivery!.tripInfo.waypoints[0].location[1], 'full', 1, true, false, 'polyline');
    final routeToStart = tripInfo.routes[0];
    final route = selectedDelivery!.tripInfo.routes[0];
    final duration = Duration(seconds: routeToStart.duration.toInt());

    var createdState = ProceedToStartOfDeliveryState(
        route: tripInfo.routes[0],
        distance: route.distance.toInt() + routeToStart.distance.toInt(),
        duration: route.duration.toInt() + routeToStart.distance.toInt(),
        time: DateTime.now().add(duration),
        currentStep: routeToStart.legs[0].steps[0],
        nextStep: routeToStart.legs[0].steps[1],
        currentStepId: 0,
        selectedDelivery: selectedDelivery!
    );
    final routePoints = decodePolyline(createdState.route.geometry).unpackPolyline();

    emit(createdState);

    Future.delayed(const Duration(milliseconds: 250), () {
      createdState = createdState.copyWith(isAnimatedHelperDelivery: true);
      emit(createdState);
    });

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null && state is ProceedToStartOfDeliveryState) {
          var currentState = state as ProceedToStartOfDeliveryState;
          final isEndManeuver = _checkTriggerUseCase.isPointInCircle(
              currentState.nextStep.maneuver.location[1],
              currentState.nextStep.maneuver.location[0],
              position.latitude,
              position.longitude,
              50
          );
          final isEndRoute = _checkTriggerUseCase.isPointInCircle(
              routePoints[routePoints.length - 1].latitude,
              routePoints[routePoints.length - 1].longitude,
              position.latitude,
              position.longitude,
              200
          );

          if (isEndRoute) {
            currentState = currentState.copyWith(isArrivedForLoading: true);
            emit(currentState);
          } else {
            currentState = currentState.copyWith(isArrivedForLoading: false);
            emit(currentState);
          }

          final index = currentState.currentStepId + 1;
          if (isEndManeuver && index + 1 < routeToStart.legs[0].steps.length) {
            currentState = currentState.copyWith(isAnimatedHelperDelivery: false);
            emit(currentState);

            Future.delayed(const Duration(milliseconds: 1000), () {
              currentState = currentState.copyWith(
                  currentStep: routeToStart.legs[0].steps[index],
                  nextStep: routeToStart.legs[0].steps[index + 1],
                  currentStepId: index,
                  isAnimatedHelperDelivery: false
              );
              emit(currentState);
            });

            Future.delayed(const Duration(milliseconds: 1000), () {
              currentState = currentState.copyWith(isAnimatedHelperDelivery: true);
              emit(currentState);
            });
          }
          emit((state as ProceedToStartOfDeliveryState).copyWith(speed: (position.speed * 3600) ~/ 1000));
        }
      }
    );
  }

  Future<void> startDriving() async {
    await _positionStream?.cancel();
    _timer?.cancel();

    final route = (state as ProceedToStartOfDeliveryState).selectedDelivery.tripInfo.routes[0];
    final duration = Duration(seconds: route.duration.toInt());

    var createdState = TripRouteState(
        delivery: (state as ProceedToStartOfDeliveryState).selectedDelivery,
        route: route,
        distance: route.distance.toInt(),
        duration: route.duration.toInt(),
        time: DateTime.now().add(duration),
        currentStep: route.legs[0].steps[0],
        nextStep: route.legs[0].steps[1],
        currentStepId: 0
    );
    final routePoints = decodePolyline(createdState.route.geometry).unpackPolyline();

    emit(createdState);

    Future.delayed(const Duration(milliseconds: 250), () {
      createdState = createdState.copyWith(isAnimatedHelperDelivery: true);
      emit(createdState);
    });

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) {
        if (position != null && state is TripRouteState) {
          var currentState = state as TripRouteState;
          final isEndManeuver = _checkTriggerUseCase.isPointInCircle(
              currentState.nextStep.maneuver.location[1],
              currentState.nextStep.maneuver.location[0],
              position.latitude,
              position.longitude,
              50
          );
          final isEndRoute = _checkTriggerUseCase.isPointInCircle(
              routePoints[routePoints.length - 1].latitude,
              routePoints[routePoints.length - 1].longitude,
              position.latitude,
              position.longitude,
              200
          );

          if (isEndRoute) {
            currentState = currentState.copyWith(isArrivedForUnloading: true);
            emit(currentState);
          } else {
            currentState = currentState.copyWith(isArrivedForUnloading: false);
            emit(currentState);
          }

          final index = currentState.currentStepId + 1;
          if (isEndManeuver && index + 1 < route.legs[0].steps.length) {
            currentState =
                currentState.copyWith(isAnimatedHelperDelivery: false);
            emit(currentState);

            Future.delayed(const Duration(milliseconds: 1000), () {
              currentState = currentState.copyWith(
                  currentStep: route.legs[0].steps[index],
                  nextStep: route.legs[0].steps[index + 1],
                  currentStepId: index,
                  isAnimatedHelperDelivery: false
              );
              emit(currentState);
            });

            Future.delayed(const Duration(milliseconds: 1000), () {
              currentState =
                  currentState.copyWith(isAnimatedHelperDelivery: true);
              emit(currentState);
            });
          }
          emit((state as TripRouteState).copyWith(speed: (position.speed * 3600) ~/ 1000));
        }
      });
    }

  Future<void> endDriving() async {
    await _positionStream?.cancel();
    _timer?.cancel();

    reload();
  }

  Future<void> closeDriving() async {
    await _positionStream?.cancel();
    _timer?.cancel();

    reload();
  }

  Future<void> checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position> determinePosition() async {
    checkLocationServiceEnabled();
    checkLocationPermission();

    return await Geolocator.getCurrentPosition();
  }

  LatLng? findCenterRectangleRoutes() {
    final currentState = state;

    if (currentState is DeliverySelectionState) {
      final List<LatLng> points = [];

      currentState.selectedDelivery?.tripInfo.routes.forEach((route) {
        points.addAll(decodePolyline(route.geometry).unpackPolyline());
      });

      double maxLongitude = points.map((e) => e.longitude).toList().reduce(max);
      double maxLatitude = points.map((e) => e.latitude).toList().reduce(max);
      double minLongitude = points.map((e) => e.longitude).toList().reduce(min);
      double minLatitude = points.map((e) => e.latitude).toList().reduce(min);

      double centerLongitude = (maxLongitude + minLongitude) / 2;
      double centerLatitude = (maxLatitude + minLatitude) / 2;

      var visibleBounds = getVisibleBounds();

      return LatLng(centerLatitude - 0.10 * visibleBounds.latitude, centerLongitude);
    }

    return null;
  }

  double? getZoomByRectangleRoutes() {
    final currentState = state;

    if (currentState is DeliverySelectionState) {
      final List<LatLng> points = [];

      currentState.selectedDelivery?.tripInfo.routes.forEach((route) {
        points.addAll(decodePolyline(route.geometry).unpackPolyline());
      });

      double maxLongitude = points.map((e) => e.longitude).toList().reduce(max);
      double maxLatitude = points.map((e) => e.latitude).toList().reduce(max);
      double minLongitude = points.map((e) => e.longitude).toList().reduce(min);
      double minLatitude = points.map((e) => e.latitude).toList().reduce(min);

      double sizeLongitude = maxLongitude - minLongitude;
      double sizeLatitude = maxLatitude - minLatitude;

      double minZoom = 4;
      double maxZoom = 20;
      double padding = 2;

      double viewportLongitude = (log((1953125 * (sizeLongitude * padding)) / 619633) / log(2)) + 9;
      double viewportLatitude = (log((152587890625 * (sizeLatitude * padding * 100.5)) / 528100000000009) / log(2)) + 16;
      double normalizeLongitudeZoom = maxZoom + minZoom - (viewportLongitude + minZoom);
      double normalizeLatitudeZoom = maxZoom + minZoom - (viewportLatitude + minZoom);

      double zoom = [normalizeLongitudeZoom, normalizeLatitudeZoom].reduce(min);

      if (zoom <= minZoom) {
        zoom = minZoom;
      } else if (zoom >= maxZoom) {
        zoom = maxZoom;
      }

      return zoom;
    }

    return null;
  }
}