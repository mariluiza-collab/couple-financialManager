import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final List<String> categories = ['Alimentação', 'Transporte', 'Lazer', 'Saúde', 'Outros'];

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  double get totalBalance =>
      _transactions.fold(0.0, (sum, t) => sum + t.amount);

  Map<String, double> get expenseByCategory {
    final Map<String, double> data = {};
    for (var t in _transactions.where((t) => t.amount < 0)) {
      data[t.category] = (data[t.category] ?? 0) + t.amount.abs();
    }
    return data;
  }
}
