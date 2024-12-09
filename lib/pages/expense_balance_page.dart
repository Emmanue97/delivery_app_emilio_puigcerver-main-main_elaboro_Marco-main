// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart'; // Importar fl_chart

// class ExpenseBalancePage extends StatefulWidget {
//   final String groupId;

//   const ExpenseBalancePage({Key? key, required this.groupId}) : super(key: key);

//   @override
//   _ExpenseBalancePageState createState() => _ExpenseBalancePageState();
// }

// class _ExpenseBalancePageState extends State<ExpenseBalancePage> {
//   List<Map<String, dynamic>> memberBalances = [];
//   List<Map<String, dynamic>> categoryExpenses =
//       []; // Lista para almacenar los gastos por categoría
//   double totalExpenses = 0;
//   double totalSalaries = 0;

//   @override
//   void initState() {
//     super.initState();
//     _calculateMemberBalances();
//     _getCategoryExpenses(); // Obtener los gastos por categoría
//   }

//   Future<void> _calculateMemberBalances() async {
//     try {
//       // Obtener los miembros del grupo
//       QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
//           .collection('member')
//           .where('group_id', isEqualTo: widget.groupId)
//           .get();

//       // Calcular el total de salarios
//       totalSalaries = 0;
//       for (var member in membersSnapshot.docs) {
//         totalSalaries +=
//             (member.data() as Map<String, dynamic>)['salary'] as double;
//       }

//       // Obtener los gastos del grupo
//       QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
//           .collection('expenses')
//           .where('group_id', isEqualTo: widget.groupId)
//           .get();

//       // Calcular el total de gastos
//       totalExpenses = 0;
//       for (var expense in expensesSnapshot.docs) {
//         totalExpenses +=
//             (expense.data() as Map<String, dynamic>)['amount'] as double;
//       }

//       // Calcular el balance de cada miembro
//       List<Map<String, dynamic>> balances = [];
//       for (var member in membersSnapshot.docs) {
//         final memberData = member.data() as Map<String, dynamic>;
//         double salary = memberData['salary'] as double;
//         double proportion = salary / totalSalaries;
//         double shouldPay = totalExpenses * proportion;
//         shouldPay = shouldPay.isNaN || shouldPay.isNegative ? 0 : shouldPay;

//         balances.add({
//           'id': member.id,
//           'name': memberData['name'],
//           'salary': salary,
//           'proportion': proportion,
//           'shouldPay': shouldPay,
//         });
//       }

//       setState(() {
//         memberBalances = balances;
//       });
//     } catch (e) {
//       print('Error al calcular balances: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al calcular los balances: $e')),
//       );
//     }
//   }

//   // Obtener los gastos por categoría
//   Future<void> _getCategoryExpenses() async {
//     try {
//       final now = DateTime.now();
//       final firstDayOfMonth = DateTime(now.year, now.month, 1);
//       final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

//       // Obtener los gastos dentro del mes seleccionado
//       QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
//           .collection('expenses')
//           .where('group_id', isEqualTo: widget.groupId)
//           .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
//           .where('date', isLessThanOrEqualTo: lastDayOfMonth)
//           .get();

//       // Agrupar los gastos por categoría
//       Map<String, double> categoryTotals = {};
//       for (var expense in expensesSnapshot.docs) {
//         final data = expense.data() as Map<String, dynamic>;
//         final category =
//             data['category'] ?? 'Sin categoría'; // Obtener categoría
//         final amount = data['amount'] ?? 0.0; // Obtener cantidad gastada

//         categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
//       }

//       // Convertir los datos de categorías a una lista
//       setState(() {
//         categoryExpenses = categoryTotals.entries
//             .map((entry) => {'category': entry.key, 'total': entry.value})
//             .toList();
//       });
//     } catch (e) {
//       print('Error al obtener gastos por categoría: $e');
//     }
//   }

//   // Función para crear el gráfico de pastel para salarios vs lo que deben pagar
//   Widget _buildSalaryVsPayPieChart() {
//     return SizedBox(
//       height: 250, // Ajusta la altura del gráfico según necesites
//       child: PieChart(
//         PieChartData(
//           sectionsSpace: 0, // Espacio entre las secciones del pastel
//           centerSpaceRadius:
//               40, // Radio del espacio central, para mayor claridad
//           sections: memberBalances.map((member) {
//             double salary = member['salary'];
//             double shouldPay = member['shouldPay'];

//             return PieChartSectionData(
//               value: salary, // Este valor representa el salario
//               color: Color.fromARGB(
//                   160, 169, 169, 169), // Color verde para el salario
//               title: '${member['name']} - \$${salary.toStringAsFixed(2)}',
//               radius: 50, // Tamaño del círculo
//               showTitle: true,
//               titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
//             );
//           }).toList()
//             ..addAll(memberBalances.map((member) {
//               double salary = member['salary'];
//               double shouldPay = member['shouldPay'];

//               return PieChartSectionData(
//                 value: shouldPay, // Este valor representa lo que deben pagar
//                 color:
//                     Colors.blue.shade900, // Color rojo para lo que deben pagar
//                 title: '${member['name']} - \$${shouldPay.toStringAsFixed(2)}',
//                 radius: 50, // Tamaño del círculo
//                 showTitle: true,
//                 titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
//               );
//             }).toList()),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Balance de Gastos'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Resumen'),
//               Tab(text: 'Balances'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Pestaña de Resumen con gráficos
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Resumen General',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoRow('Total Gastos:',
//                           '\$${totalExpenses.toStringAsFixed(2)}'),
//                       _buildInfoRow('Total Salarios:',
//                           '\$${totalSalaries.toStringAsFixed(2)}'),
//                       const Divider(),
//                       const Text(
//                         'Distribución por Salarios:',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       ...memberBalances
//                           .map((member) => _buildInfoRow('${member['name']}:',
//                               '${(member['proportion'] * 100).toStringAsFixed(1)}%' // Mostrar proporción como porcentaje
//                               ))
//                           .toList(),

//                       // Aquí agregamos el gráfico de distribución de gastos por miembro
//                       const SizedBox(height: 16),
//                       const Text('Distribución de Gastos por Miembro',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _buildExpenseDistributionChart(),

//                       // Aquí agregamos el gráfico de distribución de gastos por categoría
//                       const SizedBox(height: 16),
//                       const Text('Distribución Mensual de Gastos por Categoría',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _buildCategoryExpenseChart(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Pestaña de Balances con gráfico de pastel
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Distribución de Salarios y Pagos',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildSalaryVsPayPieChart(), // Este es el gráfico de pastel
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Detalles de Balances por Miembro',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   // Lista de miembros y sus balances
//                   ListView.builder(
//                     shrinkWrap:
//                         true, // Para que la lista no ocupe todo el espacio disponible
//                     physics:
//                         const NeverScrollableScrollPhysics(), // Desactivar el desplazamiento para evitar conflicto con SingleChildScrollView
//                     itemCount: memberBalances.length,
//                     itemBuilder: (context, index) {
//                       final balance = memberBalances[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: ListTile(
//                           title: Text(
//                             balance['name'],
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   'Salario: \$${balance['salary'].toStringAsFixed(2)}'),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Debe pagar: \$${balance['shouldPay'].toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _calculateMemberBalances,
//           tooltip: 'Actualizar balances',
//           child: const Icon(Icons.refresh),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   // Función para crear el gráfico de distribución de gastos por miembro
//   Widget _buildExpenseDistributionChart() {
//     return SizedBox(
//       height: 250, // Ajusta la altura del gráfico según necesites
//       child: BarChart(
//         BarChartData(
//           titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   int index = value.toInt();
//                   if (index < 0 || index >= memberBalances.length) {
//                     return const Text('');
//                   }
//                   final member = memberBalances[index];
//                   return Text(
//                     member['name'], // Mostrar nombre del miembro
//                     style: const TextStyle(fontSize: 10),
//                   );
//                 },
//               ),
//             ),
//           ),
//           gridData: FlGridData(show: true),
//           borderData: FlBorderData(show: true),
//           barGroups: memberBalances.asMap().entries.map((entry) {
//             int index = entry.key;
//             Map<String, dynamic> member = entry.value;

//             return BarChartGroupData(
//               x: index, // Usar el índice como identificador único
//               barRods: [
//                 BarChartRodData(
//                   toY: member['proportion'] * 100, // Proporción como porcentaje
//                   color: Colors.blue, // Cambia el color si es necesario
//                   width: 15,
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   // Función para crear el gráfico de distribución mensual de gastos por categoría
//   Widget _buildCategoryExpenseChart() {
//     return SizedBox(
//       height: 250, // Ajusta la altura del gráfico según lo necesites
//       child: BarChart(
//         BarChartData(
//           titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   switch (value.toInt()) {
//                     case 0:
//                       return const Text('Gastos',
//                           style: TextStyle(fontSize: 12));
//                     case 1:
//                       return const Text('Salarios',
//                           style: TextStyle(fontSize: 12));
//                     default:
//                       return const Text('');
//                   }
//                 },
//               ),
//             ),
//           ),
//           gridData: FlGridData(show: true),
//           borderData: FlBorderData(show: true),
//           barGroups: [
//             BarChartGroupData(
//               x: 0, // Índice para la barra de Gastos
//               barRods: [
//                 BarChartRodData(
//                   toY: totalExpenses, // Valor total de gastos
//                   color: Colors.red, // Color rojo para gastos
//                   width: 15,
//                 ),
//               ],
//             ),
//             BarChartGroupData(
//               x: 1, // Índice para la barra de Salarios
//               barRods: [
//                 BarChartRodData(
//                   toY: totalSalaries, // Valor total de salarios
//                   color: Colors.green, // Color verde para salarios
//                   width: 15,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Importar fl_chart

class ExpenseBalancePage extends StatefulWidget {
  final String groupId;

  const ExpenseBalancePage({Key? key, required this.groupId}) : super(key: key);

  @override
  _ExpenseBalancePageState createState() => _ExpenseBalancePageState();
}

class _ExpenseBalancePageState extends State<ExpenseBalancePage> {
  List<Map<String, dynamic>> memberBalances = [];
  List<Map<String, dynamic>> categoryExpenses = [];
  double totalExpenses = 0;
  double totalSalaries = 0;
  double monthlyGoal = 0; // Meta mensual del grupo
  double monthlyProgress = 0; // Progreso de gastos mensuales

  @override
  void initState() {
    super.initState();
    _calculateMemberBalances();
    _getCategoryExpenses(); // Obtener los gastos por categoría
    _getMonthlyGoal(); // Obtener la meta mensual
  }

  Future<void> _calculateMemberBalances() async {
    try {
      // Obtener los miembros del grupo usando arrayContains para un campo tipo array
      QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('id_grupo', arrayContains: widget.groupId)
          .get();

      print("Miembros obtenidos: ${membersSnapshot.docs.length}");

      // Calcular el total de salarios
      totalSalaries = 0;
      for (var member in membersSnapshot.docs) {
        final memberData = member.data() as Map<String, dynamic>;
        double salary = (memberData['salario'] is int)
            ? (memberData['salario'] as int).toDouble()
            : (memberData['salario'] as double? ??
                0.0); // Asegurarse de que sea double

        print("Miembro: ${memberData['nombre']}, Salario: $salary");

        totalSalaries += salary;
      }

      // Obtener los gastos del grupo
      QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
          .collection('gastos')
          .where('id_grupo', isEqualTo: widget.groupId)
          .get();

      // Calcular el total de gastos
      totalExpenses = 0;
      for (var expense in expensesSnapshot.docs) {
        double expenseAmount =
            (expense.data() as Map<String, dynamic>)['monto'];
        // Asegúrate de que el monto sea double
        expenseAmount =
            (expenseAmount is int) ? expenseAmount.toDouble() : expenseAmount;
        totalExpenses += expenseAmount;
      }

      // Calcular el balance de cada miembro
      List<Map<String, dynamic>> balances = [];
      for (var member in membersSnapshot.docs) {
        final memberData = member.data() as Map<String, dynamic>;
        double salary = (memberData['salario'] is int)
            ? (memberData['salario'] as int).toDouble()
            : (memberData['salario'] as double? ??
                0.0); // Asegurarse de que sea double

        double proportion = salary / totalSalaries;
        double shouldPay = totalExpenses * proportion;
        shouldPay = shouldPay.isNaN || shouldPay.isNegative ? 0 : shouldPay;

        balances.add({
          'id': member.id,
          'name': memberData['nombre'],
          'salary': salary,
          'proportion': proportion,
          'shouldPay': shouldPay,
        });
      }

      setState(() {
        memberBalances = balances;
      });
    } catch (e) {
      print('Error al calcular balances: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al calcular los balances: $e')),
      );
    }
  }

  // Obtener los gastos por categoría
  Future<void> _getCategoryExpenses() async {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Obtener los gastos dentro del mes seleccionado
      QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
          .collection('gastos')
          .where('id_grupo', isEqualTo: widget.groupId)
          .where('fecha_compra', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('fecha_compra', isLessThanOrEqualTo: lastDayOfMonth)
          .get();

      // Agrupar los gastos por categoría
      Map<String, double> categoryTotals = {};
      for (var expense in expensesSnapshot.docs) {
        final data = expense.data() as Map<String, dynamic>;
        final category =
            data['categoria'] ?? 'Sin categoría'; // Obtener categoría
        final amount = data['monto'] ?? 0.0; // Obtener cantidad gastada

        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
      }

      // Convertir los datos de categorías a una lista
      setState(() {
        categoryExpenses = categoryTotals.entries
            .map((entry) => {'category': entry.key, 'total': entry.value})
            .toList();
      });
    } catch (e) {
      print('Error al obtener gastos por categoría: $e');
    }
  }

  // Obtener la meta mensual
  Future<void> _getMonthlyGoal() async {
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('grupos')
          .doc(widget.groupId)
          .get();

      if (groupSnapshot.exists) {
        setState(() {
          monthlyGoal =
              (groupSnapshot.data() as Map<String, dynamic>)['meta_mensual'] ??
                  0;
          monthlyProgress = totalExpenses;
        });
      }
    } catch (e) {
      print('Error al obtener la meta mensual: $e');
    }
  }

  // Gráfico circular para salarios vs lo que deben pagar
  final List<Color> colorList = Colors.primaries;  // Usar colores predefinidos de Flutter

// Gráfico circular para salarios vs lo que deben pagar
Widget _buildSalaryVsPayPieChart() {
  return SizedBox(
    height: 250,
    child: PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: memberBalances.asMap().entries.map((entry) {
          int index = entry.key;  // Obtener el índice del miembro
          Map<String, dynamic> member = entry.value;
          double salary = member['salary'];
          double shouldPay = member['shouldPay'];

          // Asignar un color de la lista basado en el índice del miembro
          Color color = colorList[index % colorList.length];  // Evita desbordamientos si hay más miembros que colores

          return [
            PieChartSectionData(
              value: salary,
              color: Colors.green,  // Color fijo para el salario
              title: '${member['name']} - \$${salary.toStringAsFixed(2)}',
              radius: 50,
              showTitle: true,
              titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
            ),
            PieChartSectionData(
              value: shouldPay,
              color: color,  // Color único para "shouldPay"
              title: '${member['name']} - \$${shouldPay.toStringAsFixed(2)}',
              radius: 50,
              showTitle: true,
              titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ];
        }).expand((element) => element).toList(),  // Expandir las dos secciones por miembro en una lista
      ),
    ),
  );
}


  // Gráfico de distribución de gastos por miembro
  Widget _buildExpenseDistributionChart() {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData:
              FlTitlesData(show: true), // Aquí es donde defines los títulos
          barGroups: memberBalances.map((member) {
            double shouldPay = member['shouldPay'];
            return BarChartGroupData(
              x: memberBalances.indexOf(member),
              barRods: [
                BarChartRodData(
                  fromY: 0.0, // Define el valor de inicio en Y
                  toY: shouldPay.toDouble(), // Define el valor de fin en Y
                  color: Colors.blue.shade900, // Color de la barra
                  width: 16,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Gráfico de distribución de gastos por categoría
  Widget _buildCategoryExpenseChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: categoryExpenses.map((category) {
            double total = category['total'];
            return PieChartSectionData(
              value: total,
              color: Colors.primaries[
                  categoryExpenses.indexOf(category) % Colors.primaries.length],
              title: '${category['category']} - \$${total.toStringAsFixed(2)}',
              radius: 50,
              showTitle: true,
              titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Balance de Gastos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Resumen'),
              Tab(text: 'Balances'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Resumen
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen General',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Total Gastos:',
                          '\$${totalExpenses.toStringAsFixed(2)}'),
                      _buildInfoRow('Total Salarios:',
                          '\$${totalSalaries.toStringAsFixed(2)}'),
                      const Divider(),
                      const Text('Distribución por Salarios:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...memberBalances
                          .map((member) => _buildInfoRow('${member['name']}:',
                              '${(member['proportion'] * 100).toStringAsFixed(1)}%'))
                          .toList(),
                      const SizedBox(height: 16),
                      const Text('Distribución de Gastos por Miembro',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildExpenseDistributionChart(),
                      const SizedBox(height: 16),
                      const Text('Distribución Mensual de Gastos por Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildCategoryExpenseChart(),
                    ],
                  ),
                ),
              ),
            ),

            // Balances
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Distribución de Salarios y Pagos',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildSalaryVsPayPieChart(),
                  const SizedBox(height: 16),
                  const Text('Detalles de Balances por Miembro',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: memberBalances.length,
                    itemBuilder: (context, index) {
                      final balance = memberBalances[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            balance['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Debería pagar: \$${(balance['shouldPay'] as double).toStringAsFixed(2)}', // Limitar a 2 decimales
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
