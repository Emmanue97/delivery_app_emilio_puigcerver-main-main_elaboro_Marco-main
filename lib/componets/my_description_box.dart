import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    //estilo de texto 
    var myPrimaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary);
      var mySecondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      margin:const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // este es el apartado de los gastos de envio
          Column(
            children: [
              Text('\$20.00', style: myPrimaryTextStyle,),
              Text('Gastos de envio', style: mySecondaryTextStyle,),
            ],
          ),
          // este apartado es del tiempo de entrega / envio 
          Column(
            children: [
              Text('20-30 min', style: myPrimaryTextStyle,),
              Text('Tiempo estimado de entrega',style: mySecondaryTextStyle,),
            ],
          ),
        ],
      ),
    );
  }
}