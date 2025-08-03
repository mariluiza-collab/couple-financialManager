import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final data = provider.expenseByCategory;

    if (data.isEmpty) {
      return const Center(child: Text('Nenhuma despesa registrada.'));
    }

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    int colorIndex = 0;

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: data.entries.map((entry) {
            final color = colors[colorIndex % colors.length];
            colorIndex++;
            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: entry.key,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            );
          }).toList(),
        ),
      ),
    );
  }
}
