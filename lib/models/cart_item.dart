import 'package:delivery_app_emilio_puigcerver/models/food.dart';
class CartItem {
  Food food;
  List<Addon> selectedAddons;
  int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
    });
    //este apartado sirve para sacar el precio total del pedido
    double get totalPrice {
      double addonsPrice = selectedAddons.fold(0,(sum, addon) => sum + addon.price);
      return (food.price + addonsPrice) * quantity;
    }

}