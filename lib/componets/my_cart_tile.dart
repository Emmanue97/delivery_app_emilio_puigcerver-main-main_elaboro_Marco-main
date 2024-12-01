import 'package:delivery_app_emilio_puigcerver/componets/my_quantity_selector.dart';
import 'package:delivery_app_emilio_puigcerver/models/cart_item.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key,required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant> (
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius:  BorderRadius.circular(8)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //imagen de la comida
              ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                width: 200,
                height: 125,
                child: Image.asset(
                  cartItem.food.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
                //nombre y precio de la comida
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  //nombre de la comida
                  Text(cartItem.food.name),
            
                  //precio de la comida
                  Text('\$${cartItem.food.price}',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
                ),
                const Spacer(),
            
                //incremento o decremento (cantidad)
                MyQuantitySelector(
                  quantity: cartItem.quantity, 
                  food: cartItem.food, 
                  onDecrement: () {
                    restaurant.removeFromCart(cartItem);
                  }, 
                  onIncrement: () {
                    restaurant.addToCart(
                      cartItem.food, cartItem.selectedAddons
                      );
                  },
                  ),
              ],
            ),
          ),
          //addons
          SizedBox(
            height: cartItem.selectedAddons.isEmpty ? 0 : 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              children: cartItem.selectedAddons
              .map(
                (addon) => Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: FilterChip(
                    label: Row(
                  children: [
                    //addon name
                    Text(addon.name),
                    //addon price
                    Text('(\$${addon.price})'),
                  ],
                                ),
                                shape: StadiumBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary
                  )
                                ),
                                onSelected: (value){},
                                backgroundColor:
                  Theme.of(context).colorScheme.secondary,
                                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 15,
                                ),

                                ),
                ),
              )
              .toList(),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

