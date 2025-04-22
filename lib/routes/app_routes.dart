import 'package:flutter/material.dart';
import 'package:mi_app/screens/private/private_noticias_screen.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../screens/public/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/public/historia_screen.dart';
import '../screens/public/servicio_screen.dart';
import '../screens/public/noticia_screen.dart';
import '../screens/public/medida_preventiva_screen.dart';
import '../screens/public/miembro_screen.dart';
import '../screens/public/acerca_screen.dart';
import '../screens/public/voluntario_screen.dart';
import '../screens/public/albergue_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/private/private_home_screen.dart';
import '../screens/private/private_reportar_screen.dart';
import '../screens/private/private_situacione_screen.dart';
import '../screens/private/contrasena_screen.dart';

class AppRoutes {
  // Configuración principal
  static const String initialRoute = '/splash';
  
  // Rutas públicas
  static const String publicHome = '/public-home';
  static const String historia = '/historia';
  static const String servicios = '/servicios';
  static const String noticias = '/noticias';
  static const String medidas = '/medidas';
  static const String miembros = '/miembros';
  static const String acerca = '/acerca';
  static const String voluntario = '/voluntario';
  static const String albergues = '/albergues';
  static const String login = '/login';
  
  // Rutas privadas
  static const String privateHome = '/private-home';
  static const String privatenoticias = '/private-noticias';
  static const String privateReportar = '/private-reportar';
  static const String privateSituaciones= '/private-situaciones';
  static const String contrasena = '/private-contraseña';

  // Generador de rutas con autenticación
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final authService = Provider.of<AuthService>(
      navigatorKey.currentContext!,
      listen: false,
    );

    // Verificar autenticación para rutas privadas
    if (_isPrivateRoute(settings.name) && !authService.isLoggedIn) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: const RouteSettings(name: login),
      );
    }

    // Mapeo de rutas
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case publicHome:
        return MaterialPageRoute(builder: (_) =>  PublicHomeScreen());
      case privateHome:
        return MaterialPageRoute(builder: (_) => const PrivateHomeScreen());
      case historia:
        return MaterialPageRoute(builder: (_) => const HistoriaScreen());
      case servicios:
        return MaterialPageRoute(builder: (_) => const ServicioScreen());
      case noticias:
        return MaterialPageRoute(builder: (_) => const NoticiaScreen());
      case medidas:
        return MaterialPageRoute(builder: (_) => MedidasPreventivasScreen());
      case miembros:
        return MaterialPageRoute(builder: (_) => const MiembroScreen());
      case acerca:
        return MaterialPageRoute(builder: (_) =>  AcercaDeScreen());
      case voluntario:
        return MaterialPageRoute(builder: (_) => const RegistroVoluntarioScreen());
      case albergues:
        return MaterialPageRoute(builder: (_) => const AlbergueScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case privatenoticias:
        return MaterialPageRoute(builder: (_) => const PrivateNoticiasScreen());
      case privateReportar:
        return MaterialPageRoute(builder: (_) => const ReportarSituacionScreen());
      case privateSituaciones:
        return MaterialPageRoute(builder: (_) => const MisSituacionesScreen());
      case contrasena:
        return MaterialPageRoute(builder: (_) => const CambiarClaveScreen());
      default:
        return _errorRoute();
    }
  }

  // Verificar si la ruta es privada
  static bool _isPrivateRoute(String? routeName) {
    final privateRoutes = [privateHome];
    return privateRoutes.contains(routeName);
  }

  // Ruta para errores
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Ruta no encontrada')),
      ),
    );
  }

  // Clave global para navegación
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}