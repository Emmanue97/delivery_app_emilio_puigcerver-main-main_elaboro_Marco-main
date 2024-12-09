// lib/widgets/expense_tile.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseTile extends StatefulWidget {
  final Map<String, dynamic> expense;
  final DocumentReference expenseRef;

  const ExpenseTile({required this.expense, required this.expenseRef});

  @override
  _ExpenseTileState createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    final expense = widget.expense;
    final bool isMembership = expense['membresia'] ?? false;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          expense['descripcion_gasto'] ?? 'Sin descripción',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Monto: \$${expense['monto']?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Pagado por: ${expense['nombre_miembro'] ?? 'Desconocido'}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Membresía mensual: ${isMembership ? "Sí" : "No"}',
              style: const TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showDetails = !showDetails;
                });
              },
              child: Text(showDetails ? 'Ver menos' : 'Ver más'),
            ),
            if (showDetails) ...[
              const SizedBox(height: 8),
              Text(
                'Fecha de compra: ${expense['fecha_compra']?.toDate().toLocal().toString().split(' ')[0] ?? 'N/A'}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Fecha de pago: ${expense['fecha_pago']?.toDate().toLocal().toString().split(' ')[0] ?? 'N/A'}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Método de pago: ${expense['metodo_pago'] ?? 'Desconocido'}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar eliminación'),
                content: const Text('¿Deseas eliminar este gasto?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await widget.expenseRef.delete();
            }
          },
        ),
      ),
    );
  }
}
