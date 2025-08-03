import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'models/transaction.dart';
import 'providers/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/add_transaction_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late StompClient stompClient;

  final List<Widget> _pages = const [
    HomeScreen(),
    TransactionsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws',
        onConnect: _onConnect,
        onWebSocketError: (err) => print('Erro WebSocket: $err'),
      ),
    );
    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/transactions',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          final transaction = TransactionModel.fromJson(data);
          Provider.of<TransactionProvider>(context, listen: false)
              .addTransaction(transaction);
        }
      },
    );
  }

  void _addTransaction(TransactionModel transaction) {
    stompClient.send(
      destination: '/app/add-transaction',
      body: jsonEncode(transaction.toJson()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transações'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => AddTransactionSheet(onAdd: _addTransaction),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
