import 'package:flutter/material.dart';
import 'package:mi_app/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Espera 2 segundos y navega a la pantalla principal
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.publicHome);
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/defensa_civil_logo.png'),
      ),
    );
  }
}
