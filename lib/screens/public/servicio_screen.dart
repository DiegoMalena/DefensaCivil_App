import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/servicio.dart';

class ServicioScreen extends StatefulWidget {
  const ServicioScreen({Key? key}) : super(key: key);

  @override
  State<ServicioScreen> createState() => _ServicioScreenState();
}

class _ServicioScreenState extends State<ServicioScreen> {
  late Future<List<Servicio>> _servicios;

  Future<List<Servicio>> fetchServicios() async {
    final url = Uri.parse('https://adamix.net/defensa_civil/def/servicios.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List serviciosJson = jsonData['datos'];
      return serviciosJson.map((e) => Servicio.fromJson(e)).toList();
    } else {
      throw Exception('Fallo al cargar los servicios');
    }
  }

  @override
  void initState() {
    super.initState();
    _servicios = fetchServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Servicio>>(
        future: _servicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay servicios disponibles.'));
          } else {
            final servicios = snapshot.data!;
            return ListView.builder(
              itemCount: servicios.length,
              itemBuilder: (context, index) {
                final servicio = servicios[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(servicio.foto, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(servicio.nombre,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(servicio.descripcion),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
