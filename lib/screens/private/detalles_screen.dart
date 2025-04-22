import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class DetalleSituacionScreen extends StatefulWidget {
  final Map<String, dynamic> situacion;

  const DetalleSituacionScreen({super.key, required this.situacion});

  @override
  State<DetalleSituacionScreen> createState() => _DetalleSituacionScreenState();
}

class _DetalleSituacionScreenState extends State<DetalleSituacionScreen> {
  late GoogleMapController mapController;
  late LatLng ubicacion;
  bool _coordenadasValidas = true;

  @override
  void initState() {
    super.initState();
    // Convertir y validar coordenadas
    final lat = double.tryParse(widget.situacion['latitud'] ?? '');
    final lng = double.tryParse(widget.situacion['longitud'] ?? '');
    
    if (lat == null || lng == null) {
      _coordenadasValidas = false;
      ubicacion = const LatLng(0, 0); // Valor por defecto
    } else {
      ubicacion = LatLng(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final situacion = widget.situacion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Situación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _compartirSituacion,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de la situación
            if (situacion['foto'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64.decode(situacion['foto']),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Sección de información básica
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Código', situacion['id'] ?? 'N/A', Icons.code),
                    _buildInfoRow('Fecha', _formatearFecha(situacion['fecha_creacion']), Icons.calendar_today),
                    _buildInfoRow('Estado', situacion['estado'] ?? 'Pendiente', Icons.info,
                        color: _getColorEstado(situacion['estado'])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título y Descripción
            Text(
              situacion['titulo'] ?? 'Sin título',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              situacion['descripcion'] ?? 'Sin descripción',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Comentarios (si existen)
            if (situacion['comentario'] != null && situacion['comentario'].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comentarios:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(situacion['comentario']),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Mapa de ubicación
            Text(
              'Ubicación:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMapaUbicacion(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapaUbicacion() {
    if (!_coordenadasValidas) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ubicación no disponible'),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: ubicacion,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('ubicacion'),
                position: ubicacion,
                infoWindow: InfoWindow(
                  title: widget.situacion['titulo'] ?? 'Ubicación reportada',
                ),
              ),
            },
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            onMapCreated: (controller) => mapController = controller,
          ),
        ),
      ),
    );
  }

  Color _getColorEstado(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'resuelto':
        return Colors.green;
      case 'en progreso':
        return Colors.orange;
      case 'pendiente':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'Fecha desconocida';
    
    try {
      final dateTime = DateTime.parse(fecha);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return fecha; // Devuelve el formato original si falla el parsing
    }
  }

  void _compartirSituacion() {
    // Implementar lógica para compartir
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartir situación'),
        content: const Text('¿Cómo deseas compartir esta información?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí iría la lógica para compartir
            },
            child: const Text('Compartir'),
          ),
        ],
      ),
    );
  }
}