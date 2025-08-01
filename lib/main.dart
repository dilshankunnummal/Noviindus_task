import 'package:ayurveda_patients_app/presentation/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: (context, child) {
        // Wrap the Navigator subtree with your providers
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => PatientProvider()),
          ],
          child: child!,
        );
      },
    );
  }
}
