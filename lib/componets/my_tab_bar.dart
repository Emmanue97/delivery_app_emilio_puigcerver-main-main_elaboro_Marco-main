import 'package:delivery_app_emilio_puigcerver/models/food.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({
    super.key,
    required this.tabController,
  });

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(
        text: category.toString().split('.').last,
      );
    }).toList();
  }

@override
Widget build(BuildContext context) {
  return Container(
    color: Colors.white, // Ejemplo de estilo añadido
    padding: const EdgeInsets.all(8.0),
    child: TabBar(
      controller: tabController,
      tabs: _buildCategoryTabs(),
    ),
  );
}
}

