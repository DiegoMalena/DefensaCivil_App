class Miembro {
  final String id;
  final String foto;
  final String nombre;
  final String cargo;

  Miembro({required this.id, required this.foto, required this.nombre, required this.cargo});

  factory Miembro.fromJson(Map<String, dynamic> json) {
    return Miembro(
      id: json['id'],
      foto: json['foto'],
      nombre: json['nombre'],
      cargo: json['cargo'],
    );
  }
}
