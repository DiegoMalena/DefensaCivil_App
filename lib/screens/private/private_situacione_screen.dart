import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mi_app/auth/auth_service.dart';
import 'package:mi_app/screens/private/detalles_screen.dart';


class MisSituacionesScreen extends StatefulWidget {
  const MisSituacionesScreen({super.key});

  @override
  _MisSituacionesScreenState createState() => _MisSituacionesScreenState();
}

class _MisSituacionesScreenState extends State<MisSituacionesScreen> {
  List<dynamic> _situaciones = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarSituaciones();
  }

  Future<void> _cargarSituaciones() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Debe iniciar sesión para ver sus situaciones';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://adamix.net/defensa_civil/def/situaciones.php'),
        body: {'token': token},
      ).timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if (data['exito'] == true) {
        setState(() {
          _situaciones = data['datos'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = data['mensaje'] ?? 'Error al cargar situaciones';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error de conexión: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Situaciones Reportadas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarSituaciones,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _situaciones.isEmpty
                  ? const Center(child: Text('No has reportado situaciones aún'))
                  : ListView.builder(
                      itemCount: _situaciones.length,
                      itemBuilder: (context, index) {
                        final situacion = _situaciones[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: situacion['foto'] != null
                                ? Image.memory(
                                    base64.decode(situacion['foto']),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.photo),
                            title: Text(situacion['titulo'] ?? 'Sin título'),
                            subtitle: Text(
                              situacion['fecha_creacion'] ?? 'Fecha desconocida',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleSituacionScreen(
                                    situacion: situacion,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}