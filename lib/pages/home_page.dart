import 'package:delivery_app_emilio_puigcerver/pages/AddPaymentMethodPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app_emilio_puigcerver/pages/create_group_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/GroupDetailsPage.dart'; // Pantalla de detalles del grupo
import 'package:provider/provider.dart';
import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart'; // Importa el ThemeProvider

// Importa la pantalla de suscripción premium
import 'notification_service.dart';
import 'subscription_plans_screen.dart';
import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DocumentSnapshot> _userFuture;
  final TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userFuture = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    _checkSalary();
  }

  // Verificar el salario y mostrar un cuadro de diálogo si es 0
  Future<void> _checkSalary() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      var salary = userDoc['salario'];
      if (salary == 0) {
        _showSalaryDialog();
      }
    }
  }

  // Mostrar cuadro de diálogo para ingresar salario
  void _showSalaryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Impide cerrar el diálogo tocando fuera de él
      builder: (context) => AlertDialog(
        title: const Text('Ingresa tu salario'),
        content: TextField(
          controller: _salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Salario'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _updateSalary();
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateSalary() async {
    double salary = double.tryParse(_salaryController.text) ?? 0.0;

    // Validación: Asegurarse de que el salario no sea 0 o vacío
    if (salary > 0) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'salario': salary});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salario actualizado con éxito')),
      );
      Navigator.of(context)
          .pop(); // Cerrar el diálogo después de la actualización
    } else {
      // Si el salario es 0 o no es válido, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un salario válido.')),
      );
    }
  }

  // Método para agregar método de pago
  void _addPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentMethodPage()),
    );
  }

  // Método para agregar un nuevo grupo
  void _createGroup() async {
    final groupId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGroupPage()),
    );
    if (groupId != null) {
      setState(() {
        _userFuture = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
      });
    }
  }

  // Método para eliminar un grupo con confirmación
  void _deleteGroup(String groupId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Estás seguro de que deseas eliminar este grupo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Eliminar los gastos relacionados con el grupo
      QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
          .collection('gastos')
          .where('id_grupo', isEqualTo: groupId)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Recorremos los documentos y los eliminamos
      for (QueryDocumentSnapshot expenseDoc in expensesSnapshot.docs) {
        batch.delete(expenseDoc.reference);
      }

      // Eliminar el grupo de la colección 'groups'
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();

      // Actualizar los usuarios que pertenecen a este grupo
      QuerySnapshot usuariosSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('id_grupo', arrayContains: groupId)
          .get();

      for (QueryDocumentSnapshot userDoc in usuariosSnapshot.docs) {
        DocumentReference docRef = userDoc.reference;
        batch.update(docRef, {
          'id_grupo': FieldValue.arrayRemove([groupId]),
        });
      }

      // Commit de la operación batch
      await batch.commit();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grupo y gastos eliminados con éxito')));

      // Actualizar la lista de grupos después de eliminar el grupo
      setState(() {
        _userFuture = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
      });
    }
  }

  // Método para cerrar sesión
  void _signOut() async {
    await AuthService().signOut();
    Navigator.pushReplacementNamed(context, '/login');
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

  // Método para enviar una notificación de prueba
  void _sendTestNotification() async {
    await NotificationService.sendNotification(
      title: 'Notificación de Prueba',
      content:
          'Esta es una notificación de prueba enviada desde Flutter con OneSignal.',
    );
  }

  // Método para recargar los datos de los grupos
  Future<void> _reloadGroups() async {
    setState(() {
      _userFuture = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    });
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
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout), // Ícono para cerrar sesión
            tooltip: 'Cerrar Sesión',
            color: Colors.red,
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

            // Botón para agregar método de pago
            ElevatedButton(
              onPressed:
                  _addPaymentMethod, // No necesitas pasar `context`, ya que está disponible en el scope
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Botón azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Agregar método de pago',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para enviar notificación de prueba
            ElevatedButton(
              onPressed: _sendTestNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Botón verde
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Enviar Notificación de Prueba',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

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
              child: RefreshIndicator(
                onRefresh: _reloadGroups,
                child: FutureBuilder<DocumentSnapshot>(
                  future: _userFuture,
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userGroups =
                        userSnapshot.data!['id_grupo'] as List<dynamic>? ?? [];

                    return userGroups.isEmpty
                        ? ListView(
                            children: const [
                              Center(
                                  child: Text(
                                      'No hay grupos a los que pertenezcas.')),
                            ],
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('groups')
                                .where(FieldPath.documentId,
                                    whereIn: userGroups)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final groups = snapshot.data!.docs;

                              if (groups.isEmpty) {
                                return ListView(
                                  children: const [
                                    Center(
                                        child: Text(
                                            'No hay grupos a los que pertenezcas.')),
                                  ],
                                );
                              }

                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Máximo 3 por fila
                                  crossAxisSpacing:
                                      10, // Espaciado entre columnas
                                  mainAxisSpacing: 10, // Espaciado entre filas
                                ),
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  final group = groups[index];

                                  // Usar el color guardado en Firestore
                                  final color = _colorFromHex(group['color']);

                                  return Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navegar a la pantalla de detalles del grupo
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupDetailsPage(
                                                groupName: group['name'],
                                                groupId: group
                                                    .id, // Pasar el ID del grupo
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: color, // Color desde Firestore
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                group[
                                                    'name'], // Nombre del grupo
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
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deleteGroup(group.id),
                                          tooltip: 'Eliminar grupo',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                  },
                ),
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






 


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/create_group_page.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/GroupDetailsPage.dart'; // Pantalla de detalles del grupo
// import 'package:provider/provider.dart';
// import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart'; // Importa el ThemeProvider

// // Importa la pantalla de suscripción premium
// import 'notification_service.dart';
// import 'subscription_plans_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Método para agregar un nuevo grupo
//   void _createGroup() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CreateGroupPage()),
//     );
//   }

//   // Método para navegar a la pantalla de suscripción premium
//   void _goToSubscriptionPlans() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SubscriptionPlansScreen()),
//     );
//   }

//   // Método para convertir un color hexadecimal a un objeto Color
//   Color _colorFromHex(String hexColor) {
//     hexColor = hexColor.replaceAll('#', ''); // Eliminar el símbolo #
//     return Color(int.parse('FF$hexColor',
//         radix: 16)); // Agregar transparencia y convertir
//   }

// // Método para enviar una notificación de prueba
//   void _sendTestNotification() async {
//     await NotificationService.sendNotification(
//       title: 'Notificación de Prueba',
//       content: 'Esta es un mensaje 1.',
//     );
//     await NotificationService.sendNotification(
//       title: 'Notificación de Prueba',
//       content: 'Este es otro mensaje 2.',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Control de Gastos'),
//         actions: [
//           IconButton(
//             onPressed: _goToSubscriptionPlans,
//             icon: const Icon(Icons.diamond), // Ícono para suscripción premium
//             tooltip: 'Suscripción Premium',
//             color: Colors.blue,
//           ),
//           // Switch para cambiar el tema
//           Switch(
//             value: Provider.of<ThemeProvider>(context).isDarkMode,
//             onChanged: (value) {
//               // Cambiar el tema
//               Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header con el título
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Theme.of(context)
//                     .colorScheme
//                     .inversePrimary, // Color naranja del login
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20), // Bordes redondeados abajo
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: const Center(
//                 child: Text(
//                   'Control de Gastos',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white, // Texto en blanco
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20), // Espaciado entre el header y el botón

//             // Botón para agregar grupo
//             ElevatedButton(
//               onPressed: _createGroup,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, // Botón azul
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Bordes redondeados
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               child: const Text(
//                 'Agregar Grupo',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white, // Texto blanco
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(
//                 height: 20), // Espaciado entre el botón y la lista de grupos
//             //boton para test
//             ElevatedButton(
//               onPressed: _sendTestNotification,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Botón verde
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Bordes redondeados
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               child: const Text(
//                 'Enviar Notificación de Prueba',
//                 style: TextStyle(
//                   fontSize: 16, color: Colors.white, // Texto blanco
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Título de la sección de grupos
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Text(
//                   'Grupos existentes:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Mostrar grupos desde Firestore
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream:
//                     FirebaseFirestore.instance.collection('groups').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final groups = snapshot.data!.docs;

//                   if (groups.isEmpty) {
//                     return const Center(child: Text('No hay grupos creados.'));
//                   }

//                   return GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3, // Máximo 3 por fila
//                       crossAxisSpacing: 10, // Espaciado entre columnas
//                       mainAxisSpacing: 10, // Espaciado entre filas
//                     ),
//                     itemCount: groups.length,
//                     itemBuilder: (context, index) {
//                       final group = groups[index];

//                       // Usar el color guardado en Firestore
//                       final color = _colorFromHex(group['color']);

//                       return InkWell(
//                         onTap: () {
//                           // Navegar a la pantalla de detalles del grupo
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => GroupDetailsPage(
//                                 groupName: group['name'],
//                                 groupId: '', // Pasar el nombre del grupo
//                               ),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           color: color, // Color desde Firestore
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 4,
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 group['name'], // Nombre del grupo
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             // Espaciado antes del anuncio
//             const SizedBox(height: 20),

//             // Anuncio banner de Unity Ads (ubicado al final)
//             UnityBannerAd(
//               placementId: 'Banner_Android', // Reemplaza con tu Placement ID
//               onLoad: (placementId) => print('Banner loaded: $placementId'),
//               onClick: (placementId) => print('Banner clicked: $placementId'),
//               onShown: (placementId) => print('Banner shown: $placementId'),
//               onFailed: (placementId, error, message) =>
//                   print('Banner Ad $placementId failed: $error $message'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
