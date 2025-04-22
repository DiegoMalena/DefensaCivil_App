import 'package:flutter/material.dart';
import '../../models/noticia.dart';
import '../../services/noticia_service.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({Key? key}) : super(key: key);

  @override
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  late Future<List<Noticia>> _futureNoticias;

  @override
  void initState() {
    super.initState();
    _futureNoticias = NoticiaService().fetchNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias'),
      backgroundColor: Colors.orange,),
      body: FutureBuilder<List<Noticia>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay noticias disponibles'));
          } else {
            final noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(noticia.foto, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(noticia.titulo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(noticia.fecha,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(noticia.contenido),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
