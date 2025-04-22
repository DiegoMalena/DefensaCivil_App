import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Participante {
  final String nombre;
  final String rol;
  final String telefono;
  final String telegram;
  final String fotoAsset;

  Participante({
    required this.nombre,
    required this.rol,
    required this.telefono,
    required this.telegram,
    required this.fotoAsset,
  });
}

class AcercaDeScreen extends StatelessWidget {
  AcercaDeScreen({Key? key}) : super(key: key);

  final Participante diego = Participante(
    nombre: 'Diego Malena',
    rol: 'Desarrollador Principal',
    telefono: '8298271154',
    telegram: 'https://t.me/diegomalena31',
    fotoAsset: 'assets/images/foto.jpeg',
  );

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = diego;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(p.fotoAsset),
                ),
                const SizedBox(height: 12),
                Text(p.nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(p.rol, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _launchUrl("tel:${p.telefono}"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () => _launchUrl(p.telegram),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
