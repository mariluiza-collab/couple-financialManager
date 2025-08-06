import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../providers/transaction_provider.dart';
import 'dart:convert';

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
      ),
    );
    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/transactions',
      callback: (frame) {
        if (frame.body != null) {
          print("New transaction: ${frame.body}");
        }
      },
    );
  }

  void _sendTransaction() {
    final transaction = {
      "id": DateTime.now().toIso8601String(),
      "title": "New Expense",
      "amount": -50,
      "category": "Food",
      "date": DateTime.now().toString(),
      "user": widget.username
    };
    stompClient.send(destination: '/app/add-transaction', body: jsonEncode(transaction));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello ${widget.username}')),
      body: Center(child: ElevatedButton(onPressed: _sendTransaction, child: const Text("Add Transaction"))),
    );
  }
}
