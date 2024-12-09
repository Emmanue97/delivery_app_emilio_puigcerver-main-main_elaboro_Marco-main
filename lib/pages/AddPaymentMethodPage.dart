import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  // Variables para capturar datos de la tarjeta
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  // Para seleccionar entre crédito o débito
  String selectedCardType = 'Debito';  // Valor por defecto

  String paymentDueDate = '';  // Fecha de pago (solo para crédito)
  String paymentLimitDate = '';  // Fecha límite de pago (solo para crédito)

  // Llave para validar el formulario
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Método para guardar el método de pago en Firestore
  void savePaymentMethod() async {
  if (!formKey.currentState!.validate()) {
    // Valida los campos del formulario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, completa todos los campos correctamente')),
    );
    return;
  }

  try {
    // ID del usuario autenticado
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Guarda los datos en Firestore (colección metodos_pago)
    DocumentReference paymentMethodRef = await FirebaseFirestore.instance.collection('metodos_pago').add({
      'card_number': cardNumber.substring(cardNumber.length - 4), // Solo últimos 4 dígitos
      'expiry_date': expiryDate, // Fecha de expiración
      'holder_name': cardHolderName, // Nombre del titular de la tarjeta
      'is_credit_card': selectedCardType == 'Credito',  // Si es tarjeta de crédito
      'payment_due_date': selectedCardType == 'Credito' ? paymentDueDate : null,  // Fecha de pago solo si es crédito
      'payment_limit_date': selectedCardType == 'Credito' ? paymentLimitDate : null,  // Fecha límite de pago solo si es crédito
      'user_id': userId,  // Asociar con el usuario actual
      'created_at': FieldValue.serverTimestamp(), // Marca de tiempo de creación
    });

    // Actualizar el campo metodos_pago en la colección usuarios
    await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
      'metodos_pago': FieldValue.arrayUnion([paymentMethodRef.id]),
    });

    // Muestra un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Método de pago guardado exitosamente')),
    );

    // Limpiar los campos de la tarjeta
    setState(() {
      cardNumber = '';
      expiryDate = '';
      cardHolderName = '';
      cvvCode = '';
      selectedCardType = 'Debito';  // Restablecer tipo de tarjeta a débito
      paymentDueDate = '';
      paymentLimitDate = '';
    });
  } catch (e) {
    // Maneja errores y muestra un mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el método de pago: $e')),
    );
  }
}


  // Método para eliminar un método de pago
  void deletePaymentMethod(String paymentMethodId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Estás seguro de que deseas eliminar este método de pago?"),
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
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        // Eliminar el método de pago de la colección metodos_pago
        await FirebaseFirestore.instance.collection('metodos_pago').doc(paymentMethodId).delete();

        // Eliminar el método de pago del array en la colección usuarios
        await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
          'metodos_pago': FieldValue.arrayRemove([paymentMethodId]),
        });

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Método de pago eliminado con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el método de pago: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Método de Pago"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tarjeta interactiva
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused, // Muestra el reverso de la tarjeta si el CVV está enfocado
              cardBgColor: Colors.blueAccent, // Personalización del color de fondo
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ), onCreditCardWidgetChange: (CreditCardBrand ) {  }, // Personalización del texto en la tarjeta
            ),
            // Formulario para capturar datos
            CreditCardForm(
              formKey: formKey, // Llave del formulario para validación
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              themeColor: Theme.of(context).primaryColor, // Color del tema
              onCreditCardModelChange: (CreditCardModel data) {
                setState(() {
                  // Actualiza las variables con los datos ingresados
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                  isCvvFocused = data.isCvvFocused;
                });
              },
            ),
            const SizedBox(height: 10),

            // Dropdown para seleccionar tipo de tarjeta (Crédito o Débito)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de tarjeta',
                ),
                value: selectedCardType,
                items: ['Debito', 'Credito'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCardType = value!;
                  });
                },
              ),
            ),

            // Mostrar los campos adicionales si es tarjeta de crédito
            if (selectedCardType == 'Credito')
              Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de pago',
                    ),
                    onChanged: (value) {
                      setState(() {
                        paymentDueDate = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha límite de pago',
                    ),
                    onChanged: (value) {
                      setState(() {
                        paymentLimitDate = value;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePaymentMethod, // Llama al método para guardar los datos
              child: const Text("Guardar Método de Pago"),
            ),
            const SizedBox(height: 20),

            // Mostrar lista de métodos de pago del usuario
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('usuarios').doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final userMethods = snapshot.data!['metodos_pago'] as List<dynamic>? ?? [];

                if (userMethods.isEmpty) {
                  return const Text('No tienes métodos de pago registrados.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: userMethods.length,
                  itemBuilder: (context, index) {
                    final methodId = userMethods[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('metodos_pago').doc(methodId).get(),
                      builder: (context, methodSnapshot) {
                        if (!methodSnapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final methodData = methodSnapshot.data!;
                        return ListTile(
                          title: Text('** ${methodData['card_number']} (${methodData['holder_name']})'),
                          subtitle: Text('Expira: ${methodData['expiry_date']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deletePaymentMethod(methodId);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


//Modificado el 8 de dic 2024
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddPaymentMethodPage extends StatefulWidget {
//   const AddPaymentMethodPage({super.key});

//   @override
//   _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
// }

// class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
//   // Variables para capturar datos de la tarjeta
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;

//   // Llave para validar el formulario
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   // Método para guardar el método de pago en Firestore
//   void savePaymentMethod() async {
//     if (!formKey.currentState!.validate()) {
//       // Valida los campos del formulario
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Por favor, completa todos los campos correctamente')),
//       );
//       return;
//     }

//     try {
//       // Guarda los datos en Firestore
//       await FirebaseFirestore.instance.collection('payment_methods').add({
//         'card_number': cardNumber.substring(cardNumber.length - 4), // Solo últimos 4 dígitos
//         'expiry_date': expiryDate, // Fecha de expiración
//         'holder_name': cardHolderName, // Nombre del titular de la tarjeta
//         'created_at': FieldValue.serverTimestamp(), // Marca de tiempo de creación
//       });

//       // Muestra un mensaje de éxito
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Método de pago guardado exitosamente')),
//       );

//       // Reinicia los campos del formulario
//       setState(() {
//         cardNumber = '';
//         expiryDate = '';
//         cardHolderName = '';
//         cvvCode = '';
//       });
//     } catch (e) {
//       // Maneja errores y muestra un mensaje
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al guardar el método de pago: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Agregar Método de Pago"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Tarjeta interactiva
//             CreditCardWidget(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused, // Muestra el reverso de la tarjeta si el CVV está enfocado
//               cardBgColor: Colors.blueAccent, // Personalización del color de fondo
//               textStyle: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ), onCreditCardWidgetChange: (CreditCardBrand ) {  }, // Personalización del texto en la tarjeta
//             ),
//             // Formulario para capturar datos
//             CreditCardForm(
//               formKey: formKey, // Llave del formulario para validación
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               themeColor: Theme.of(context).primaryColor, // Color del tema
//               onCreditCardModelChange: (CreditCardModel data) {
//                 setState(() {
//                   // Actualiza las variables con los datos ingresados
//                   cardNumber = data.cardNumber;
//                   expiryDate = data.expiryDate;
//                   cardHolderName = data.cardHolderName;
//                   cvvCode = data.cvvCode;
//                   isCvvFocused = data.isCvvFocused;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: savePaymentMethod, // Llama al método para guardar los datos
//               child: const Text("Guardar Método de Pago"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

