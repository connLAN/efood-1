import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ordering_page.dart';
import 'dinning_table.dart';

class Table {
  final String id;
  String table_status;

  Table({required this.id, this.table_status = 'Available'});
}

class TableList {
  final List<Table> tables;

  TableList({required this.tables});
}

class TableCategory {
  final int id;
  final String category_id;
  final String name;
  final TableList table_list;

  TableCategory(
      {required this.id,
      required this.category_id,
      required this.name,
      required this.table_list});
}

class TableCategoryList {
  final List<TableCategory> tableCategories;

  TableCategoryList({required this.tableCategories});
}

// get tables from localhost:3000/tables
// first get table category, each categoryid has a list of tableid
Future<TableCategoryList> getTableCategory() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/table_category'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<TableCategory> tableCategories = [];
    for (var category in data) {
      tableCategories.add(TableCategory(
        id: category['id'],
        name: category['name'],
        category_id: category['category_id'],
        table_list: TableList(tables: await tablesFromCategory(category['id'])),
      ));
    }
    return TableCategoryList(tableCategories: tableCategories);
  } else {
    throw Exception('Failed to load table categories');
  }
}

// Define the tablesFromCategory method
Future<List<Table>> tablesFromCategory(String categoryId) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/tables?category_id=$categoryId'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Table> tables = [];
    for (var table in data) {
      tables.add(Table(
        id: table['id'],
        table_status: table['table_status'],
      ));
    }
    return tables;
  } else {
    throw Exception('Failed to load tables for category $categoryId');
  }
}

// then get table status for each tableid

Future<TableList> getTables() async {
  final prefs = await SharedPreferences.getInstance();
  List<Table> tables = [];
  final response = await http.get(Uri.parse('http://localhost:3000/tables'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    for (var category in data) {
      for (var tableId in category['tables']) {
        String? status =
            prefs.getString('table_status_$tableId') ?? 'Available';
        tables.add(Table(id: tableId, table_status: status));
      }
    }
  }
  return TableList(tables: tables);
}

class DinningTable extends StatefulWidget {
  final TableList tableList = TableList(tables: []);
  final Map<String, List<Map<String, dynamic>>> groupedMenuItems = {};
  final List<Map<String, dynamic>> menu = [];

  DinningTable(
      // {required this.tableList,
      // required this.groupedMenuItems,
      // required this.menu}
      );

  @override
  _DinningTableState createState() => _DinningTableState();
}

class _DinningTableState extends State<DinningTable> {
  Future<void> clearAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    for (var table in widget.tableList.tables) {
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
                for (var table in widget.tableList.tables) {
                  table.table_status = 'Available';
                }
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: widget.tableList.tables.length,
        itemBuilder: (context, index) {
          var table = widget.tableList.tables[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderingPage(
                    table_name: table.id,
                    groupedMenuItems: widget.groupedMenuItems,
                    menu: widget.menu,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Table ${table.id}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      table.table_status,
                      style: TextStyle(fontSize: 16.0, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DinningTablesPage extends StatelessWidget {
  // just a print
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TableCategoryList>(
      future: getTableCategory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DinningTable(
              // tableList: snapshot.data!.tableCategories[0].table_list,
              // groupedMenuItems: {},
              // menu: [],
              );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
