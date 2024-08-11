import 'package:flutter/material.dart';
import 'menu_service.dart';

class OrderingPage extends StatefulWidget {
  final String tableIndex;
  final String tableNickName;
  final VoidCallback onOrderPlaced;

  OrderingPage({
    required this.tableIndex,
    required this.tableNickName,
    required this.onOrderPlaced,
  });

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  // 已选菜品及其数量
  Map<String, int> selectedDishesQuantities = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordering Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Table Index: ${widget.tableIndex}'),
            Text('Table Nickname: ${widget.tableNickName}'),
            ElevatedButton(
              onPressed: widget.onOrderPlaced,
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget onTableButtonClicked(String tableIndex, String tableNickName, VoidCallback onOrderPlaced) {
  return MaterialApp(
    title: 'Shopping Cart',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: OrderingPage(
      tableIndex: tableIndex,
      tableNickName: tableNickName,
      onOrderPlaced: onOrderPlaced,
    ),
  );
}