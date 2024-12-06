import 'package:flutter/material.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView( // Activamos el scroll
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Encabezado personalizado
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star, // Puedes cambiar el icono
                    color: Colors.orange,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'FREEMIUM',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.star, // Puedes cambiar el icono
                    color: Colors.orange,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Ten acceso a todas las funcionalidades,\n'
                'con nuestros planes Fremium',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              // Tarjetas de suscripción
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSubscriptionCard(
                    title: 'Plan Mensual',
                    price: '\$5 USD/mes',
                    description: 'Suscripción mensual.',
                    color: Colors.orange,
                    onTap: () {
                      print('Plan Mensual seleccionado');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionCard(
                    title: 'Paquete del Año',
                    price: '\$50 USD/año',
                    description: 'Ahorra un 17% con este plan anual.',
                    color: Colors.blue,
                    onTap: () {
                      print('Paquete del Año seleccionado');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionCard(
                    title: 'Forever Premium',
                    price: '\$90 USD',
                    description: 'Premium por un pago único.',
                    color: Colors.green,
                    onTap: () {
                      print('Forever Premium seleccionado');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color, // Se elimina la opacidad
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto en blanco
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Texto en blanco
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Texto en blanco
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 80, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '¡Suscribirse!',
                style: TextStyle(fontSize: 16, color: color), // Color del botón según tarjeta
              ),
            ),
          ],
        ),
      ),
    );
  }
}


