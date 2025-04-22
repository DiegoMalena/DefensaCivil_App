import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/albergue.dart';

class AlbergueScreen extends StatefulWidget {
  const AlbergueScreen({super.key});

  @override
  State<AlbergueScreen> createState() => _AlbergueScreenState();
}

class _AlbergueScreenState extends State<AlbergueScreen> {
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  List<Albergue> _albergues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbergues();
  }

  Future<void> _fetchAlbergues() async {
    try {
      final response = await http.get(
          Uri.parse("https://adamix.net/defensa_civil/def/albergues.php"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List alberguesJson = data['datos'];

        final albergues = alberguesJson.map((json) {
          final albergue = Albergue.fromJson(json);
          print("Albergue: ${albergue.edificio}, Lat: ${albergue.lat}, Lng: ${albergue.lng}");
          return albergue;
        }).toList();

        setState(() {
          _albergues = albergues.cast<Albergue>();
          _markers.addAll(_albergues.map((a) => Marker(
                markerId: MarkerId(a.codigo),
                position: LatLng(a.lng, a.lat), // Intercambio de lat y lng aquí
                infoWindow: InfoWindow(
                  title: a.edificio,
                  snippet: 'Coordinador: ${a.coordinador}',
                  onTap: () => _mostrarDetalles(a),
                ),
              )));
          _isLoading = false;
        });

        // Ajustar la cámara para mostrar todos los marcadores
        if (_markers.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _mapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                _boundsFromMarkers(),
                50.0, // padding
              ),
            );
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los albergues')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  LatLngBounds _boundsFromMarkers() {
    double? minLat, maxLat, minLng, maxLng;
    _markers.forEach((marker) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;
      minLat = minLat == null ? lat : (lat < minLat! ? lat : minLat);
      maxLat = maxLat == null ? lat : (lat > maxLat! ? lat : maxLat);
      minLng = minLng == null ? lng : (lng < minLng! ? lng : minLng);
      maxLng = maxLng == null ? lng : (lng > maxLng! ? lng : maxLng);
    });
    return LatLngBounds(
      northeast: LatLng(maxLat!, maxLng!),
      southwest: LatLng(minLat!, minLng!),
    );
  }

  void _mostrarDetalles(Albergue a) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a.edificio),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ciudad: ${a.ciudad}"),
              const SizedBox(height: 8),
              Text("Coordinador: ${a.coordinador}"),
              const SizedBox(height: 8),
              Text("Teléfono: ${a.telefono}"),
              const SizedBox(height: 8),
              Text("Capacidad: ${a.capacidad}"),
              const SizedBox(height: 8),
              Text("Código: ${a.codigo}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Albergues"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(18.5, -71.2), // Coordenadas iniciales de República Dominicana
                zoom: 8,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
    );
  }
}