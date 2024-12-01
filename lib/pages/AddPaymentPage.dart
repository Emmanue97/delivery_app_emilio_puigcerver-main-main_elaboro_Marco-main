import 'package:flutter/material.dart';
import 'package:delivery_app_emilio_puigcerver/pages/AddPaymentMethodPage.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key});

  @override
  _AddPaymentPageState createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _savePayment() {
    // Aquí puedes implementar la lógica para guardar el pago en Firestore
    final amount = double.tryParse(amountController.text) ?? 0.0;
    final description = descriptionController.text;

    if (amount > 0 && description.isNotEmpty) {
      // Lógica para guardar el pago
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago guardado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }

  void _navigateToAddPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentMethodPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de monto
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto del Pago',
              ),
            ),
            const SizedBox(height: 10),

            // Campo de descripción
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción del Pago',
              ),
            ),
            const SizedBox(height: 20),

            // Botón para guardar el pago
            ElevatedButton(
              onPressed: _savePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Guardar Pago',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para agregar método de pago
            ElevatedButton(
              onPressed: _navigateToAddPaymentMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Color del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Agregar Método de Pago',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
