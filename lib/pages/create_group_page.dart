import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // Para generar colores aleatorios

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final Random _random = Random(); // Para generar colores aleatorios

  // Método para generar un color aleatorio en formato hexadecimal
  String _getRandomColorHex() {
    int colorValue = _random.nextInt(0xFFFFFF); // Generar un valor hexadecimal
    return '#${colorValue.toRadixString(16).padLeft(6, '0')}'; // Convertirlo a cadena hex
  }

  // Método para guardar el grupo en Firestore
  void _saveGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del grupo no puede estar vacío')),
      );
      return;
    }

    try {
      // Crear un nuevo documento en la colección "groups"
      await FirebaseFirestore.instance.collection('groups').add({
        'id': DateTime.now().toString(), // Generar un ID único basado en la fecha
        'name': _groupNameController.text, // Nombre del grupo
        'color': _getRandomColorHex(), // Color aleatorio en formato hexadecimal
        'created_at': FieldValue.serverTimestamp(), // Fecha de creación
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grupo guardado exitosamente')));

      // Regresar a la pantalla anterior
      Navigator.pop(context);
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
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
