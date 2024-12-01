import 'package:delivery_app_emilio_puigcerver/pages/cart_page.dart';
import 'package:flutter/material.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;
  const MySliverAppBar({
    super.key,
  required this.child, 
  required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,//sirve para distribuir el espacio de manera uniforme
      collapsedHeight: 120, //sirve para que se oculte el contenido
      floating: false,
      pinned: true, // sirve para que no se vaya para arriba el apartado del footer de la app
      actions: [
        //botón del carrito de compras
        IconButton(onPressed: (){
          // ir al carrito de compras (cart page)
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartPage()
          ),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        )
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Cena al atardecer"),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: child,
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}