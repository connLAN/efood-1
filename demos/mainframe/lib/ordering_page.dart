import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'menu_service.dart';
import 'clock.dart';

class OrderingPage extends StatefulWidget {
  final String tableNumber;

  OrderingPage({required this.tableNumber});

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  Map<String, int> selectedDishesQuantities = {};
  List<Map<String, dynamic>> menu = [];
  Set<String> selectedDishes = {};
  String tableStatus = 'available'; // Default table status

  @override
  void initState() {
    super.initState();
    loadMenu();
    loadOrders();
    loadTableStatus();
  }

  Future<void> loadMenu() async {
    try {
      final data = await MenuService.loadMenu();
      setState(() {
        menu = List<Map<String, dynamic>>.from(data);
        menu.insert(0, {
          'category': '全部',
          'dishes': menu.expand((category) => category['dishes']).toList(),
        });
      });
    } catch (e) {
      print('Error loading menu: $e');
    }
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getString('orders_${widget.tableNumber}');
    if (orders != null) {
      setState(() {
        selectedDishesQuantities = Map<String, int>.from(json.decode(orders));
        selectedDishes = selectedDishesQuantities.keys.toSet();
      });
    }
  }

  Future<void> loadTableStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatus = prefs.getString('table_status_${widget.tableNumber}');
    if (savedStatus != null) {
      setState(() {
        tableStatus = savedStatus;
      });
    }
  }

  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'orders_${widget.tableNumber}', json.encode(selectedDishesQuantities));
    await prefs.setString('table_status_${widget.tableNumber}', tableStatus);
  }

  void _toggleSelection(String dishName) {
    setState(() {
      if (selectedDishes.contains(dishName)) {
        selectedDishes.remove(dishName);
      } else {
        selectedDishes.add(dishName);
      }
      _increment(dishName);
    });
  }

  void _increment(String dishName) {
    setState(() {
      selectedDishesQuantities[dishName] =
          (selectedDishesQuantities[dishName] ?? 0) + 1;
      saveOrders();
    });
  }

  void _decrement(String dishName) {
    setState(() {
      if (selectedDishesQuantities[dishName] != null &&
          selectedDishesQuantities[dishName]! > 0) {
        selectedDishesQuantities[dishName] =
            selectedDishesQuantities[dishName]! - 1;
        if (selectedDishesQuantities[dishName] == 0) {
          selectedDishes.remove(dishName);
        }
        saveOrders();
      }
    });
  }

  int _getTotalDishes() {
    return selectedDishesQuantities.values
        .fold(0, (sum, quantity) => sum + quantity);
  }

  double _getTotalAmount() {
    double total = 0.0;
    selectedDishesQuantities.forEach((dishName, quantity) {
      var dish = menu
          .expand((category) => category['dishes'])
          .firstWhere((dish) => dish['name'] == dishName);
      total += dish['price'] * quantity;
    });
    return total;
  }

  Future<void> _updateTableStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tableStatus = status;
    });
    await prefs.setString('table_status_${widget.tableNumber}', status);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: menu.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('点餐 - 桌台 ${widget.tableNumber}'),
          bottom: TabBar(
            isScrollable: true,
            tabs: menu.map((category) {
              return Tab(text: category['category']);
            }).toList(),
          ),
        ),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: TabBarView(
                children: menu.map((category) {
                  var dishes = category['dishes'];
                  return GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      var dish = dishes[index];
                      var dishName = dish['name'];
                      var isSelected = selectedDishes.contains(dishName);
                      var quantity = selectedDishesQuantities[dishName] ?? 0;
                      return GestureDetector(
                        onTap: () => _toggleSelection(dishName),
                        onSecondaryTap: () => _decrement(dishName),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () => _toggleSelection(dishName),
                            style: TextButton.styleFrom(
                              backgroundColor: quantity > 0
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dishName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        '¥${dish['price']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 8.0,
                                  right: 8.0,
                                  child: Text(
                                    '${quantity.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Text('Table Status: $tableStatus'),
                  // Text('金钥匙烤鸭店\n桌台 ${widget.tableNumber}\n时间：${Clock()}'),
                  Text('金钥匙烤鸭店\n桌台 ${widget.tableNumber}\n'
                      '${Clock().getCurrentDateTimeInChineseStyle()}'),

                  Expanded(
                    child: ListView(
                      children: selectedDishesQuantities.entries.map((entry) {
                        var dishName = entry.key;
                        var quantity = entry.value;
                        var dish = menu
                            .expand((category) => category['dishes'])
                            .firstWhere((dish) => dish['name'] == dishName);
                        return ListTile(
                          title: Text('$dishName x $quantity'),
                          subtitle: Text('¥${dish['price'] * quantity}'),
                        );
                      }).toList(),
                    ),
                  ),

                  // total dishes and amount
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('菜品小计: ${_getTotalDishes()}'),
                        Text('金额小计: ¥${_getTotalAmount().toStringAsFixed(2)}'),
                      ],
                    ),
                  ),

                  // Add a button to update the table status
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 16.0), // Add bottom margin
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('立刻下单！'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
