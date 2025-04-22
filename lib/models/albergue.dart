class Albergue {
  final String codigo;
  final String ciudad;
  final String edificio;
  final String coordinador;
  final String telefono;
  final String capacidad;
  final double lat;
  final double lng;

  Albergue({
    required this.codigo,
    required this.ciudad,
    required this.edificio,
    required this.coordinador,
    required this.telefono,
    required this.capacidad,
    required this.lat,
    required this.lng,
  });

  factory Albergue.fromJson(Map<String, dynamic> json) {
    return Albergue(
      codigo: json['codigo'] ?? '',
      ciudad: json['ciudad'] ?? '',
      edificio: json['edificio'] ?? '',
      coordinador: json['coordinador'] ?? '',
      telefono: json['telefono'] ?? '',
      capacidad: json['capacidad'] ?? '',
      lat: double.tryParse(json['lat'] ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng'] ?? '0') ?? 0.0,
    );
  }
}