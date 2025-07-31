import 'package:ayurveda_patients_app/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/login';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
  };
}
