class MedidaPreventiva {
  final String id;
  final String titulo;
  final String descripcion;
  final String foto;

  MedidaPreventiva({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.foto,
  });

  factory MedidaPreventiva.fromJson(Map<String, dynamic> json) {
    return MedidaPreventiva(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      foto: json['foto'],
    );
  }
}
