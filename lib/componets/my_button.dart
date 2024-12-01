import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final Function ()? onTap;
  final String text;


  const MyButton ({
    super.key,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          //esta línea sirve para los bordes del botón de ingresar
          borderRadius: BorderRadius.circular(9),
          ),
      child: Center(
        child: Text (
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 18,

          ),
        ),
      ),
      ),
    );
  }
}
