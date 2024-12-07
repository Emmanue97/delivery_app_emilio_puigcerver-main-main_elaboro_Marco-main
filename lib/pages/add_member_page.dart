import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class AddMemberPage extends StatefulWidget {
  final String groupId;

  const AddMemberPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  Future<void> _addMember() async {
    if (_nameController.text.isEmpty ||
        _salaryController.text.isEmpty ||
        _userIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('member').add({
        'group_id': widget.groupId,
        'name': _nameController.text,
        'salary': double.parse(_salaryController.text),
        'user_id': _userIdController.text,
      });
        UnityAds.showVideoAd(
          placementId: 'Rewarded_Android',
          onStart: (placementId) => print('Ad Started: $placementId'),
          onClick: (placementId) => print('Ad Clicked: $placementId'),
          onSkipped: (placementId) => print('Ad Skipped: $placementId'),
          onComplete: (placementId) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Miembro agregado exitosamente')),
            ); // Solo navega después del anuncio
          },
          onFailed: (placementId, error, message) =>
              print('Ad Failed: $placementId, $error, $message'),
        );
      // Regresar a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar miembro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Miembro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Miembro'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Salario del Miembro'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'ID del Miembro'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMember,
              child: const Text('Agregar Miembro'),
            ),
          ],
        ),
      ),
    );
  }
}
