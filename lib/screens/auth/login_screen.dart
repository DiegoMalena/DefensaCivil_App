import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/auth/auth_service.dart';
import 'package:mi_app/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _claveController = TextEditingController();
  final _recoveryCedulaController = TextEditingController();
  final _recoveryEmailController = TextEditingController();
  bool _isLoading = false;
  bool _showRecoveryForm = false;

  Future<void> _submitLoginForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.login(
        cedula: _cedulaController.text.trim(),
        clave: _claveController.text.trim(),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.privateHome,
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitRecoveryForm(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  
  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final response = await authService.recoverPassword(
      cedula: _recoveryCedulaController.text.trim(),
      correo: _recoveryEmailController.text.trim(),
    );

    final bool exito = response['exito'] ?? false;
    final String mensaje = response['mensaje'] ?? 'Respuesta inesperada';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );

    if (exito) {
      setState(() {
        _showRecoveryForm = false;
        _recoveryCedulaController.clear();
        _recoveryEmailController.clear();
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error inesperado: $e')),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _showRecoveryForm ? _buildRecoveryForm() : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cedulaController,
            decoration: const InputDecoration(
              labelText: 'Cédula',
              prefixIcon: Icon(Icons.badge),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true 
                ? 'Ingrese su cédula' 
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _claveController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Ingrese su contraseña';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _submitLoginForm(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
          TextButton(
            onPressed: () => setState(() => _showRecoveryForm = true),
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Recuperar Contraseña',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _recoveryCedulaController,
            decoration: const InputDecoration(
              labelText: 'Cédula',
              prefixIcon: Icon(Icons.badge),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true 
                ? 'Ingrese su cédula' 
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _recoveryEmailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Ingrese su correo';
              if (!value!.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _submitRecoveryForm(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Recuperar Contraseña'),
                ),
          TextButton(
            onPressed: () => setState(() => _showRecoveryForm = false),
            child: const Text('Volver al Login'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _claveController.dispose();
    _recoveryCedulaController.dispose();
    _recoveryEmailController.dispose();
    super.dispose();
  }
}