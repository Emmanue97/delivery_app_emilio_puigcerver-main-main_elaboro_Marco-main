import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app_emilio_puigcerver/pages/create_group_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/GroupDetailsPage.dart'; // Pantalla de detalles del grupo
import 'package:provider/provider.dart';
import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart'; 
import 'package:unity_ads_plugin/unity_ads_plugin.dart'; // Importa el ThemeProvider

// Importa la pantalla de suscripción premium
import 'subscription_plans_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Método para agregar un nuevo grupo
  void _createGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGroupPage()),
    );
  }

  // Método para navegar a la pantalla de suscripción premium
  void _goToSubscriptionPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubscriptionPlansScreen()),
    );
  }

  // Método para convertir un color hexadecimal a un objeto Color
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', ''); // Eliminar el símbolo #
    return Color(int.parse('FF$hexColor',
        radix: 16)); // Agregar transparencia y convertir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Gastos'),
        actions: [
          IconButton(
            onPressed: _goToSubscriptionPlans,
            icon: const Icon(Icons.diamond), // Ícono para suscripción premium
            tooltip: 'Suscripción Premium',
            color: Colors.blue,
          ),
          // Switch para cambiar el tema
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              // Cambiar el tema
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header con el título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary, // Color naranja del login
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20), // Bordes redondeados abajo
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'Control de Gastos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto en blanco
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Espaciado entre el header y el botón

            // Botón para agregar grupo
            ElevatedButton(
              onPressed: _createGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Botón azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Agregar Grupo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Espaciado entre el botón y la lista de grupos

            // Título de la sección de grupos
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Grupos existentes:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mostrar grupos desde Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('groups').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final groups = snapshot.data!.docs;

                  if (groups.isEmpty) {
                    return const Center(child: Text('No hay grupos creados.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Máximo 3 por fila
                      crossAxisSpacing: 10, // Espaciado entre columnas
                      mainAxisSpacing: 10, // Espaciado entre filas
                    ),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];

                      // Usar el color guardado en Firestore
                      final color = _colorFromHex(group['color']);

                      return InkWell(
                        onTap: () {
                          // Navegar a la pantalla de detalles del grupo
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupDetailsPage(
                                groupName: group['name'],
                                groupId: '', // Pasar el nombre del grupo
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: color, // Color desde Firestore
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                group['name'], // Nombre del grupo
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Espaciado antes del anuncio
            const SizedBox(height: 20),
            
            // Anuncio banner de Unity Ads (ubicado al final)
            UnityBannerAd(
              placementId: 'Banner_Android', // Reemplaza con tu Placement ID
              onLoad: (placementId) => print('Banner loaded: $placementId'),
              onClick: (placementId) => print('Banner clicked: $placementId'),
              onShown: (placementId) => print('Banner shown: $placementId'),
              onFailed: (placementId, error, message) =>
                  print('Banner Ad $placementId failed: $error $message'),
            ),
          ],
        ),
      ),
    );
  }
}
