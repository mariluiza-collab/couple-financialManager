import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final List<String> categories = ['Alimentação', 'Transporte', 'Lazer', 'Saúde', 'Outros'];

  IOWebSocketChannel? _channel;

  void initWebSocket() {
    _channel = IOWebSocketChannel.connect('ws://SEU_BACKEND:8080/ws'); // Ajuste a URL

    _channel!.stream.listen((message) {
      final data = jsonDecode(message);
      final newTx = TransactionModel.fromJson(data);
      addTransaction(newTx);
      debugPrint("Nova transação recebida: ${data}");
    });
  }

  void disposeWebSocket() {
    _channel?.sink.close(status.goingAway);
  }

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
