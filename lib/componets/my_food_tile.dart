import 'package:delivery_app_emilio_puigcerver/models/food.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({
    super.key,
    required this.food,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row
            (children: [
              //descripcion de los alimentos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text(food.name),
                  Text('\$${food.price}',
                    style: TextStyle
                    (color: Theme.of(context).colorScheme.primary
                    ),
                    ),
                    const SizedBox(height:10),

                  Text(food.description, style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                    ),
                    ),
                ],
              ),
              ),

              const SizedBox(width: 20),

            //food image
            ClipRRect(
              borderRadius: BorderRadius.circular(9), //contorno redondeado de las imagenes
              child: Image.asset(food.imagePath, height: 120,)
            ),
            ],),
          ),
        ),

        //linea divisora
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
          endIndent: 25,
          indent: 25,
          ),
      ],
    );
  }
}