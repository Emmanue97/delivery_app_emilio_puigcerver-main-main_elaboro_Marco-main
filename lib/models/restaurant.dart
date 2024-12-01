import 'package:collection/collection.dart';
import 'package:delivery_app_emilio_puigcerver/models/cart_item.dart';
import 'package:delivery_app_emilio_puigcerver/models/food.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier{
  //lista del menú de comida
  final List<Food> _menu = [

    //burgers
//hamburguesa con tocino
    Food(name: "Bacon Burger",
      description: "crugientes tiras de bacon ahumado, aderesado con mayonesa y catsup",
      imagePath: "lib/images/burgers/bacon_burger.jpg",
      price: 129.00,
      category: FoodCategory.burguers,
      availableAddons: [
        Addon(name: "Extra tocino", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra cebolla", price: 20.00),
      ]
      ),
// hamburguesa picante
        Food(name: "Burger spicy",
      description: "Aderesada con nuestras salsa secreta de la casa y con la mejor carne de calidad ANGUS deleitarás tu paladar",
      imagePath: "lib/images/burgers/burger_spicy.jpg",
      price: 110.00,
      category: FoodCategory.burguers,
      availableAddons: [
        Addon(name: "Extra tocino", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra cebolla", price: 20.00),
      ]
      ),
//hamburguesa con  queso
        Food(name: "cheese burger",
      description: "Queso monterey jack de la mejor calidad agregando un toque distintivo a nuestra hamburguesa",
      imagePath: "lib/images/burgers/cheese_burger.jpg",
      price: 129.00,
      category: FoodCategory.burguers,
      availableAddons: [
        Addon(name: "Extra Romero", price: 20.00),
        Addon(name: "Extra tamal", price: 40.00),
        Addon(name: "Extra cebolla", price: 60.00),
      ]
      ),
    //salads
      Food(name: "Ensalada campestre",
      description: "seleccionada con nuestras mejores verduras y los tomates mas jugosos que te imagines",
      imagePath: "lib/images/salads/campestre.jpg",
      price: 129.00,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

            Food(name: "Ensalada mediterranea",
      description: "seleccionada con nuestras mejores verduras y los tomates mas jugosos que te imagines",
      imagePath: "lib/images/salads/mediterranean.jpg",
      price: 129.00,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

            Food(name: "Ensalada de pollo",
      description: "seleccionada con nuestras mejores verduras y los tomates mas jugosos que te imagines",
      imagePath: "lib/images/salads/pollo.jpg",
      price: 129.00,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

    //sides
          Food(name: "Aros de cebolla",
      description: "empanizadas con panco japones el cual las hace más crujientes",
      imagePath: "lib/images/sides/onion_rings.jpg",
      price: 129.00,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

          Food(name: "Papas a la francesa",
      description: "empanizadas con panco japones el cual las hace más crujientes",
      imagePath: "lib/images/sides/papas_francesas.jpg",
      price: 19.00,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

          Food(name: "Puré de papa",
      description: "hechas con las mejores papas, seleccionadas manualmente",
      imagePath: "lib/images/sides/pure_de_papa.jpg",
      price: 12.00,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Extra adereso", price: 20.00),
        Addon(name: "Extra queso", price: 20.00),
        Addon(name: "Extra lechuga", price: 20.00),
      ]
      ),

    //desserts
        Food(name: "Postre de chocolate",
      description: "Chocolate originario de cuba y hecha por los mejores reposteros del mundo",
      imagePath: "lib/images/desserts/chocolate_postre.jpg",
      price: 29.00,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra chocolate", price: 20.00),
        Addon(name: "Extra chocolate blanco", price: 20.00),
        Addon(name: "Extra leche", price: 20.00),
      ]
      ),

          Food(name: "flan",
      description: "Chocolate originario de cuba y hecha por los mejores reposteros del mundo",
      imagePath: "lib/images/desserts/flan_postre.jpg",
      price: 110.00,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra chocolate", price: 20.00),
        Addon(name: "Extra chocolate blanco", price: 20.00),
        Addon(name: "Extra leche", price: 20.00),
      ]
      ),

          Food(name: "Postre de fresa",
      description: "hecho con las fresas más frescas de la temporada",
      imagePath: "lib/images/desserts/fresa_postre.jpg",
      price: 129.00,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra chocolate", price: 20.00),
        Addon(name: "Extra chocolate blanco", price: 20.00),
        Addon(name: "Extra leche", price: 20.00),
      ]
      ),

    //drinks
        Food(name: "Coca cola",
      description: "la puedes acompañar con un limoncito",
      imagePath: "lib/images/drinks/coca_bebida.jpg",
      price: 29.00,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Extra hielo", price: 20.00),
        Addon(name: "Extra limón", price: 20.00),
        Addon(name: "Vaso extra", price: 20.00),
      ]
      ),

          Food(name: "New mix",
      description: "la puedes acompañar con un limoncito",
      imagePath: "lib/images/drinks/new_mix_bebida.jpg",
      price: 29.00,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Extra hielo", price: 20.00),
        Addon(name: "Extra limón", price: 20.00),
        Addon(name: "Vaso extra", price: 20.00),
      ]
      ),

          Food(name: "Pepsi",
      description: "la puedes acompañar con un limoncito",
      imagePath: "lib/images/drinks/pepsi_bebida.png",
      price: 129.00,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Extra hielo", price: 20.00),
        Addon(name: "Extra limón", price: 20.00),
        Addon(name: "Vaso extra", price: 20.00),
      ]
      ),
  ];
   
    //usuario del carrito
  final List<CartItem> _cart = [];

  //delivery address
  String _deliveryAddress = 'avenida frankie 99';
  /*
  CAPTADORES (GETTERS)
  */
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  /*
    OPERACIONES
  */

  //añadir carrito
  void addToCart (Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // checar si los iconos de los articulos (item) son iguales
      bool isSameFood = item.food == food;


      // checar si la lista de complementos son iguales
      bool isSameAddons =
        const ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });
    //si el articulo está listo
    if (cartItem !=null) {
      cartItem.quantity++;
    }
    // añadir de  otra manera articulos al carrito
    else {
      _cart.add(
        CartItem(
          food: food, 
          selectedAddons: selectedAddons
        ),
      );
    }
    notifyListeners();
  }

  // quitar del carrito
  void removeFromCart(CartItem cartItem) {
    int cartIndex =  _cart.indexOf(cartItem);

    if(cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  //obtener el total del carrito
  double getTotalPrice () {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  //obtener el numero total de articulos en el carrito
  int getTotalItemCount () {
    int getTotalItemCount = 0;

    for(CartItem cartItem in _cart) {
      getTotalItemCount += cartItem.quantity;
    }

    return getTotalItemCount;
  }

  //vaciar carrito
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
  //modificar la dirección de envio
  void updateDeliveryAddress(String newAddress){
    _deliveryAddress = newAddress;
    notifyListeners();
  }
  /*
  AYUDANTES
  */

  //generar recibo
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Aquí está tu recibo.");
    receipt.writeln();
    //formato de fecha incluido los segundos
    String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

   for (final cartItem in _cart) {
  receipt.writeln(
    "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}"
  );
  if (cartItem.selectedAddons.isNotEmpty) {
    receipt.writeln(
      " complementos: ${_formatAddons(cartItem.selectedAddons)}"
    );
  }
  
  receipt.writeln(); // Añade una línea vacía entre los elementos
}


    receipt.writeln("----------");
      receipt.writeln();
      receipt.writeln("Articulos totales: ${getTotalItemCount()}");
      receipt.writeln("Precio total: ${_formatPrice(getTotalPrice())}");
      receipt.writeln();
      receipt.writeln("Enviar a: $deliveryAddress");
      
      return receipt.toString();
  }

  //formato de pago
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  //format list of addons into a string summary
  String _formatAddons(List<Addon> addons){
    return addons
    .map((addon) => "${addon.name}(${_formatPrice(addon.price)})")
    .join(", ");
  }


}