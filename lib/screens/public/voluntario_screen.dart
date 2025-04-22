import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistroVoluntarioScreen extends StatefulWidget {
  const RegistroVoluntarioScreen({super.key});

  @override
  State<RegistroVoluntarioScreen> createState() => _RegistroVoluntarioScreenState();
}

class _RegistroVoluntarioScreenState extends State<RegistroVoluntarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cedulaCtrl = TextEditingController();
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController apellidoCtrl = TextEditingController();
  final TextEditingController claveCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();

  Future<void> registrarVoluntario() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse("https://adamix.net/defensa_civil/def/registro.php");
      final response = await http.post(url, body: {
        "cedula": cedulaCtrl.text,
        "nombre": nombreCtrl.text,
        "apellido": apellidoCtrl.text,
        "clave": claveCtrl.text,
        "correo": correoCtrl.text,
        "telefono": telefonoCtrl.text,
      });

      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["mensaje"] ?? "Error inesperado")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Voluntario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cedulaCtrl,
                decoration: const InputDecoration(labelText: "Cédula"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: claveCtrl,
                decoration: const InputDecoration(labelText: "Clave"),
                obscureText: true,
                validator: (value) => value!.length < 4 ? "Mínimo 4 caracteres" : null,
              ),
              TextFormField(
                controller: correoCtrl,
                decoration: const InputDecoration(labelText: "Correo"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: telefonoCtrl,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registrarVoluntario,
                child: const Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
