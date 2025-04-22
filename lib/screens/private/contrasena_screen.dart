import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mi_app/auth/auth_service.dart';
import 'dart:convert';

class CambiarClaveScreen extends StatefulWidget {
  const CambiarClaveScreen({super.key});

  @override
  State<CambiarClaveScreen> createState() => _CambiarClaveScreenState();
}

class _CambiarClaveScreenState extends State<CambiarClaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _claveActualController = TextEditingController();
  final _nuevaClaveController = TextEditingController();
  final _confirmarClaveController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String _errorMessage = '';

  Future<void> _cambiarClave() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;

    if (token == null) {
      setState(() => _errorMessage = 'Debe iniciar sesión primero');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://adamix.net/defensa_civil/def/cambiar_clave.php'),
        body: {
          'token': token,
          'clave_anterior': _claveActualController.text,
          'clave_nueva': _nuevaClaveController.text,
        },
      ).timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if (data['exito'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['mensaje']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => _errorMessage = data['mensaje']);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error de conexión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validarConfirmacion(String? value) {
    if (value != _nuevaClaveController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validarClave(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length < 4) {
      return 'Mínimo 4 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos una mayúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Debe contener al menos un número';
    }
    return null;
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Cambiar Contraseña'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _claveActualController,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent 
                      ? Icons.visibility 
                      : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              validator: (value) => 
                  value!.isEmpty ? 'Ingrese su contraseña actual' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nuevaClaveController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew 
                      ? Icons.visibility 
                      : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: _validarClave,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmarClaveController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmar Nueva Contraseña',
                prefixIcon: const Icon(Icons.verified_user),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm 
                      ? Icons.visibility 
                      : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: _validarConfirmacion,
            ),
            const SizedBox(height: 30),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _cambiarClave,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.lock_reset),
              label: Text(_isLoading ? 'Procesando...' : 'Cambiar Contraseña'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    _claveActualController.dispose();
    _nuevaClaveController.dispose();
    _confirmarClaveController.dispose();
    super.dispose();
  }
}