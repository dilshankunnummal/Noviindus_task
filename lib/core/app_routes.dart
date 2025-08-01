import 'package:ayurveda_patients_app/presentation/screens/home_screen.dart';
import 'package:ayurveda_patients_app/presentation/screens/login_screen.dart';
import 'package:ayurveda_patients_app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        final args = settings.arguments;
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(token: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Page not found')),
      ),
    );
  }
}
