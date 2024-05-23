import 'dart:math';

import 'package:delivery_apps/presentation/screens/home_screen/widgets/delivery_selection_state_view.dart';
import 'package:delivery_apps/presentation/screens/home_screen/widgets/loading_state_view.dart';
import 'package:delivery_apps/presentation/screens/home_screen/widgets/proceed_to_start_of_delivery_state_view.dart';
import 'package:delivery_apps/presentation/screens/home_screen/widgets/trip_route_state_view.dart';
import 'package:delivery_apps/presentation/widgets/custom_location_marker.dart';
import 'package:delivery_apps/util/extensions/polyline_extension.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_cubit.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_state.dart';
import 'package:delivery_apps/presentation/widgets/animated_flutter_map_widget.dart';
import 'package:delivery_apps/presentation/widgets/cluster_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Marker> _buildMarkers(List<MarkerData> dataMarkers) {
    return List.generate(
      dataMarkers.length,
      (index) => Marker(
        point: dataMarkers[index].data.position,
        child: Icon(
            dataMarkers[index].icon,
            color: dataMarkers[index].color,
            size: dataMarkers[index].size.width
        ),
        width: dataMarkers[index].size.width,
        height: dataMarkers[index].size.height,
        alignment: dataMarkers[index].alignment,
      ),
    );
  }

  List<Polyline> _buildPolylines(Delivery delivery, {int selectRouteIndex = 0, bool isDriving = false}) {
    return List.generate(
      delivery.tripInfo.routes.length,
      (index) => Polyline(
        points: decodePolyline(delivery.tripInfo.routes[index].geometry).unpackPolyline(),
        color: index == selectRouteIndex ? Colors.blue[200] ?? Colors.grey : Colors.red[200] ?? Colors.grey,
        strokeWidth: isDriving ? 5 : 8,
        borderColor: index == selectRouteIndex ? Colors.blue : Colors.red,
        borderStrokeWidth: 3,
        isDotted: isDriving ? false : true,
      ),
    );
  }

  Polyline _buildPolyline(String geometry) {
    return Polyline(
      points: decodePolyline(geometry).unpackPolyline(),
      color: Colors.blue[200] ?? Colors.blue,
      strokeWidth: 5,
      borderColor: Colors.blue,
      borderStrokeWidth: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is DeliverySelectionState) {
                return AnimatedFlutterMap(
                  key: cubit.mapKey,
                  options: MapOptions(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    initialCenter: const LatLng(55.755793, 37.617134),
                    initialZoom: 8,
                    minZoom: 4,
                    maxZoom: 20,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: ThemeModeHandler.of(context)?.themeMode == ThemeMode.light ?
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png' :
                      'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f',
                      userAgentPackageName: 'com.example.flutter_map_example',
                    ),
                    PolylineLayer(
                      polylineCulling: true,
                      polylines: state.selectedDelivery != null ? _buildPolylines(state.selectedDelivery!).reversed.toList() : [],
                    ),
                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        size: const Size(50, 50),
                        rotate: true,
                        maxClusterRadius: 50,
                        markers: _buildMarkers(state.dataMarkers),
                        onMarkerTap: (marker) {
                          cubit.addAnimatedMarker(AnimatedMarker(
                            point: marker.point,
                            width: 250.0,
                            height: 150.0,
                            alignment: marker.alignment,
                            builder: (_, animation) {
                              final width = 350.0 * animation.value;
                              final height = 250.0 * animation.value;
                              return Transform.translate(
                                offset: const Offset(0, 50),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Какой-то заголовок", style: Theme.of(context).textTheme.bodyLarge),
                                      Text("Какой-то текст", style: Theme.of(context).textTheme.bodySmall)
                                    ],
                                  )
                                ),
                              );
                            },
                          ));
                        },
                        builder: (_, markers) {
                          return ClusterMarker(
                            markersLength: markers.length.toString(),
                          );
                        },
                      ),
                    ),
                    AnimatedMarkerLayer(
                        markers: state.animatedMarkers
                    ),
                    CurrentLocationLayer(
                      alignPositionOnUpdate: AlignOnUpdate.never,
                      alignDirectionOnUpdate: AlignOnUpdate.never,
                      style: const LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(Icons.navigation, color: Colors.white),
                        ),
                        markerSize: Size(40, 40),
                        headingSectorRadius: 5,
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),
                  ],
                );
              }

              if (state is ProceedToStartOfDeliveryState) {
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4(
                      1,0,0,0,
                      0,1,0,0,
                      0,0,1,0.002,
                      0,-318,0,1/1.304
                  )..rotateX(-(3.14 / 5)),
                  child: AnimatedFlutterMap(
                    key: cubit.mapKey,
                    options: MapOptions(
                        backgroundColor: Theme.of(context).colorScheme.onSecondary,
                        initialCenter: const LatLng(55.755793, 37.617134),
                        initialZoom: 15,
                        minZoom: 15,
                        maxZoom: 20
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: ThemeModeHandler.of(context)?.themeMode == ThemeMode.light ?
                        'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f' :
                        'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f',//'https://api.maptiler.com/maps/streets-v2-pastel/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f',
                        userAgentPackageName: 'com.example.flutter_map_example',
                      ),
                      PolylineLayer(
                        polylineCulling: true,
                        polylines: [_buildPolyline(state.route.geometry)],
                      ),
                      CurrentLocationLayer(
                        alignPositionOnUpdate: AlignOnUpdate.always,
                        alignDirectionOnUpdate: AlignOnUpdate.always,
                        headingStream: cubit.getHeadingStream(),
                        focalPoint: const FocalPoint(offset: Point<double>(0, 450.0)),
                        style: LocationMarkerStyle(
                          marker: const CustomLocationMarker(
                            child: Icon(Icons.navigation, color: Colors.white, size: 5),
                          ),
                          markerSize: const Size(10, 10),
                          headingSectorColor: Colors.blue.withOpacity(0.5),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is TripRouteState) {
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4(
                      1,0,0,0,
                      0,1,0,0,
                      0,0,1,0.002,
                      0,-318,0,1/1.304
                  )..rotateX(-(3.14 / 5)),
                  child: AnimatedFlutterMap(
                    key: cubit.mapKey,
                    options: MapOptions(
                        backgroundColor: Theme.of(context).colorScheme.onSecondary,
                        initialCenter: const LatLng(55.755793, 37.617134),
                        initialZoom: 15,
                        minZoom: 15,
                        maxZoom: 20
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: ThemeModeHandler.of(context)?.themeMode == ThemeMode.light ?
                        'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f' :
                        'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f',//'https://api.maptiler.com/maps/streets-v2-pastel/{z}/{x}/{y}.png?key=cxtTD4eNN9Fab1HQqF9f',
                        userAgentPackageName: 'com.example.flutter_map_example',
                      ),
                      PolylineLayer(
                        polylineCulling: true,
                        polylines: [_buildPolylines(state.delivery, isDriving: true)[0]],
                      ),
                      CurrentLocationLayer(
                        alignPositionOnUpdate: AlignOnUpdate.always,
                        alignDirectionOnUpdate: AlignOnUpdate.always,
                        headingStream: cubit.getHeadingStream(),
                        focalPoint: const FocalPoint(offset: Point<double>(0, 450.0)),
                        style: LocationMarkerStyle(
                          marker: const CustomLocationMarker(
                            child: Icon(Icons.navigation, color: Colors.white, size: 5),
                          ),
                          markerSize: const Size(10, 10),
                          headingSectorColor: Colors.blue.withOpacity(0.5),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return AnimatedFlutterMap(
                key: cubit.mapKey,
                options: MapOptions(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  initialCenter: const LatLng(55.755793, 37.617134),
                  initialZoom: 8,
                  minZoom: 4,
                  maxZoom: 20,
                  onMapReady: () {
                    cubit.load();
                  }
                ),
                children: const []
              );
            }
          ),
          SafeArea(
            child: Stack(
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                    builder: (contextBloc, state) {
                      if (state is HomeLoadingState) {
                        return const LoadingStateView();
                      }

                      if (state is ProceedToStartOfDeliveryState) {
                        return ProceedToStartOfDeliveryStateView(cubit: cubit, state: state);
                      }

                      if (state is DeliverySelectionState) {
                        return DeliverySelectionStateView(cubit: cubit, state: state);
                      }

                      if (state is TripRouteState) {
                        return TripRouteStateView(cubit: cubit, state: state);
                      }

                      return Container();
                    }
                )
              ],
            )
          )
        ],
      )
    );
  }
}