import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(TransactionModel) onAdd;

  const AddTransactionSheet({super.key, required this.onAdd});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Alimentação';

  @override
  Widget build(BuildContext context) {
    final categories = context.read<TransactionProvider>().categories;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Valor'),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: _selectedCategory,
            items: categories.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) {
              setState(() => _selectedCategory = val!);
            },
          ),
          ElevatedButton(
            onPressed: () {
              final transaction = TransactionModel(
                id: const Uuid().v4(),
                title: _titleController.text,
                amount: double.tryParse(_amountController.text) ?? 0.0,
                category: _selectedCategory,
                date: DateTime.now(),
              );
              widget.onAdd(transaction);
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
