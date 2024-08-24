import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pinyin/pinyin.dart';

class DinningTableSettings extends StatefulWidget {
  @override
  _DinningTableSettingsState createState() => _DinningTableSettingsState();
}

class _DinningTableSettingsState extends State<DinningTableSettings> {
  List<TableCategory> _tableCategories = [];
  List<Table> _tables = [];
  TableCategory? _selectedCategory;
  Map<int, TextEditingController> _nameControllers = {};
  Map<int, TextEditingController> _elegantNameControllers = {};
  Map<int, TextEditingController> _capacityControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchTableCategories();
    _fetchTables();
  }

  Future<void> _fetchTableCategories() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/table_category_all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tableCategories =
              data.map((item) => TableCategory.fromJson(item)).toList();
          if (_tableCategories.isNotEmpty) {
            _selectedCategory = _tableCategories.first;
          }
        });
      } else {
        throw Exception(
            'Failed to load table categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching table categories: $e');
      throw Exception('Failed to load table categories');
    }
  }

  Future<void> _fetchTables() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/tables_all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tables = data.map((item) => Table.fromJson(item)).toList();
          _nameControllers = {
            for (var table in _tables)
              table.id: TextEditingController(text: table.name)
          };
          _elegantNameControllers = {
            for (var table in _tables)
              table.id: TextEditingController(text: table.elegant_name)
          };
          _capacityControllers = {
            for (var table in _tables)
              table.id: TextEditingController(text: table.capacity.toString())
          };
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
        title: Text('餐桌设置页面'),
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
                          title: Text('添加新类别'),
                          onTap: _showAddCategoryDialog,
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
                        tileColor: _selectedCategory == category
                            ? Colors.blue.withOpacity(0.2)
                            : null,
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
                    itemCount: _tables
                        .where((table) =>
                            table.category_id == _selectedCategory!.category_id)
                        .length,
                    itemBuilder: (context, index) {
                      final filteredTables = _tables
                          .where((table) =>
                              table.category_id ==
                              _selectedCategory!.category_id)
                          .toList();
                      final table = filteredTables[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameControllers[table.id],
                                decoration: InputDecoration(labelText: '桌名'),
                                onSubmitted: (newValue) {
                                  setState(() {
                                    table.name = newValue;
                                    _updateTableName(table.id, newValue);
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _elegantNameControllers[table.id],
                                decoration: InputDecoration(labelText: '雅称'),
                                onSubmitted: (newValue) {
                                  setState(() {
                                    table.elegant_name = newValue;
                                    _updateTableElegantName(table.id, newValue);
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _capacityControllers[table.id],
                                decoration: InputDecoration(labelText: '座位数'),
                                keyboardType: TextInputType.number,
                                onSubmitted: (newValue) {
                                  setState(() {
                                    table.capacity = int.parse(newValue);
                                    _updateTableCapacity(
                                        table.id, int.parse(newValue));
                                  });
                                },
                              ),
                            ),

                            // expanded button
                            // if no info changed, just add a delete btn
                            // if info changed, add a check btn
                            SizedBox(height: 10),
                            Expanded(
                              child: table.isChanged
                                  ? IconButton(
                                      icon: Icon(Icons.check),
                                      onPressed: () {
                                        // Handle check button press
                                        print('Check button pressed');
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Handle delete button press
                                        print('Delete button pressed');
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: Text('请选择一个类别')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTableDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final _formKey = GlobalKey<FormState>();
    String _categoryName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增类别'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: '类别名称'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入类别名称';
                }
                return null;
              },
              onSaved: (value) {
                _categoryName = value!;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确认增加'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addCategory(_categoryName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCategory(String categoryName) async {
    // generate category id from category name
    String pinyinInitials =
        PinyinHelper.getShortPinyin(categoryName).toUpperCase();

    final response = await http.post(
      Uri.parse('http://localhost:3000/add_category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'category_name': categoryName,
        'category_id': pinyinInitials,
        'is_active': 1,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTableCategories();
    } else {
      throw Exception('添加类别失败');
    }
  }

  void _showAddTableDialog() {
    final _formKey = GlobalKey<FormState>();
    String _tableName = '';
    String _elegantName = '';
    int _capacity = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增餐桌'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: '餐桌名'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入餐桌名称';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tableName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '雅称'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入餐桌雅称/别名';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _elegantName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '座位数/人数'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入餐桌的座位数/人数';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _capacity = int.parse(value!);
                  },
                ),
              ],
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
                  _addTable(_tableName, _elegantName, _capacity);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTable(
      String tableName, String elegantName, int capacity) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/add_table'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_name': tableName,
        'elegant_name': elegantName,
        'capacity': capacity,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTables();
    } else {
      throw Exception('Failed to add table');
    }
  }

  Future<void> _updateTableName(int tableId, String newName) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/update_table_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'table_name': newName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('更新餐桌名称失败');
    }
  }

  Future<void> _updateTableElegantName(int tableId, String newName) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/update_table_elegant_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'elegant_name': newName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('更新餐桌雅称失败');
    }
  }

  Future<void> _updateTableCapacity(int tableId, int newCapacity) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/update_table_capacity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': tableId,
        'capacity': newCapacity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('更新座位数失败');
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
  String name;
  String elegant_name;
  int capacity;
  final String category_id;
  bool isChanged; // Track whether the information has changed

  Table({
    required this.id,
    required this.name,
    required this.elegant_name,
    required this.capacity,
    required this.category_id,
    this.isChanged = false, // Initialize to false
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'] ?? '',
      elegant_name: json['elegant_name'] ?? '',
      capacity: json['capacity'] ?? 0,
      category_id: json['category_id'] ?? '',
    );
  }
}