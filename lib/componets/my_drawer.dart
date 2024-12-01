import 'package:delivery_app_emilio_puigcerver/componets/my_drawer_tile.dart';
import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final authService = AuthService();
    authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //logo de la aplicación
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 70,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          //base para la lista de inicio
          MyDrawerTile(
            text: "INICIO",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          //base para la lista de ajustes
          MyDrawerTile(
            text: "HERRAMIENTAS",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          const Spacer(),

          //salida de la lista de ajustes
          MyDrawerTile(
            text: "CERRAR SESIÓN",
            icon: Icons.logout,
            onTap: () {
              logout(context);
            },
          ),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
}
