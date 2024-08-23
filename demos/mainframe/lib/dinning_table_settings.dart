import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DinningTableSettings extends StatefulWidget {
  @override
  _DinningTableSettingsState createState() => _DinningTableSettingsState();
}

class _DinningTableSettingsState extends State<DinningTableSettings> {
  List<TableCategory> _tableCategories = [];
  List<Table> _tables = [];
  TableCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchTableCategories();
    _fetchTables();
  }

  Future<void> _fetchTableCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/table_category_all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tableCategories = data.map((item) => TableCategory.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load table categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching table categories: $e');
      throw Exception('Failed to load table categories');
    }
  }

  Future<void> _fetchTables() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/tables_all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tables = data.map((item) => Table.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tables: $e');
      throw Exception('Failed to load tables');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dinning Table Settings'),
      ),
      body: Row(
        children: [
          Expanded(
            child: _tableCategories.isNotEmpty
                ? ListView.builder(
                    itemCount: _tableCategories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _tableCategories.length) {
                        return ListTile(
                          leading: Icon(Icons.add),
                          title: Text('Add New Category'),
                          onTap: _addNewCategory,
                        );
                      }
                      final category = _tableCategories[index];
                      return ListTile(
                        leading: Checkbox(
                          value: category.is_active == 1,
                          onChanged: (bool? value) {
                            setState(() {
                              category.is_active = value! ? 1 : 0;
                            });
                          },
                        ),
                        title: Text(category.category_name),
                        tileColor: _selectedCategory == category ? Colors.blue.withOpacity(0.2) : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          VerticalDivider(),
          Expanded(
            child: _selectedCategory != null
                ? ListView.builder(
                    itemCount: _tables.where((table) => table.category_id == _selectedCategory!.category_id).length,
                    itemBuilder: (context, index) {
                      final filteredTables = _tables.where((table) => table.category_id == _selectedCategory!.category_id).toList();
                      final table = filteredTables[index];
                      return ListTile(
                        title: Text(table.name),
                      );
                    },
                  )
                : Center(child: Text('Select a category to view tables')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTableDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewCategory() {
    setState(() {
      _tableCategories.add(TableCategory(
        id: _tableCategories.length + 1,
        category_id: 'NEW',
        category_name: 'New Category',
        is_active: 1,
      ));
    });
  }

  void _showAddTableDialog() {
    final _formKey = GlobalKey<FormState>();
    String _tableName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Table'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Table Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a table name';
                }
                return null;
              },
              onSaved: (value) {
                _tableName = value!;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addTable(_tableName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTable(String tableName) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/add_table'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'table_name': tableName,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTables();
    } else {
      throw Exception('Failed to add table');
    }
  }
}

class TableCategory {
  final int id;
  final String category_id;
  final String category_name;
  int is_active;

  TableCategory({
    required this.id,
    required this.category_id,
    required this.category_name,
    required this.is_active,
  });

  factory TableCategory.fromJson(Map<String, dynamic> json) {
    return TableCategory(
      id: json['id'],
      category_id: json['category_id'],
      category_name: json['category_name'],
      is_active: json['is_active'],
    );
  }
}

class Table {
  final int id;
  final String name;
  final String category_id;

  Table({
    required this.id,
    required this.name,
    required this.category_id,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'],
      category_id: json['category_id'],
    );
  }
}