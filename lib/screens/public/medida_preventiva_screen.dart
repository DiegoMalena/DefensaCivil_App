import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/medida_preventiva.dart';

class MedidasPreventivasScreen extends StatefulWidget {
  @override
  _MedidasPreventivasScreenState createState() => _MedidasPreventivasScreenState();
}

class _MedidasPreventivasScreenState extends State<MedidasPreventivasScreen> {
  List<MedidaPreventiva> medidas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtenerMedidas();
  }

  Future<void> obtenerMedidas() async {
    final url = Uri.parse('https://adamix.net/defensa_civil/def/medidas_preventivas.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List datos = jsonData['datos'];

      setState(() {
        medidas = datos.map((e) => MedidaPreventiva.fromJson(e)).toList();
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medidas Preventivas'),
        backgroundColor: Colors.orange,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: medidas.length,
              itemBuilder: (context, index) {
                final medida = medidas[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(medida.titulo),
                    children: [
                      if (medida.foto.isNotEmpty)
                        Image.network(medida.foto),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(medida.descripcion),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
