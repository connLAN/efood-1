import 'package:flutter/material.dart';

// Assuming you have a Table class defined somewhere
class Table {
  final String tableNumber;
  final String tableNickname;
  final int numberOfSeats;
  final String tableStatus;

  Table({
    required this.tableNumber,
    required this.tableNickname,
    required this.numberOfSeats,
    required this.tableStatus,
  });
}

// Assuming you have a TableList class defined somewhere
class TableList {
  final List<Table> tables = [];

  void addTable(Table table) {
    tables.add(table);
  }
}

int tableAccount = 1;

TableList tableList = TableList();

// Add some tables to the table list
void addTables(int tableCount) {
  for (int i = 1; i <= tableCount; i++) {
    tableList.addTable(Table(
      tableNumber: 'T${tableAccount++}',
      tableNickname: 'Table $i',
      numberOfSeats: 4, // Assuming each table has 4 seats
      tableStatus: 'Available', // Setting the status to 'Available'
    ));
  }
}

// TableStatus class
class TableStatus extends StatelessWidget {
  final String status;
  final VoidCallback onNavigate;

  TableStatus({required this.status, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    switch (status) {
      case 'Available':
        color = Colors.green;
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
        color = Colors.grey;
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

// DinningTablesPage widget
class DinningTablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = screenWidth / 8; // Adjust the divisor to change the size

    return Scaffold(
      appBar: AppBar(
        title: Text('Dining Tables'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // 6 items per line
          crossAxisSpacing: 16, // Horizontal margin
          mainAxisSpacing: 16, // Vertical margin
        ),
        itemCount: tableList.tables.length,
        itemBuilder: (context, index) {
          final table = tableList.tables[index];
          Color color;

          switch (table.tableStatus) {
            case 'Available':
              color = Colors.green;
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
              color = Colors.grey;
          }

          return GestureDetector(
            onTap: () {
              // Navigate to the dining tables page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DinningTablesPage()),
              );
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
                    width: itemSize, // Adjust size based on screen width
                    height: itemSize, // Adjust size based on screen width
                    child: FractionallySizedBox(
                      widthFactor:
                          0.6, // Scale the image to 0.6 of the button's width
                      heightFactor:
                          0.6, // Scale the image to 0.6 of the button's height
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
