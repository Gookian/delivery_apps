import 'package:delivery_apps/presentation/providers/authentication_provider.dart';
import 'package:delivery_apps/presentation/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ThemeModeHandler(
      manager: ThemeModeManager(),
      placeholderWidget: const Center(
        child: CircularProgressIndicator(),
      ),
      builder: (ThemeMode themeMode) {
        return MaterialApp(
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ).copyWith(
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 20,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.primary
                ),
                bodyMedium: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.secondary
                ),
                bodySmall: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.secondary
                ),
                titleMedium: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 28,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.primary
                ),
                headlineSmall: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 26,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.primary
                ),
                titleLarge: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 26,
                    color: ThemeData.dark(useMaterial3: true).colorScheme.primary
                ),
              ),
            ),
            themeMode: themeMode,
            theme: ThemeData.light(
              useMaterial3: true,
            ).copyWith(
              textTheme: TextTheme(
                  bodyLarge: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      color: ThemeData.light(useMaterial3: true).colorScheme.primary
                  ),
                  bodyMedium: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      color: ThemeData.light(useMaterial3: true).colorScheme.secondary
                  ),
                  bodySmall: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      color: ThemeData.light(useMaterial3: true).colorScheme.secondary
                  ),
                  titleMedium: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 28,
                      color: ThemeData.light(useMaterial3: true).colorScheme.primary
                  ),
                  headlineSmall: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 26,
                      color: ThemeData.light(useMaterial3: true).colorScheme.primary
                  ),
                  titleLarge: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 26,
                      color: ThemeData.light(useMaterial3: true).colorScheme.primary
                  ),
              ),
            ),
            home: const AuthenticationProvider()
        );
      }
    )
  );
}

class ThemeModeManager implements IThemeModeManager {
  String theme = 'ThemeMode.light';//${SchedulerBinding.instance.platformDispatcher.platformBrightness}';

  @override
  Future<String?> loadThemeMode() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return theme;
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    theme = value;

    return true;
  }
}