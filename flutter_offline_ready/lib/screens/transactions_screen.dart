import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Transações')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionCard(transaction: transactions[index]);
        },
      ),
    );
  }
}
