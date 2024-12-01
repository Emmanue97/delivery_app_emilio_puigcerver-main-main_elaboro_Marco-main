import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Guarda los datos en Firestore
      await FirebaseFirestore.instance.collection('payment_methods').add({
        'card_number': cardNumber.substring(cardNumber.length - 4), // Solo últimos 4 dígitos
        'expiry_date': expiryDate, // Fecha de expiración
        'holder_name': cardHolderName, // Nombre del titular de la tarjeta
        'created_at': FieldValue.serverTimestamp(), // Marca de tiempo de creación
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Método de pago guardado exitosamente')),
      );

      // Reinicia los campos del formulario
      setState(() {
        cardNumber = '';
        expiryDate = '';
        cardHolderName = '';
        cvvCode = '';
      });
    } catch (e) {
      // Maneja errores y muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el método de pago: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePaymentMethod, // Llama al método para guardar los datos
              child: const Text("Guardar Método de Pago"),
            ),
          ],
        ),
      ),
    );
  }
}

