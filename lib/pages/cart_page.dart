import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
import 'package:delivery_app_emilio_puigcerver/componets/my_cart_tile.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
import 'package:delivery_app_emilio_puigcerver/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child){
      //carrito
      final userCart = restaurant.cart;

      // scaffold UI
      return Scaffold(
        appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          //vaciar el carrito (button)
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title:const Text("¿Está seguro de querer eliminar las cosas del carrito?"),
              actions: [
                //botón de cancelación
                TextButton(onPressed: () => Navigator.pop(context),
                child:const Text("cancelar")
                ),
                //botón de si
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  restaurant.clearCart();
                },
                child:const Text("si")
                ),
              ],
            ),
            );
          },
            icon:const Icon(Icons.delete)
          ),
        ],
        ),
        //sirve para que al seleccionar al carrito salga el articulo
        body: Column(
          children: [
              Expanded(
              child: Column(
                children: [
                  userCart.isEmpty ? const Expanded (child: Center (child: Text("El carrito se está vacio..."),
                  ),
                  )
                  : Expanded(
                    child: ListView.builder(
                      itemCount: userCart.length,
                      itemBuilder: (context, index){
                        //obtener el item individual del carrito
                        final cartItem = userCart[index];

                        //volver al cart tile UI
                        return MyCartTile(cartItem: cartItem);
                      },
                  ),
                  ),
                ],
              ),
            ),
            //boton para pagar
            MyButton(onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> const PaymentPage())
              ),
            text: "Ir a la caja"),
            const SizedBox(height: 25),
          ],
        ),
      );
    });
  }
}