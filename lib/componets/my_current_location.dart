import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';


class MyCurrentLocation extends StatefulWidget {
  const MyCurrentLocation({super.key});

  @override
  _MyCurrentLocationState createState() => _MyCurrentLocationState();
}

class _MyCurrentLocationState extends State<MyCurrentLocation> {
  final TextEditingController textController = TextEditingController();

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tu ubicación"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Buscar dirección..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              textController.clear(); // Limpiar el controlador antes de cerrar el diálogo
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Modificar la dirección de envío
              String newAddress = textController.text;
              context.read<Restaurant>().updateDeliveryAddress(newAddress);
              textController.clear(); // Limpiar el controlador después de actualizar la dirección
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pedir ahora",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                // En este apartado del código se verá la parte de la dirección del usuario
                Consumer<Restaurant>(
                  builder: (context, restaurant, child) => Text(
                    restaurant.deliveryAddress,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Despliegue del menú
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
