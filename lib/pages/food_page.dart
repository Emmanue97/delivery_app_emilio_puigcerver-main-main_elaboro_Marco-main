import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app_emilio_puigcerver/models/food.dart';
import 'package:provider/provider.dart';
//en este apartado la funcion que hace es que si le apesgas a la imagen se hace más grande y te dará una pequeña descripción

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

    FoodPage({
    super.key,
    required this.food,
    }) {
      //Inicializar los complementos seleccionados para que sean falsos
      for (Addon addon in food.availableAddons) {
        selectedAddons[addon] = false;
      }
    }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // metodo para añadir al carrito
  void addToCart(Food food, Map<Addon, bool>selectedAddons) {

    //cerrar la food page y redirigir al menú
    Navigator.pop(context);

    // formato de selección de complementos
    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in widget.food.availableAddons) {
      if (widget.selectedAddons[addon]== true) {
        currentlySelectedAddons.add(addon);
      }
    }
  //añadir al carrito
    context.read<Restaurant>().addToCart(food, currentlySelectedAddons);

  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //scaffold UI
      Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // imagen comida
            Image.asset(widget.food.imagePath),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                //nombre comida
              Text
              (widget.food.name,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            //precio comida
            Text(  '\$${widget.food.price}',
                style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 10),

              //descripción de comida
              Text(widget.food.description),

              const SizedBox(height: 10),
              Divider(color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 10),

              // complementos (addons)
              Text(
                "Añadir complementos",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(9),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.food.availableAddons.length,
                  itemBuilder: (context,index) {
                    //obtener complementos individuales
                  Addon addon = widget.food.availableAddons[index];
                  // volver a la caja de lista UI
                  return CheckboxListTile(
                    title: Text(addon.name),
                    subtitle:Text(  '\$${addon.price}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary,
                  ),
                ) ,
                    value: widget.selectedAddons[addon], // este valor sirve para seleccionar los complementos
                    onChanged: (bool? value){
                      setState(() {
                        widget.selectedAddons[addon] = value!;
                      });
                    },
                  );
                },
                        ),
              )
                    ],
                  ),
            ),

            //button -> añadir al carrito
            MyButton(onTap: () => addToCart(widget.food, widget.selectedAddons),
            text:"Añadir al carrito",
            ),

            const SizedBox(height: 25),

          ],
        ),
      ),
    ),
      //boton de retroseso
      SafeArea(
        child: Opacity(
          opacity: 0.6,
          child: Container(
          margin:const EdgeInsets.only(left: 25),
            decoration: 
          BoxDecoration(color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
          ),
          child: IconButton
          (icon:const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
          ),
          ),
        ),
      ),
    ],);
  }
}