import 'package:delivery_apps/presentation/animates/spring_curve.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_cubit.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_state.dart';
import 'package:delivery_apps/presentation/widgets/animated_floating_button.dart';
import 'package:delivery_apps/presentation/widgets/custom_outlined_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';

class DeliverySelectionStateView extends StatelessWidget {
  final HomeCubit cubit;
  final DeliverySelectionState state;

  const DeliverySelectionStateView({
    super.key,
    required this.cubit,
    required this.state
  });

  void _selectThemeMode(BuildContext context) async {
    await showThemePickerDialog(context: context);
  }

  Future<dynamic> _showStartDeliveryDialog(BuildContext context, HomeCubit cubit) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Вы уверены, что хотите начать доставку?"),
            content: const Text("После начала доставки у вас будет 10 минут на отмену, если понадобится. По истечении времени вы не сможете отменить доставку без связи с оператором через чат."),
            actions: [
              TextButton(
                child: const Text("Отменить"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Продолжить"),
                onPressed: () {
                  cubit.startProceedToStartOfDelivery();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  void _openBottomBar(BuildContext context, HomeCubit cubit) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext contextModal) {
          return Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(20.0),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                  child: ListView.separated(
                    itemCount: cubit.deliveries.length,
                    itemBuilder: (BuildContext context, int index) {
                      Delivery delivery = cubit.deliveries[index];
                      Duration duration = Duration(seconds: delivery.tripInfo.routes[0].duration.toInt());
                      int days = duration.inDays;
                      int hours = duration.inHours.remainder(Duration.hoursPerDay);
                      int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
                      var timeRoute = '${days != 0 ? '$days д. ' : ''}${hours != 0 ? '$hours час. ' : ''}${minutes != 0 ? '$minutes мин.' : ''}';

                      final distance = delivery.tripInfo.routes[0].distance;
                      final distanceFormat = distance < 1000 ? '$distance м' : '${distance ~/ 1000} км';

                      return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: Text(delivery.from.name, style: Theme.of(context).textTheme.titleMedium)),
                                  Expanded(
                                    child: Icon(Icons.arrow_forward_rounded, size: 30, color: Theme.of(context).colorScheme.secondary),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(delivery.to.name, style: Theme.of(context).textTheme.titleMedium),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Дистанция:", style: Theme.of(context).textTheme.bodyLarge),
                                      Text(distanceFormat, style: Theme.of(context).textTheme.bodySmall)
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Продолжительность:", style: Theme.of(context).textTheme.bodyLarge),
                                      Text(timeRoute, style: Theme.of(context).textTheme.bodySmall)
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Временной каридор доставки:", style: Theme.of(context).textTheme.bodyLarge),
                                  Text("31.12.2024 12:55-13:20", style: Theme.of(context).textTheme.bodySmall)
                                ],
                              ),
                              const SizedBox(height: 16),
                              CustomOutlinedButtonWidget(
                                onPressed: () {
                                  cubit.openRoute(index);
                                  final zoom = cubit.getZoomByRectangleRoutes();
                                  cubit.mapKey.currentState?.animatedMapController.animateTo(
                                    zoom: zoom,
                                  );
                                  Future.delayed(const Duration(milliseconds: 900), () {
                                    final point = cubit.findCenterRectangleRoutes();
                                    cubit.mapKey.currentState?.animatedMapController.animateTo(
                                        dest: point,
                                        zoom: zoom,
                                        rotation: 0
                                    );
                                  });
                                  Navigator.pop(context);
                                },
                                isOutlined: true,
                                child: const Text("Посмотреть"),
                              )
                            ],
                          )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.symmetric(vertical: 32),
                          height: 2,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20)
                          )
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _buildBottomBar(DeliverySelectionState state, BuildContext context, HomeCubit cubit) {
    if (state.selectedDelivery == null) {
      return AnimatedScale(
        duration: const Duration(seconds: 1),
        curve: const SpringCurve(),
        scale: state.isStartAppearanceAnimated || (!state.isSelectedAnimated == false) ? 1 : 0,
        child: Container(
            margin: const EdgeInsets.all(20),
            child: ClipRRect(
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomOutlinedButtonWidget(
                    onPressed: () {
                      _openBottomBar(context, cubit);
                    },
                    isOutlined: false,
                    child: const Text("Доступные доставки"),
                  ),
                ),
              ),
            )
        ),
      );
    } else {
      Duration duration = Duration(seconds: state.selectedDelivery!.tripInfo.routes[0].duration.toInt());
      int days = duration.inDays;
      int hours = duration.inHours.remainder(Duration.hoursPerDay);
      int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
      var timeRoute = '${days != 0 ? '$days д. ' : ''}${hours != 0 ? '$hours час. ' : ''}${minutes != 0 ? '$minutes мин.' : ''}';
      final distance = state.selectedDelivery!.tripInfo.routes[0].distance;
      final distanceFormat = distance < 1000 ? '$distance м' : '${distance ~/ 1000} км';

      return AnimatedScale(
        duration: const Duration(seconds: 1),
        curve: const SpringCurve(),
        scale: state.isSelectedAnimated ? 1 : 0,
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: Text(state.selectedDelivery!.from.name, style: Theme.of(context).textTheme.titleMedium)),
                        Expanded(
                          child: Icon(Icons.arrow_forward_rounded, size: 30, color: Theme.of(context).colorScheme.secondary),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(state.selectedDelivery!.to.name, style: Theme.of(context).textTheme.titleMedium),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Дистанция:", style: Theme.of(context).textTheme.bodyLarge),
                            Text(distanceFormat, style: Theme.of(context).textTheme.bodySmall)
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Продолжительность:", style: Theme.of(context).textTheme.bodyLarge),
                            Text(timeRoute, style: Theme.of(context).textTheme.bodySmall)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Временной каридор доставки:", style: Theme.of(context).textTheme.bodyLarge),
                        Text("12.06.2024 12:55-13:20", style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomOutlinedButtonWidget(
                      onPressed: () {
                        _showStartDeliveryDialog(context, cubit);
                      },
                      isOutlined: true,
                      child: const Text("Начать доставку"),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.selectedDelivery != null ?
                AnimatedFloatingButton(
                  onPressed: () {
                    cubit.determinePosition().then((value) {
                      cubit.closeRoute();
                    });
                  },
                  isStartAnimated: state.isSelectedAnimated,
                  iconData: Icons.arrow_back_rounded,
                ) : Container(),
                state.selectedDelivery != null ? const SizedBox(height: 16) : Container(),
                AnimatedFloatingButton(
                  onPressed: () {
                    cubit.determinePosition().then((value) {
                      // TODO Добавить функционал поиска складов, сорт. центров и ПВЗ
                    });
                  },
                  isStartAnimated: state.isStartAppearanceAnimated,
                  iconData: Icons.search,
                ),
              ],
            )
        ),
        Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimatedFloatingButton(
                  onPressed: () {
                    cubit.determinePosition().then((value) {
                      cubit.mapKey.currentState?.animatedMapController.animatedRotateReset();
                    });
                  },
                  isStartAnimated: state.isStartAppearanceAnimated,
                  iconData: Icons.compass_calibration,
                ),
                const SizedBox(height: 16),
                AnimatedFloatingButton(
                  onPressed: () {
                    cubit.determinePosition().then((value) {
                      cubit.mapKey.currentState?.animatedMapController.animateTo(
                          dest: LatLng(value.latitude, value.longitude),
                          zoom: 17,
                          rotation: value.headingAccuracy
                      );
                    });
                  },
                  isStartAnimated: state.isStartAppearanceAnimated,
                  iconData: Icons.place_rounded,
                ),
              ],
            )
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: AnimatedFloatingButton(
                      onPressed: () {
                        _selectThemeMode(context);
                      },
                      isStartAnimated: state.isStartAppearanceAnimated,
                      iconData: Icons.style_outlined,
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedFloatingButton(
                            onPressed: () {
                              cubit.mapKey.currentState?.animatedMapController.animatedZoomTo(
                                  ((cubit.mapKey.currentState?.animatedMapController.mapController.camera.zoom ?? 0) + 1.0));
                            },
                            isStartAnimated: state.isStartAppearanceAnimated,
                            iconData: Icons.add,
                          ),
                          const SizedBox(height: 16),
                          AnimatedFloatingButton(
                            onPressed: () {
                              cubit.mapKey.currentState?.animatedMapController.animatedZoomTo(
                                  ((cubit.mapKey.currentState?.animatedMapController.mapController.camera.zoom ?? 0) - 1.0));
                            },
                            isStartAnimated: state.isStartAppearanceAnimated,
                            iconData: Icons.remove,
                          ),
                        ],
                      )
                  ),
                ],
              ),
              _buildBottomBar(state, context, cubit)
            ],
          ),
        ),
      ],
    );
  }
}