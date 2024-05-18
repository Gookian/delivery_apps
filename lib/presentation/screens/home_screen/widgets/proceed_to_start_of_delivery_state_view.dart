import 'package:delivery_apps/presentation/bloc/home_screen/home_cubit.dart';
import 'package:delivery_apps/presentation/bloc/home_screen/home_state.dart';
import 'package:delivery_apps/presentation/widgets/animated_floating_button.dart';
import 'package:delivery_apps/presentation/widgets/animated_text_in_circle.dart';
import 'package:delivery_apps/presentation/widgets/animated_vertical_box.dart';
import 'package:delivery_apps/presentation/widgets/custom_outlined_button_widget.dart';
import 'package:delivery_apps/presentation/widgets/text_with_hint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';

import '../../../widgets/animated_helper_delivery.dart';

class ProceedToStartOfDeliveryStateView extends StatelessWidget {
  final HomeCubit cubit;
  final ProceedToStartOfDeliveryState state;

  const ProceedToStartOfDeliveryStateView({
    super.key,
    required this.cubit,
    required this.state
  });


  Future<dynamic> _showCancelDeliveryDialog(BuildContext context, HomeCubit cubit) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Вы уверены, что хотите отменить выполнение доставки?"),
            content: const Text("Если вы отмените доставку, то вы не сможете выполнить ее."),
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
                  cubit.closeDriving();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  void _selectThemeMode(BuildContext context) async {
    await showThemePickerDialog(context: context);
  }

  String _getFormattedDistanceInKilometers(ProceedToStartOfDeliveryState state) =>
      '${(state.distance % 1000) > 0 ? state.distance ~/ 1000 : (state.distance / 1000).toStringAsFixed(1)}';

  String _getTimeTextByDateTime(ProceedToStartOfDeliveryState state) =>
      state.duration < 86400 ? DateFormat('HH:mm').format(state.time) : DateFormat('d MMM HH:mm').format(state.time);

  String _getStringTimeBySeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    int days = duration.inDays;
    int hours = duration.inHours.remainder(Duration.hoursPerDay);
    int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
    return '${days != 0 ? '$days:' : ''}${hours != 0 ? '$hours:' : ''}${'$minutes'}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: const AnimatedHelperDelivery(
                isStartAnimated: true,
                distance: 2500,
                street: "пер. Дербышевского",
                maneuver: ManeuverType.reversal
            )
        ),
        Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(20),
            child: AnimatedTextInCircle(isStartAnimated: true, text: state.speed.toString())
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
                    child: Column(
                      children: [
                        AnimatedFloatingButton(
                          onPressed: () {
                            _showCancelDeliveryDialog(context, cubit);
                          },
                          isStartAnimated: true,
                          iconData: Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        AnimatedFloatingButton(
                          onPressed: () {
                            // TODO добавить функционал чата
                          },
                          isStartAnimated: true,
                          iconData: Icons.chat_outlined,
                        ),
                        const SizedBox(height: 16),
                        AnimatedFloatingButton(
                          onPressed: () {
                            _selectThemeMode(context);
                          },
                          isStartAnimated: true,
                          iconData: Icons.style_outlined,
                        ),
                      ],
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
                                  ((cubit.mapKey.currentState?.animatedMapController.mapController.camera.zoom ?? 0) + 1.0)
                              );
                            },
                            isStartAnimated: true,
                            iconData: Icons.add,
                          ),
                          const SizedBox(height: 16),
                          AnimatedFloatingButton(
                            onPressed: () {
                              cubit.mapKey.currentState?.animatedMapController.animatedZoomTo(
                                  ((cubit.mapKey.currentState?.animatedMapController.mapController.camera.zoom ?? 0) - 1.0)
                              );
                            },
                            isStartAnimated: true,
                            iconData: Icons.remove,
                          ),
                          const SizedBox(height: 32),
                          AnimatedFloatingButton(
                            onPressed: () {
                              cubit.determinePosition().then((value) {
                                cubit.mapKey.currentState?.animatedMapController.animateTo(
                                    dest: LatLng(value.latitude, value.longitude),
                                    zoom: 17,
                                    rotation: value.heading
                                );
                              });
                            },
                            isStartAnimated: true,
                            iconData: Icons.place_rounded,
                          ),
                        ],
                      )
                  ),
                ],
              ),
              /*AnimatedScale(
                  duration: const Duration(seconds: 1),
                  curve: Curves.bounceIn,
                  scale: 1,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomOutlinedButtonWidget(onPressed: () {}, child: Text("Прибыл в пункт погрузки"))
                          )
                      )
                  )
              )*/

              // AnimatedVerticalBox(
              //     isStartAnimated: true,
              //     children: [
              //       TextWithHint(text: '3:44', hint: 'время ожидания'),
              //       SizedBox(width: 16),
              //       Expanded(
              //         child: CustomOutlinedButtonWidget(onPressed: () {}, child: Text("Посмотреть товар")),
              //       )
              //     ]
              // )
              /*AnimatedVerticalBox(
                  isStartAnimated: true,
                  children: [
                    TextWithHint(text: '3 часа 44 минуты', hint: 'затрачено времени'),
                    TextWithHint(text: '365 км', hint: 'пройдено'),
                  ]
              ),
              AnimatedVerticalBox(
                  isStartAnimated: true,
                  children: [
                    Expanded(
                      child: CustomOutlinedButtonWidget(onPressed: () {}, child: Text("Груз доставлен")),
                    )
                  ]
              )*/
              AnimatedVerticalBox(
                  isStartAnimated: true,
                  children: [
                    state.duration < 3540 ?
                    TextWithHint(text: (state.duration / 60).toStringAsFixed(0), hint: 'м') :
                    TextWithHint(text: _getStringTimeBySeconds(state.duration), hint: 'ч'),
                    TextWithHint(text: _getTimeTextByDateTime(state), hint: 'прибытие'),
                    state.distance < 1000 ?
                    TextWithHint(text: '${state.distance}', hint: 'м') :
                    TextWithHint(text: _getFormattedDistanceInKilometers(state), hint: 'км')
                  ]
              )
            ],
          ),
        ),
      ],
    );
  }
}