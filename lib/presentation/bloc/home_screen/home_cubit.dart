import 'dart:async';
import 'dart:math';

import 'package:delivery_apps/api/logistic/logistic_api_client.dart';
import 'package:delivery_apps/api/logistic/models/order_pick_up_point.dart';
import 'package:delivery_apps/api/logistic/models/sorting_center.dart';
import 'package:delivery_apps/api/logistic/models/warehouse.dart';
import 'package:delivery_apps/api/osrm/osrm_api_client.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_state.dart';
import 'package:delivery_apps/presentation/widgets/animated_flutter_map_widget.dart';
import 'package:delivery_apps/repositories/token_repository.dart';
import 'package:delivery_apps/util/extensions/polyline_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoadingState());

  final apiClient = OsrmApiClient(Dio());

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

  final mapKey = GlobalKey<AnimatedFlutterMapState>();
  late final StreamSubscription<Position> _positionStream;

  /*List<MarkerData> get _dataMarkers => [
    MarkerData(
        data: DeliveryPoint(name: "Склад г. Новосибирск", position: const LatLng(55.02388488787072,82.91872385937504)),
        icon: Icons.place_rounded,
        color: Colors.pink,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Кемерово", position: const LatLng(55.35429488094442,86.0870136506815)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Юрга", position: const LatLng(55.71354375938833,84.93332184674782)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Томск", position: const LatLng(56.510742836586395,85.03563202741184)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Красноярск", position: const LatLng(56.066322746224095,92.88191748213123)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Омск", position: const LatLng(54.984116125633015,73.48375311218066)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Склад г.Москва", position: const LatLng(55.755793, 37.617134)),
        icon: Icons.place_rounded,
        color: Colors.pink,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Коломна", position: const LatLng(55.095960, 38.765519)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Владимир", position: const LatLng(56.129038, 40.406502)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Калуга", position: const LatLng(54.513645, 36.261268)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Тула", position: const LatLng(54.193122, 37.617177)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    ),
    MarkerData(
        data: DeliveryPoint(name: "Сорт. центр г. Рязань", position: const LatLng(54.629540, 39.741809)),
        icon: Icons.place_rounded,
        color: Colors.blue,
        size: const Size.square(40),
        alignment: Alignment.topCenter
    )
  ];*/

  List<Delivery> _deliveriesLoaded = [];
  /*Future<List<Delivery>> get _deliveries async => [
    await _getDeliveryFromTo(from: 0, to: 3),
    await _getDeliveryFromTo(from: 6, to: 0),
    await _getDeliveryFromTo(from: 0, to: 1),
    await _getDeliveryFromTo(from: 0, to: 2),
    await _getDeliveryFromTo(from: 9, to: 11),
    await _getDeliveryFromTo(from: 10, to: 8),
    await _getDeliveryFromTo(from: 0, to: 4),
    await _getDeliveryFromTo(from: 0, to: 5),
    Delivery(
        from: DeliveryPoint(name: "Дом", position: const LatLng(56.504428050349595, 84.94338200533163)),
        to: DeliveryPoint(name: "Универ", position: const LatLng(56.45121716272401, 84.96377131658873)),
        tripInfo: await apiClient.getOsrmResponse(84.94338200533163, 56.504428050349595, 84.96377131658873, 56.45121716272401, 'full', 3, true, false, 'polyline')
    ),
  ];

  Future<Delivery> _getDeliveryFromTo({from, to}) async {
    return Delivery(
        from: _dataMarkers[from].data,
        to: _dataMarkers[to].data,
        tripInfo: await apiClient.getOsrmResponse(
            _dataMarkers[from].data.position.longitude,
            _dataMarkers[from].data.position.latitude,
            _dataMarkers[to].data.position.longitude,
            _dataMarkers[to].data.position.latitude,
            'full', 3,
            true,
            false,
            'polyline'
        )
    );
  }*/

  final client = LogisticApiClient(Dio());

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
    //_deliveriesLoaded = await _deliveries;
    //final createdState = DeliverySelectionState(dataMarkers: _dataMarkers, deliveries: _deliveriesLoaded);
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
    var currentState = state;

    if (currentState is DeliverySelectionState) {
      List<AnimatedMarker> markers = [];
      markers.addAll(currentState.animatedMarkers);
      markers.add(value);

      emit(currentState.copyWith(animatedMarkers: markers));
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

  @override
  void onChange(Change<HomeState> change) {
    print("After: ${change.currentState} -> ${change.nextState}");
    super.onChange(change);
    print("Before: ${change.currentState} -> ${change.nextState}");
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

  LatLng? findCenterRoutes() {
    final currentState = state;

    if (currentState is DeliverySelectionState) {
      final List<LatLng> points = [];

      currentState.selectedDelivery?.tripInfo.routes.forEach((route) {
        points.addAll(decodePolyline(route.geometry).unpackPolyline());
      });

      double sumLongitude = 0;
      double sumLatitude = 0;

      for (LatLng point in points) {
        sumLongitude += point.longitude;
        sumLatitude += point.latitude;
      }

      double centerLongitude = sumLongitude / points.length;
      double centerLatitude = sumLatitude / points.length;

      return LatLng(centerLatitude, centerLongitude);
    }

    return null;
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

  LatLng getVisibleBounds() {
    final bottomRight = mapKey.currentState?.animatedMapController.mapController.camera.visibleBounds.southEast;
    final topLeft = mapKey.currentState?.animatedMapController.mapController.camera.visibleBounds.northWest;

    return LatLng(topLeft!.latitude - bottomRight!.latitude, -1 * (topLeft.longitude - bottomRight.longitude));
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

      debugPrint([normalizeLongitudeZoom, normalizeLatitudeZoom].toString());
      debugPrint(zoom.toString());
      debugPrint(sizeLongitude.toString());
      debugPrint(sizeLatitude.toString());
      return zoom;
    }

    return null;
  }

  Future<void> startProceedToStartOfDelivery() async {
    var geoPosition = await determinePosition();
    var tripInfo = await apiClient.getOsrmResponse(geoPosition.longitude, geoPosition.latitude, selectedDelivery!.tripInfo.waypoints[0].location[0], selectedDelivery!.tripInfo.waypoints[0].location[1], 'full', 1, true, false, 'polyline');
    var duration = Duration(seconds: tripInfo.routes[0].duration.toInt());

    emit(ProceedToStartOfDeliveryState(
      route: tripInfo.routes[0],
      distance: selectedDelivery!.tripInfo.routes[0].distance.toInt() + tripInfo.routes[0].distance.toInt(),
      duration: selectedDelivery!.tripInfo.routes[0].duration.toInt() + tripInfo.routes[0].distance.toInt(),
      time: DateTime.now().add(duration)
    ));

    LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2,
      forceLocationManager: true,
      intervalDuration: const Duration(milliseconds: 500),
    );
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
          print(((position?.speed ?? 0.01)  * 3600) ~/ 1000);
          emit((state as ProceedToStartOfDeliveryState).copyWith(speed: ((position?.speed ?? 0.01) * 3600) ~/ 1000));
        });
  }

  void startDriving() {
    var duration = Duration(seconds: selectedDelivery!.tripInfo.routes[0].duration.toInt());
    emit(TripRouteState(
      delivery: selectedDelivery!,
      route: selectedDelivery!.tripInfo.routes[0],
      distance: selectedDelivery!.tripInfo.routes[0].distance.toInt(),
      duration: selectedDelivery!.tripInfo.routes[0].duration.toInt(),
      time: DateTime.now().add(duration)
    ));

    // LocationSettings locationSettings = AndroidSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    //   forceLocationManager: true,
    //   intervalDuration: const Duration(seconds: 10),
    // );
    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    //   (Position? position) {
    //     emit((state as TripRouteState).copyWith(speed: position?.speed.toInt()));
    //     //print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}, ${position.speed.toString()}');
    //   });
  }

  void closeDriving() {
    /*final createdState = DeliverySelectionState(dataMarkers: _dataMarkers, deliveries: _deliveriesLoaded);

    emit(createdState);
    Future.delayed(const Duration(milliseconds: 250), () {
      emit(createdState.copyWith(isStartAppearanceAnimated: true));
    });*/
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
    print((await Geolocator.getCurrentPosition()).speed);
    return await Geolocator.getCurrentPosition();
  }
}