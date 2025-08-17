import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(TransactionModel) onAdd;
  final String username;

  const AddTransactionSheet({
    super.key,
    required this.onAdd,          // <-- FALTAVA ESTA VÍRGULA
    required this.username,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Alimentação';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<TransactionProvider>().categories;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedCategory,
                items: categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final tx = TransactionModel(
                    id: const Uuid().v4(),
                    title: _titleController.text.trim(),
                    amount: double.tryParse(_amountController.text) ?? 0.0,
                    category: _selectedCategory,
                    date: DateTime.now(),
                    user: widget.username, // <-- usa o mesmo user do Home
                  );
                  widget.onAdd(tx);
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
