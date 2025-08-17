import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../providers/transaction_provider.dart';
import 'dart:convert';
import '../widgets/add_transaction_sheet.dart';
import '../models/transaction.dart'; 

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StompClient stompClient;

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws',
        onConnect: _onConnect,
        onWebSocketError: (err) => debugPrint('WS error: $err'),
      ),
    );
    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/transactions',
      callback: (frame) {
        if (frame.body != null) {
          debugPrint("New transaction: ${frame.body}");
          // Se quiser refletir em tempo real:
          // final data = jsonDecode(frame.body!);
          // context.read<TransactionProvider>().addTransaction(
          //   TransactionModel.fromJson(data),
          // );
        }
      },
    );
  }

  void _openAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddTransactionSheet(
              username: widget.username,
              onAdd: (TransactionModel tx) {
                // Envia para o backend via STOMP
                stompClient.send(
                  destination: '/app/add-transaction',
                  body: jsonEncode(tx.toJson()),
                );
                // Atualiza a UI local imediatamente (opcional)
                context.read<TransactionProvider>().addTransaction(tx);
              },
            ),
          ),
        );
      },
    );
  }

  /// Exemplo de envio rápido sem abrir o sheet (se quiser testar)
  void _sendQuickTransaction() {
    final transaction = {
      "id": DateTime.now().toIso8601String(),
      "title": "New Expense",
      "amount": -50,
      "category": "Food",
      "date": DateTime.now().toIso8601String(),
      "user": widget.username,
    };
    stompClient.send(
      destination: '/app/add-transaction',
      body: jsonEncode(transaction),
    );
  }

  @override
  void dispose() {
    if (stompClient.connected) {
      stompClient.deactivate();
    }
    super.dispose();
  }

  // ---- Helpers de cálculo ----
  double _computeBalance(List<TransactionModel> txs) {
    // saldo = soma de todas as amounts
    return txs.fold(0.0, (acc, t) => acc + (t.amount));
  }

  double _computeTotalSpent(List<TransactionModel> txs) {
    // total gasto = soma dos valores negativos (em valor absoluto)
    return txs
        .where((t) => t.amount < 0)
        .fold(0.0, (acc, t) => acc + t.amount.abs());
  }

  List<TransactionModel> _lastTwo(List<TransactionModel> txs) {
    if (txs.isEmpty) return [];
    // Ordena por data desc para garantir últimas
    final sorted = [...txs]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text('Hello ${widget.username}')),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final txs = provider.transactions;
          final balance = _computeBalance(txs);
          final spent = _computeTotalSpent(txs);
          final last2 = _lastTwo(txs);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumo: Saldo e Total Gasto
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Saldo', style: TextStyle(fontSize: 14, color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(balance),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: balance >= 0 ? Colors.green[700] : Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total gasto', style: TextStyle(fontSize: 14, color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(spent),
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Últimas 2 transações
              const Text(
                'Últimas transações',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              if (last2.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Ainda não há transações.'),
                  ),
                )
              else
                ...last2.map((t) {
                  final isOut = t.amount < 0;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isOut ? Colors.red[100] : Colors.green[100],
                        child: Icon(
                          isOut ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isOut ? Colors.red[800] : Colors.green[800],
                        ),
                      ),
                      title: Text(t.title),
                      subtitle: Text('${t.category} • ${dateFmt.format(t.date)}'),
                      trailing: Text(
                        (isOut ? '-' : '+') + currency.format(t.amount.abs()),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isOut ? Colors.red[800] : Colors.green[800],
                        ),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 80), // espaço pro FAB
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
