import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/auth/auth_service.dart';



class ReportarSituacionScreen extends StatefulWidget {
  const ReportarSituacionScreen({super.key});

  @override
  _ReportarSituacionScreenState createState() => _ReportarSituacionScreenState();
}

class _ReportarSituacionScreenState extends State<ReportarSituacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _foto;
  String? _latitud;
  String? _longitud;
  bool _isLoading = false;
  bool _ubicacionObtenida = false;
  bool _fotoTomada = false;

  Future<void> _tomarFoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _foto = File(pickedFile.path);
          _fotoTomada = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto: ${e.toString()}')),
      );
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _isLoading = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Por favor active el GPS en su dispositivo';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && 
            permission != LocationPermission.always) {
          throw 'Permiso de ubicación requerido para reportar situaciones';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      setState(() {
        _latitud = position.latitude.toStringAsFixed(6);
        _longitud = position.longitude.toStringAsFixed(6);
        _ubicacionObtenida = true;
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _enviarReporte() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;
    
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe iniciar sesión para reportar')),
      );
      return;
    }
    
    if (!_fotoTomada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor tome una foto de la situación')),
      );
      return;
    }
    
    if (!_ubicacionObtenida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor obtenga su ubicación actual')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<int> imageBytes = await _foto!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('https://adamix.net/defensa_civil/def/nueva_situacion.php'),
        body: {
          'token': token,
          'titulo': _tituloController.text,
          'descripcion': _descripcionController.text,
          'foto': base64Image,
          'latitud': _latitud!,
          'longitud': _longitud!,
        },
      ).timeout(const Duration(seconds: 30));

      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['exito'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['mensaje'])),
        );
        Navigator.pop(context);
      } else {
        throw jsonResponse['mensaje'] ?? 'Error al enviar el reporte';
      }
    } on http.ClientException catch (e) {
      if (e.message.contains('401')) {
        authService.logout();
        Navigator.pushReplacementNamed(context, '/login');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticación: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Situación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value!.isEmpty ? 'Ingrese un título' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _tomarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar Foto'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              if (_fotoTomada) ...[
                const SizedBox(height: 10),
                Text(
                  'Foto tomada',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_foto!, height: 150, fit: BoxFit.cover),
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _obtenerUbicacion,
                icon: const Icon(Icons.location_on),
                label: const Text('Obtener Ubicación'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              if (_ubicacionObtenida) ...[
                const SizedBox(height: 10),
                Text(
                  'Ubicación obtenida',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Coordenadas:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text('Latitud: $_latitud'),
                        Text('Longitud: $_longitud'),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _enviarReporte,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}