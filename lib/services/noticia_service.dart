import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NoticiaService {
  static const String _url = 'https://adamix.net/defensa_civil/def/noticias.php';

  Future<List<Noticia>> fetchNoticias() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito'] == true) {
        List noticiasJson = data['datos'];
        return noticiasJson.map((e) => Noticia.fromJson(e)).toList();
      } else {
        throw Exception('No se pudieron cargar las noticias');
      }
    } else {
      throw Exception('Error de red');
    }
  }
}
