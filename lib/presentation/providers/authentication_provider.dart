import 'package:delivery_apps/presentation/bloc/authentication_screen/authentication_cubit.dart';
import 'package:delivery_apps/presentation/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationProvider extends StatelessWidget {
  const AuthenticationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (context) => AuthenticationCubit(),
      child: AuthenticationScreen(),
    );
  }
}
