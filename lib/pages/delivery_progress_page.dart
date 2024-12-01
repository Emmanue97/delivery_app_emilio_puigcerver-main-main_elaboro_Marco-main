import 'package:delivery_app_emilio_puigcerver/componets/my_receipt.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
import 'package:delivery_app_emilio_puigcerver/services/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {

  //obtener acceso a la base de datos
  FirestoreService db =FirestoreService();
  @override
  void initState() {
    super.initState();

    //cuando este llena esta pagina envia la orden a la base de datos de firestore
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: _buildBottonNavBar(context),
      body: const Column(
        children: [
          MyReceipt(),
        ],
      ),
      );
  }

  // nav bar botton - massage / llamar al repartidor
  Widget _buildBottonNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
      ),
      ),
      padding:const EdgeInsets.all(25),
      child: Row(children: [
        //perfil del repartidor
        Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        ),
        child: IconButton(onPressed: (){},
        icon:const Icon(Icons.person),
        ),
        ),

        const SizedBox(width: 10),
        // información del repartidor
        Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Omar millan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              ),
            Text(
              "Conductor",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
          // botón de  mensaje
           Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        ),
        child: IconButton(onPressed: (){},
        icon:const Icon(Icons.message),
        color: Theme.of(context).colorScheme.primary,
        ),
        ),
        const SizedBox(width: 10),

          // botón para llamar
           Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        ),
        child: IconButton(onPressed: (){},
        icon:const Icon(Icons.call),
        color: Colors.blue,
        ),
        ),
        ],
        )

        
      ],
      ),
    );
  }
}