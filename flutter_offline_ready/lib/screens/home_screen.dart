import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final expenseData = provider.expenseByCategory;

    return Scaffold(
      appBar: AppBar(title: const Text('Visão Geral')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Saldo: R\$ ${provider.totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: expenseData.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      color: Colors.primaries[expenseData.keys.toList().indexOf(e.key) % Colors.primaries.length],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
