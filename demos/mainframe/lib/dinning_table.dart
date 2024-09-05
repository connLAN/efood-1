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
  final List<TableCategory> tableCategories;

  DinningTable({required this.tableCategories});

  @override
  _DinningTableState createState() => _DinningTableState();
}

class _DinningTableState extends State<DinningTable> {
  Future<void> clearAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    for (var category in widget.tableCategories) {
      for (var table in category.table_list.tables) {
        await prefs.remove('orders_${table.id}');
        await prefs.remove('table_status_${table.id}');
      }
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
                for (var category in widget.tableCategories) {
                  for (var table in category.table_list.tables) {
                    table.table_status = 'Available';
                  }
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.tableCategories.length,
        itemBuilder: (context, categoryIndex) {
          var category = widget.tableCategories[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: category.table_list.tables.length,
                itemBuilder: (context, tableIndex) {
                  var table = category.table_list.tables[tableIndex];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderingPage(
                            table_name: table.id,
                            groupedMenuItems: {}, // Provide appropriate value
                            menu: [], // Provide appropriate value
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
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DinningTablesPage extends StatelessWidget {
  DinningTablesPage() {
    print('Beginning of Dinning Tables Page');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TableCategoryList>(
      future: getTableCategory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DinningTable(
            tableCategories: snapshot.data!.tableCategories,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
