// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math'; // Para generar colores aleatorios

// class CreateGroupPage extends StatefulWidget {
//   const CreateGroupPage({super.key});

//   @override
//   _CreateGroupPageState createState() => _CreateGroupPageState();
// }

// class _CreateGroupPageState extends State<CreateGroupPage> {
//   final TextEditingController _groupNameController = TextEditingController();
//   final Random _random = Random(); // Para generar colores aleatorios

//   // Método para generar un color aleatorio en formato hexadecimal
//   String _getRandomColorHex() {
//     int colorValue = _random.nextInt(0xFFFFFF); // Generar un valor hexadecimal
//     return '#${colorValue.toRadixString(16).padLeft(6, '0')}'; // Convertirlo a cadena hex
//   }

//   // Método para guardar el grupo en Firestore
//   void _saveGroup() async {
//     if (_groupNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('El nombre del grupo no puede estar vacío')),
//       );
//       return;
//     }

//     try {
//       // Crear un nuevo documento en la colección "groups"
//       await FirebaseFirestore.instance.collection('groups').add({
//         'id': DateTime.now().toString(), // Generar un ID único basado en la fecha
//         'name': _groupNameController.text, // Nombre del grupo
//         'color': _getRandomColorHex(), // Color aleatorio en formato hexadecimal
//         'created_at': FieldValue.serverTimestamp(), // Fecha de creación
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Grupo guardado exitosamente')));

//       // Regresar a la pantalla anterior
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al guardar el grupo: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crear Grupo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: _groupNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nombre del Grupo',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _saveGroup,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Guardar Grupo',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Para el selector de color
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  Color _selectedColor = Colors.blue; // Color seleccionado por defecto

  // Método para mostrar el selector de color
  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona un Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Método para convertir Color a Hex
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  // Método para guardar el grupo en Firestore y actualizar el usuario
  void _saveGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El nombre del grupo no puede estar vacío')),
      );
      return;
    }

    try {
      // Verificar la existencia de la colección y crearla si no existe
      DocumentReference groupRef =
          await FirebaseFirestore.instance.collection('groups').add({
        'name': _groupNameController.text,
        'color': _colorToHex(_selectedColor),
        'created_at': FieldValue.serverTimestamp(),
      });

      // Obtener el ID del grupo recién creado
      String groupId = groupRef.id;

      // Actualizar el documento del usuario para agregar el ID del grupo
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(currentUser.uid)
            .update({
          'id_grupo': FieldValue.arrayUnion(
              [groupId]), // Agregar el ID del grupo a la lista
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grupo guardado exitosamente')),
      );

      // Regresar a la pantalla anterior y actualizar el estado del widget
      Navigator.pop(context, groupId); // Regresar con el groupId
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el grupo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Grupo',
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickColor,
              child: const Text('Seleccionar Color'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Guardar Grupo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

