import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/auth/auth_service.dart';
import 'package:mi_app/widgets/appdrawer.dart'; 

class PrivateHomeScreen extends StatelessWidget {
  const PrivateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final String username = authService.username; // Obtenemos el nombre del usuario

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio Privado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/public-home', (route) => false);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_open, size: 48),
                SizedBox(height: 16),
                Text(
                  '¡Hola, $username!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bienvenido a la sección privada de la app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
