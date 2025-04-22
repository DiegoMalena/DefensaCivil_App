import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  // Estado de autenticación
  String? _token;
  Map<String, dynamic>? _userData;

  // Getters públicos
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _token != null;

  // Getter para el nombre de usuario
  String get username {
    return _userData?['nombre'] ?? 'Usuario'; // Ajusta 'nombre' según el campo real
  }

  // Claves para SharedPreferences
  static const _authTokenKey = 'auth_token';
  static const _userDataKey = 'user_data';

  // Método de inicialización que debe llamarse al iniciar la app
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cargar token almacenado
    _token = prefs.getString(_authTokenKey);
    
    // Cargar datos de usuario
    final userJson = prefs.getString(_userDataKey);
    if (userJson != null) {
      try {
        _userData = json.decode(userJson) as Map<String, dynamic>;
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding user data: $e');
        }
        await prefs.remove(_userDataKey); // Eliminar datos corruptos
      }
    }
    
    notifyListeners();
  }

  // Método para login
  Future<void> login({
    required String cedula,
    required String clave,
  }) async {
    try {
      // Simulamos una llamada a la API real
      final response = await http.post(
        Uri.parse('https://adamix.net/defensa_civil/def/iniciar_sesion.php'),
        body: {'cedula': cedula, 'clave': clave},
      );

      final data = json.decode(response.body);
      
      if (data['exito'] == true) {
        await _saveAuthData(
          token: data['datos']['token'],
          userData: data['datos'],
        );
      } else {
        throw data['mensaje'] ?? 'Error en el login';
      }
    } catch (e) {
      rethrow;
    }
  }

  // Método para guardar los datos de autenticación
  Future<void> _saveAuthData({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_authTokenKey, token);
    await prefs.setString(_userDataKey, json.encode(userData));
    
    _token = token;
    _userData = userData;
    
    notifyListeners();
  }

  // Método para logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userDataKey);
    
    _token = null;
    _userData = null;
    
    notifyListeners();
  }

  // Método para recuperar contraseña
 Future<Map<String, dynamic>> recoverPassword({
  required String cedula,
  required String correo,
}) async {
  try {
    final response = await http.post(
      Uri.parse('https://adamix.net/defensa_civil/def/recuperar_clave.php'),
      body: {'cedula': cedula, 'correo': correo},
    );

    final data = json.decode(response.body);
    return data;
  } catch (e) {
    return {
      'exito': false,
      'mensaje': 'Error de conexión o formato inválido: $e',
    };
  }
}

}