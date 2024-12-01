//articulos de la comida
class Food {
  final String name;          //hamburguesa con queso
  final String description;   // hamburguesa llena de queso
  final String imagePath;     // lib/images/cheese_burger.png
  final double price;         // 129.00
  final FoodCategory category;//hambuerguesa
  List<Addon> availableAddons;// [extra queso,]

  Food ({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,

  });

}

// este apartado es para la categoria de las comidas

enum FoodCategory {
  burguers,
  salads,
  sides,
  desserts,
  drinks,
}

//apartado de los complemetos de las comidas
class Addon{
  String name;
  double price;

  Addon ({
    required this.name,
    required this.price,
  });
}
