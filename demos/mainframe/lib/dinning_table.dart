import 'dart:io';

import 'package:flutter/material.dart';
import 'ordering_page.dart'; // Import the OrderingPage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Table {
  final int id;
  final String name;
  final String elegant_name;
  final int capacity;
  final String category_id;
  String table_status;

  VoidCallback? orderPlaced; // Add orderPlaced field

  Table({
    required this.id,
    required this.name,
    required this.elegant_name,
    required this.capacity,
    required this.category_id,
    required this.table_status,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'] ?? 0,
      name: json['name'],
      elegant_name: json['elegant_name'],
      capacity: json['capacity'] ?? 0,
      category_id: json['category_id'],
      table_status: 'available',
    );
  }
}

class TableList {
  final List<Table> tables = [];

  void addTable(Table table) {
    tables.add(table);
  }
}

TableList tableList = TableList();

////////////////////////////////////////

int tableAccount = 1;

// void addTables(int tableCount) {
//   for (int i = 1; i <= tableCount; i++) {
//     tableList.addTable(Table(
//       id: 'T${tableAccount++}',
//       name: 'Table $i',
//       elegant_name: '桌台 $i',
//       capacity: 4,
//       category_id: 'DT',
//       table_status: 'Available',
//     ));
//   }
// }

// void addTable(Table table) {
//   tableList.addTable(table);
// }

//////////////////////////////////////////

// get tables list from http://localhost/all_tables
Future getTables() async {
  try {
    tableList.tables.clear();
    final response =
        await http.get(Uri.parse('http://localhost:3000/tables_all'));

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);

      final List<dynamic> data = json.decode(response.body);
      data.forEach((item) {
        tableList.addTable(Table.fromJson(item));
      });
      print(tableList.tables);
    } else {
      throw Exception('Failed to load tables: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching tables: $e');
    throw Exception('Failed to load tables');
  }
}

class Table_status extends StatelessWidget {
  final String status;
  final VoidCallback onNavigate;

  Table_status({required this.status, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    switch (status) {
      case 'Available':
        color = const Color.fromARGB(255, 246, 246, 246);
        break;
      case 'Reserved':
        color = Colors.yellow;
        break;
      case 'Occupied':
        color = Colors.red;
        break;
      case 'Cleaning':
        color = Colors.blue;
        break;
      case 'Maintenance':
        color = Colors.purple;
        break;
      default:
        color = const Color.fromARGB(255, 233, 231, 109);
    }
    return GestureDetector(
      onTap: onNavigate,
      child: Container(
        color: color,
        child: Center(
          child: Text(
            status,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class DinningTablesPage extends StatefulWidget {
  @override
  _DinningTablesPageState createState() => _DinningTablesPageState();
}

class _DinningTablesPageState extends State<DinningTablesPage> {
  @override
  void initState() {
    super.initState();

    loadTableStatuses();
  }

  Future<void> loadTableStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var table in tableList.tables) {
        table.table_status =
            prefs.getString('table_status_${table.id}') ?? 'Available';
      }
    });
  }

  Future<void> saveTableStatus(Table table) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('table_status_${table.id}', table.table_status);
  }

  Future<void> clearAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    for (var table in tableList.tables) {
      await prefs.remove('orders_${table.id}');
      await prefs.remove('table_status_${table.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = screenWidth / 8;

    return Scaffold(
      appBar: AppBar(
        title: Text('桌台管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await clearAllOrders();
              setState(() {
                for (var table in tableList.tables) {
                  table.table_status = 'Available';
                }
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: tableList.tables.length,
        itemBuilder: (context, index) {
          final table = tableList.tables[index];
          Color color;

          switch (table.table_status) {
            case 'Available':
              color = const Color.fromARGB(255, 246, 204, 204);
              break;
            case 'Reserved':
              color = Colors.yellow;
              break;
            case 'Occupied':
              color = Colors.red;
              break;
            case 'Cleaning':
              color = Colors.blue;
              break;
            case 'Maintenance':
              color = Colors.purple;
              break;
            default:
              color = const Color.fromARGB(255, 129, 169, 122);
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                table.table_status = 'Open';
                saveTableStatus(table);
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderingPage(
                    tableNumber: table.name, // Correct parameter name
                    // onOrderPlaced: table.orderPlaced ?? () {},
                  ),
                ),
              ).then((_) {
                setState(() {
                  // Update the state when coming back from the OrderingPage
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      heightFactor: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/dinning-table.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    table.elegant_name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: color.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
