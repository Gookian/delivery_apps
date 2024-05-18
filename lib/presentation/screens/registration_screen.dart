import 'package:delivery_apps/presentation/bloc/registration_screen/registration_cubit.dart';
import 'package:delivery_apps/presentation/bloc/registration_screen/registration_state.dart';
import 'package:delivery_apps/presentation/providers/authentication_provider.dart';
import 'package:delivery_apps/presentation/screens/home_screen/widgets/loading_state_view.dart';
import 'package:delivery_apps/presentation/widgets/custom_outlined_button_widget.dart';
import 'package:delivery_apps/presentation/widgets/custom_text_from_field_widget.dart';
import 'package:delivery_apps/util/exceptions/network/conflict_user_exception.dart';
import 'package:delivery_apps/util/exceptions/network/not_internet_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _loginFieldKey = GlobalKey<CustomTextFromFieldWidgetState>();
  final _passwordFieldKey = GlobalKey<CustomTextFromFieldWidgetState>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<RegistrationCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Регистрация",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<RegistrationCubit, RegistrationState>(
            builder: (contextBloc, state) {
              if (state is RegistrationLoadingState) {
                return const LoadingStateView();
              }

              return Container();
            }
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFromFieldWidget(
                    key: _loginFieldKey,
                    title: 'Логин',
                    labelText: 'Введите логин',
                    hintText: 'Gookian',
                    prefixIcon: Icon(Icons.login, size: 30, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
                    validator: (value) {
                      if (value == null) return "null";
                      if (value.isEmpty) return "Логин не может быть пустым!";
                      if (!RegExp(r'^[A-Za-z0-9]{3,}$').hasMatch(value)) return "Логин должен содержать минимум 3\nсимвола!";
                      if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) return "Логин должен содержать только\nсимволы!";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFromFieldWidget(
                    key: _passwordFieldKey,
                    title: 'Пароль',
                    labelText: 'Введите пароль',
                    hintText: 'fu9d8ys@kjdhs',
                    prefixIcon: Icon(Icons.password, size: 30, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
                    isObscureText: true,
                    validator: (value) {
                      if (value == null) return "null";
                      if (value.isEmpty) return "Пароль не может быть пустым!";
                      if (!value.contains(RegExp(r'^(\D*\d\D*){3,}$'))) return "Пароль дложен содержать минимум 3\nцыфры!";
                      if (!value.contains(RegExp(r'^(.*[!@#\$%\^\&*\)\(+=._-].*){1,}$'))) return "Пароль дложен содержать минимум 1\nспецальный символ!";
                      if (!RegExp(r'^[a-zA-Zа-яА-Я0-9!@#\$%\^\&*\)\(+=._-]{6,}$').hasMatch(value)) return "Пароль должен содержать минимиум 6\nсимволов!";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFromFieldWidget(
                    title: 'Подтверждение пароля',
                    labelText: 'Введите пароль повторно',
                    hintText: 'fu9d8ys@kjdhs',
                    prefixIcon: Icon(Icons.password, size: 30, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
                    isObscureText: true,
                    validator: (value) {
                      if (value == null) return "null";
                      if (value.isEmpty) return "Поле не может быть пустым!";
                      if (value != _passwordFieldKey.currentState!.controller.text) return "Пароли не совпадают!";
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomOutlinedButtonWidget(onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      final login = _loginFieldKey.currentState?.controller.text ?? "";
                      final password = _passwordFieldKey.currentState?.controller.text ?? "";

                      cubit.registration(login, password).then((value) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const AuthenticationProvider())
                        );
                      }).catchError((exception) {
                        _showNetworkError(exception, context);
                      });
                    }
                  }, child: const Text("Зарегистрироваться")),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 32),
                          GestureDetector(
                            child: Text(
                                "Перейти к авторизации",
                                style: Theme.of(context).textTheme.bodySmall
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const AuthenticationProvider())
                              );
                            },
                          )
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  void _showNetworkError(dynamic exception, BuildContext context) {
    print(exception.runtimeType);
    switch (exception.runtimeType) {
      case NotInternetException:
        final castException = exception as NotInternetException;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Сетевая ошибка - ${castException.statusCode}"),
                content: Text(castException.message),
                actions: [
                  TextButton(
                    child: const Text("Продолжить"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
        break;
      case ConflictUserException:
        final castException = exception as ConflictUserException;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Сетевая ошибка - ${castException.statusCode}"),
                content: Text(castException.networkError.message),
                actions: [
                  TextButton(
                    child: const Text("Продолжить"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
        break;
      default:
        break;
    }
  }
}