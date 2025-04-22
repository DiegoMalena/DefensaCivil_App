import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/miembro.dart';

class MiembroScreen extends StatefulWidget {
  const MiembroScreen({Key? key}) : super(key: key);

  @override
  _MiembroScreenState createState() => _MiembroScreenState();
}

class _MiembroScreenState extends State<MiembroScreen> {
  List<Miembro> miembros = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarMiembros();
  }

  Future<void> cargarMiembros() async {
    final url = Uri.parse("https://adamix.net/defensa_civil/def/miembros.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List datos = data['datos'];

      setState(() {
        miembros = datos.map((item) => Miembro.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      throw Exception("Error al cargar los miembros");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Miembros"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: miembros.length,
              itemBuilder: (context, index) {
                final miembro = miembros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(miembro.foto),
                    ),
                    title: Text(miembro.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(miembro.cargo),
                    trailing: const Icon(Icons.verified_user, color: Colors.orange),
                  ),
                );
              },
            ),
    );
  }
}
