import 'package:delivery_apps/presentation/bloc/registration_screen/registration_cubit.dart';
import 'package:delivery_apps/presentation/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationProvider extends StatelessWidget {
  const RegistrationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationCubit>(
      create: (context) => RegistrationCubit(),
      child: RegistrationScreen(),
    );
  }
}
