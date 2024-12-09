import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class AddExpensePage extends StatefulWidget {
  final String groupId;

  const AddExpensePage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _purchaseDate;
  DateTime? _paymentDate;
  String? _selectedMethodId;
  String? _paidByMemberId;

  // Lista predefinida de métodos de pago
  final List<String> _paymentMethods = [
    'Efectivo',
    'Tarjeta',
    'Vale',
    'Otro método'
  ];

  // Lista predefinida de categorías
  final List<String> _categories = [
    'Supermercado',
    'Comida',
    'Transporte',
    'Renta',
    'Suscripciones Digitales',
    'Otro'
  ];

  // Categoría seleccionada
  String? _selectedCategory;

  // Añadir nombre del miembro que pagó
  String? _paidByMemberName;

  Future<void> _addExpense() async {
    if (_descriptionController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _purchaseDate == null ||
        _paymentDate == null ||
        _selectedMethodId == null ||
        _paidByMemberId == null ||
        _paidByMemberName == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      // Agregar el gasto a Firestore
      await FirebaseFirestore.instance.collection('gastos').add({
        'id_grupo': widget.groupId,
        'descripcion_gasto': _descriptionController.text,
        'monto': double.parse(_amountController.text),
        'fecha_compra': _purchaseDate,
        'fecha_pago': _paymentDate,
        'metodo_pago': _selectedMethodId,
        'id_miembro': _paidByMemberId, // Utilizar el ID del miembro seleccionado
        'nombre_miembro': _paidByMemberName,
        'categoria': _selectedCategory, // Agregar la categoría seleccionada
        'fecha_creacion': FieldValue.serverTimestamp(),
      });
      UnityAds.showVideoAd(
        placementId: 'Rewarded_Android',
        onStart: (placementId) => print('Ad Started: $placementId'),
        onClick: (placementId) => print('Ad Clicked: $placementId'),
        onSkipped: (placementId) => print('Ad Skipped: $placementId'),
        onComplete: (placementId) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gasto agregado exitosamente')),
          ); // Solo navega después del anuncio
        },
        onFailed: (placementId, error, message) =>
            print('Ad Failed: $placementId, $error, $message'),
      );
      // Regresar a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar el gasto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Gasto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de descripción
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción del gasto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de monto
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
            ),
            const SizedBox(height: 16),

            // Fecha de compra
            ListTile(
              title: Text(
                'Fecha de compra: ${_purchaseDate != null ? _purchaseDate!.toLocal().toString().split(' ')[0] : 'Seleccionar'}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _purchaseDate = selectedDate;
                    _paymentDate = null; // Resetear la fecha de pago
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Fecha de pago
            ListTile(
              title: Text(
                'Fecha de pago: ${_paymentDate != null ? _paymentDate!.toLocal().toString().split(' ')[0] : 'Seleccionar'}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                if (_purchaseDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor selecciona la fecha de compra primero')),
                  );
                  return;
                }
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _purchaseDate!.add(const Duration(days: 1)),
                  firstDate: _purchaseDate!.add(const Duration(days: 1)),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _paymentDate = selectedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Selección del método de pago
            DropdownButtonFormField<String>(
              value: _selectedMethodId,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
              items: _paymentMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethodId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Selección de la categoría
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría del gasto',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Selección de quién pagó
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('id_grupo', arrayContains: widget.groupId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final members = snapshot.data!.docs;

                // Asegurar que la lista de miembros no esté vacía y el valor inicial sea nulo si no hay miembros
                final memberItems = members.map((member) {
                  return DropdownMenuItem<String>(
                    value: member['id_miembro'],
                    child: Text(member['nombre']),
                  );
                }).toList();

                return DropdownButtonFormField<String>(
                  value: members.isNotEmpty ? _paidByMemberId : null,
                  decoration: const InputDecoration(
                    labelText: '¿Quién pagó?',
                    border: OutlineInputBorder(),
                  ),
                  items: memberItems,
                  onChanged: (value) {
                    final selectedMember = members
                        .firstWhere((member) => member['id_miembro'] == value);
                    setState(() {
                      _paidByMemberId = selectedMember['id_miembro'];
                      _paidByMemberName = selectedMember['nombre'];
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Botón para guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addExpense,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Guardar Gasto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







//Modificado el 8 de diciembre 2024 
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

// class AddExpensePage extends StatefulWidget {
//   final String groupId;

//   const AddExpensePage({Key? key, required this.groupId}) : super(key: key);

//   @override
//   State<AddExpensePage> createState() => _AddExpensePageState();
// }

// class _AddExpensePageState extends State<AddExpensePage> {
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   DateTime? _purchaseDate;
//   DateTime? _paymentDate;
//   String? _selectedMethodId;
//   String? _paidByMemberId;

//   Future<void> _addExpense() async {
//     if (_descriptionController.text.isEmpty ||
//         _amountController.text.isEmpty ||
//         _purchaseDate == null ||
//         _paymentDate == null ||
//         _selectedMethodId == null ||
//         _paidByMemberId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Por favor completa todos los campos')),
//       );
//       return;
//     }

//     try {
//       // Agregar el gasto a Firestore
//       await FirebaseFirestore.instance.collection('expenses').add({
//         'group_id': widget.groupId,
//         'description': _descriptionController.text,
//         'amount': double.parse(_amountController.text),
//         'purchase_date': _purchaseDate!.toIso8601String(),
//         'payment_date': _paymentDate!.toIso8601String(),
//         'method_id': _selectedMethodId,
//         'paid_by': _paidByMemberId,
//         'created_at': FieldValue.serverTimestamp(),
//       });
//       UnityAds.showVideoAd(
//           placementId: 'Rewarded_Android',
//           onStart: (placementId) => print('Ad Started: $placementId'),
//           onClick: (placementId) => print('Ad Clicked: $placementId'),
//           onSkipped: (placementId) => print('Ad Skipped: $placementId'),
//           onComplete: (placementId) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Gasto agregado exitosamente')),
//             ); // Solo navega después del anuncio
//           },
//           onFailed: (placementId, error, message) =>
//               print('Ad Failed: $placementId, $error, $message'),
//         );
//       // Regresar a la pantalla anterior
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al agregar el gasto: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Añadir Gasto'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Campo de descripción
//             TextField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Descripción del gasto',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Campo de monto
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Monto',
//                 border: OutlineInputBorder(),
//                 prefixText: '\$',
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Fecha de compra
//             ListTile(
//               title: Text(
//                 'Fecha de compra: ${_purchaseDate != null ? _purchaseDate!.toLocal().toString().split(' ')[0] : 'Seleccionar'}',
//               ),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: () async {
//                 final selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (selectedDate != null) {
//                   setState(() {
//                     _purchaseDate = selectedDate;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             // Fecha de pago
//             ListTile(
//               title: Text(
//                 'Fecha de pago: ${_paymentDate != null ? _paymentDate!.toLocal().toString().split(' ')[0] : 'Seleccionar'}',
//               ),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: () async {
//                 final selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (selectedDate != null) {
//                   setState(() {
//                     _paymentDate = selectedDate;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             // Selección del método de pago
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('payment_methods')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const CircularProgressIndicator();
//                 }

//                 final methods = snapshot.data!.docs;

//                 return DropdownButtonFormField<String>(
//                   value: _selectedMethodId,
//                   decoration: const InputDecoration(
//                     labelText: 'Método de pago',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: methods.map((method) {
//                     return DropdownMenuItem<String>(
//                       value: method.id,
//                       child: Text('Tarjeta: ${method['card_number']}'),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedMethodId = value;
//                     });
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 16),

//             // Selección de quién pagó
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('member')
//                   .where('group_id', isEqualTo: widget.groupId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const CircularProgressIndicator();
//                 }

//                 final members = snapshot.data!.docs;

//                 return DropdownButtonFormField<String>(
//                   value: _paidByMemberId,
//                   decoration: const InputDecoration(
//                     labelText: '¿Quién pagó?',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: members.map((member) {
//                     return DropdownMenuItem<String>(
//                       value: member.id,
//                       child: Text(member['name']),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _paidByMemberId = value;
//                     });
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 24),

//             // Botón para guardar
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _addExpense,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Guardar Gasto'),
//               ),
//             ),
//           ],
//         ),
//      ),
// );
// }
// }