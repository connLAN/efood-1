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
// int tableCount = 20;

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
      case 'Available': // Changed from 'Close' to 'Available'
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dining Tables'),
      ),
      body: ListView.builder(
        itemCount: tableList.tables.length,
        itemBuilder: (context, index) {
          final table = tableList.tables[index];
          return ListTile(
            title: Text(table.tableNickname),
            subtitle: Text('Seats: ${table.numberOfSeats}'),
            trailing: SizedBox(
              width: 100, // Constrain the width of the trailing widget
              child: TableStatus(
                status: table.tableStatus,
                onNavigate: () {
                  // Navigate to the dining tables page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DinningTablesPage()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
