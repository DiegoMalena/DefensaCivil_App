import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final bool isLoggedIn = auth.isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildSectionTitle('Información'),
          _buildMenuItem(context, Icons.home, 'Inicio', AppRoutes.publicHome),
          _buildMenuItem(context, Icons.history, 'Historia', AppRoutes.historia),
          _buildMenuItem(context, Icons.summarize, 'Servicios', AppRoutes.servicios),
          _buildMenuItem(context, Icons.newspaper, 'Noticias', AppRoutes.noticias),
          _buildMenuItem(context, Icons.shield, 'Medidas Preventivas', AppRoutes.medidas),
          _buildMenuItem(context, Icons.group, 'Miembros', AppRoutes.miembros),
          _buildMenuItem(context, Icons.volunteer_activism, 'Quiero ser voluntario', AppRoutes.voluntario),
          _buildMenuItem(context, Icons.map, 'Albergues', AppRoutes.albergues),
          _buildMenuItem(context, Icons.person, 'Acerca de', AppRoutes.acerca),

          const Divider(),

          if (isLoggedIn) ...[
            _buildSectionTitle('Privado'),
            _buildMenuItem(context, Icons.dashboard, 'Dashboard', AppRoutes.privateHome),
            _buildMenuItem(context, Icons.newspaper, 'Noticias', AppRoutes.privatenoticias),
            _buildMenuItem(context, Icons.report, 'Reportar situación', AppRoutes.privateReportar),
            _buildMenuItem(context, Icons.list_alt, 'Mis situaciones', AppRoutes.privateSituaciones),
            _buildMenuItem(context, Icons.password, 'Cambiar contraseña', AppRoutes.contrasena),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                await auth.logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.publicHome, (r) => false);
              },
            ),
          ] else ...[
            _buildMenuItem(context, Icons.login, 'Iniciar Sesión', AppRoutes.login),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: Colors.orange),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Defensa Civil', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Menú Principal', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14)),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
