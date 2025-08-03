import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.amount >= 0 ? Colors.green : Colors.red,
          child: Text(transaction.amount >= 0 ? '+' : '-'),
        ),
        title: Text(transaction.title),
        subtitle: Text(transaction.category),
        trailing: Text('R\$ ${transaction.amount.toStringAsFixed(2)}'),
      ),
    );
  }
}
