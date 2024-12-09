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
  Future<void> _addMember(String userId) async {
    try {
      // Actualizar el documento del usuario para agregar el ID del grupo
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .update({
        'id_grupo': FieldValue.arrayUnion(
            [widget.groupId]), // Agregar el ID del grupo a la lista
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];
          final filteredUsers = users.where((user) {
            final data = user.data() as Map<String, dynamic>;
            final groupIds = data['id_grupo'] as List<dynamic>? ?? [];
            return !groupIds.contains(widget.groupId);
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(
              child: Text(
                'No hay usuarios disponibles para agregar al grupo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      user['nombre']?[0]?.toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user['nombre'] ?? 'Sin nombre',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'ID Miembro: ${user['id_miembro'] ?? 'N/A'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.green),
                    onPressed: () => _addMember(filteredUsers[index].id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
