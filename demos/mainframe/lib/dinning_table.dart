import 'package:flutter/material.dart';
import 'ordering_page.dart'; // Import the OrderingPage
import 'package:shared_preferences/shared_preferences.dart';

class Table {
  final String tableNumber;
  final String tableNickname;
  String tableStatus; // Make tableStatus mutable
  VoidCallback? orderPlaced; // Add orderPlaced field

  Table({
    required this.tableNumber,
    required this.tableNickname,
    required this.tableStatus,
  });
}

class TableList {
  final List<Table> tables = [];

  void addTable(Table table) {
    tables.add(table);
  }
}

int tableAccount = 1;

TableList tableList = TableList();

void addTables(int tableCount) {
  for (int i = 1; i <= tableCount; i++) {
    tableList.addTable(Table(
      tableNumber: 'T${tableAccount++}',
      tableNickname: '桌台 $i',
      tableStatus: 'Available',
    ));
  }
}

class TableStatus extends StatelessWidget {
  final String status;
  final VoidCallback onNavigate;

  TableStatus({required this.status, required this.onNavigate});

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
        table.tableStatus =
            prefs.getString('table_status_${table.tableNumber}') ?? 'Available';
      }
    });
  }

  Future<void> saveTableStatus(Table table) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'table_status_${table.tableNumber}', table.tableStatus);
  }

  Future<void> clearAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    for (var table in tableList.tables) {
      await prefs.remove('orders_${table.tableNumber}');
      await prefs.remove('table_status_${table.tableNumber}');
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
                  table.tableStatus = 'Available';
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

          switch (table.tableStatus) {
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
                table.tableStatus = 'Open';
                saveTableStatus(table);
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderingPage(
                    tableNumber: table.tableNumber, // Correct parameter name
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
                    table.tableNickname,
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
