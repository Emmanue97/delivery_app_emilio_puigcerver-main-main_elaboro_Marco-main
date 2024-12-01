import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseBalancePage extends StatefulWidget {
  final String groupId;

  const ExpenseBalancePage({Key? key, required this.groupId}) : super(key: key);

  @override
  _ExpenseBalancePageState createState() => _ExpenseBalancePageState();
}

class _ExpenseBalancePageState extends State<ExpenseBalancePage> {
  List<Map<String, dynamic>> memberBalances = [];
  double totalExpenses = 0;
  double totalSalaries = 0;

  @override
  void initState() {
    super.initState();
    _calculateMemberBalances();
  }

  Future<void> _calculateMemberBalances() async {
    try {
      // Obtener los miembros del grupo
      QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection('member')
          .where('group_id', isEqualTo: widget.groupId)
          .get();

      // Calcular el total de salarios
      totalSalaries = 0;
      for (var member in membersSnapshot.docs) {
        totalSalaries += (member.data() as Map<String, dynamic>)['salary'] as double;
      }

      // Obtener los gastos del grupo
      QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('group_id', isEqualTo: widget.groupId)
          .get();

      // Calcular el total de gastos
      totalExpenses = 0;
      for (var expense in expensesSnapshot.docs) {
        totalExpenses += (expense.data() as Map<String, dynamic>)['amount'] as double;
      }

      // Calcular el balance de cada miembro
      List<Map<String, dynamic>> balances = [];
      for (var member in membersSnapshot.docs) {
        final memberData = member.data() as Map<String, dynamic>;
        double salary = memberData['salary'] as double;
        double proportion = salary / totalSalaries;
        double shouldPay = totalExpenses * proportion;

        balances.add({
          'id': member.id,
          'name': memberData['name'],
          'salary': salary,
          'proportion': proportion,
          'shouldPay': shouldPay,
        });
      }

      setState(() {
        memberBalances = balances;
      });

      // Solo guardamos en Firestore si tenemos un groupId válido
      if (widget.groupId.isNotEmpty) {
        final balanceData = {
          'updated_at': FieldValue.serverTimestamp(),
          'total_expenses': totalExpenses,
          'total_salaries': totalSalaries,
          'member_balances': balances.map((b) => {
            'id': b['id'],
            'name': b['name'],
            'salary': b['salary'],
            'proportion': b['proportion'],
            'shouldPay': b['shouldPay'],
            'timestamp': FieldValue.serverTimestamp(),
          }).toList(),
        };

        // Usar el groupId como identificador del documento
        await FirebaseFirestore.instance
            .collection('balances')
            .doc(widget.groupId)
            .set(balanceData);
      }

    } catch (e) {
      print('Error al calcular balances: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al calcular los balances: $e')),
      );
    }
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
            // Pestaña de Resumen
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
                      _buildInfoRow('Total Gastos:', '\$${totalExpenses.toStringAsFixed(2)}'),
                      _buildInfoRow('Total Salarios:', '\$${totalSalaries.toStringAsFixed(2)}'),
                      const Divider(),
                      const Text(
                        'Distribución por Salarios:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...memberBalances.map((member) => _buildInfoRow(
                        '${member['name']}:',
                        '${(member['proportion'] * 100).toStringAsFixed(1)}%'
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Pestaña de Balances
            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: memberBalances.length,
              itemBuilder: (context, index) {
                final balance = memberBalances[index];
                return Card(
                  child: ListTile(
                    title: Text(balance['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Salario: \$${balance['salary'].toStringAsFixed(2)}'),
                        Text(
                          'Debe pagar: \$${balance['shouldPay'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _calculateMemberBalances,
          tooltip: 'Actualizar balances',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
     ),
);
}
}