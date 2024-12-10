import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

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
  String selectedCardType = 'Debito'; // Valor por defecto

  DateTime? paymentDueDate; // Fecha de pago (solo para crédito)
  DateTime? paymentLimitDate; // Fecha límite de pago (solo para crédito)

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
        'is_credit_card': selectedCardType == 'Credito', // Si es tarjeta de crédito
        'payment_due_date': selectedCardType == 'Credito' ? Timestamp.fromDate(paymentDueDate!) : null, // Fecha de pago
        'payment_limit_date': selectedCardType == 'Credito' ? Timestamp.fromDate(paymentLimitDate!) : null, // Fecha límite de pago
        'user_id': userId, // Asociar con el usuario actual
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
        selectedCardType = 'Debito'; // Restablecer tipo de tarjeta a débito
        paymentDueDate = null;
        paymentLimitDate = null;
      });
    } catch (e) {
      // Maneja errores y muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el método de pago: $e')),
      );
    }
  }

  // Método para eliminar un método de pago
  void deletePaymentMethod(String methodId) async {
    try {
      // ID del usuario autenticado
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Elimina el método de pago de la colección 'metodos_pago'
      await FirebaseFirestore.instance.collection('metodos_pago').doc(methodId).delete();

      // Actualizar el campo metodos_pago en la colección usuarios
      await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
        'metodos_pago': FieldValue.arrayRemove([methodId]),
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Método de pago eliminado exitosamente')),
      );
    } catch (e) {
      // Maneja errores y muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el método de pago: $e')),
      );
    }
  }

  // Método para seleccionar una fecha
  Future<void> _selectDate(BuildContext context, bool isDueDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isDueDate) {
          paymentDueDate = pickedDate;
        } else {
          paymentLimitDate = pickedDate;
        }
      });
    }
  }

  // Formateador de fechas para mostrar en el campo
  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat('yyyy-MM-dd').format(date); // Formato de fecha YYYY-MM-DD
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
              ),
              onCreditCardWidgetChange: (CreditCardBrand) {}, // Personalización del texto en la tarjeta
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

                  // Campo para la Fecha de Pago
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Pago',
                        hintText: 'Selecciona la fecha de pago',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: _formatDate(paymentDueDate), // Muestra la fecha seleccionada
                      ),
                      onTap: () => _selectDate(context, true), // Abre el selector de fechas
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Campo para la Fecha Límite de Pago
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha Límite de Pago',
                        hintText: 'Selecciona la fecha límite',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: _formatDate(paymentLimitDate), // Muestra la fecha seleccionada
                      ),
                      onTap: () => _selectDate(context, false), // Abre el selector de fechas
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Botón para guardar el método de pago
            ElevatedButton(
              onPressed: savePaymentMethod,
              child: const Text('Guardar Método de Pago'),
            ),

            const SizedBox(height: 20),

            // Lista de métodos de pago del usuario actual
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('usuarios').doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userMethods = List<String>.from(snapshot.data!.get('metodos_pago') ?? []);

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userMethods.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('metodos_pago').doc(userMethods[index]).get(),
                      builder: (context, methodSnapshot) {
                        if (!methodSnapshot.hasData) {
                          return const ListTile(
                            title: Text('Cargando...'),
                          );
                        }

                        final methodData = methodSnapshot.data!;
                        return ListTile(
                          title: Text('Tarjeta terminada en **${methodData['card_number']}'),
                          subtitle: Text('**${methodData['holder_name']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deletePaymentMethod(userMethods[index]); // Eliminar método de pago
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

