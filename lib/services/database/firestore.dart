import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //obtener la colección de pedidos
  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  //guardar la orden en la base de datos
  Future<void> saveOrderToDatabase(String receipt) async{
    await orders.add({
      'Fecha' : DateTime.now(),
      'Orden' : receipt,
      //añadir más carpetas si es necesario 
    });
  }
}