class Noticia {
  final String id;
  final String fecha;
  final String titulo;
  final String contenido;
  final String foto;

  Noticia({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.contenido,
    required this.foto,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      fecha: json['fecha'],
      titulo: json['titulo'],
      contenido: json['contenido'],
      foto: json['foto'],
    );
  }
}
