import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DinningTableSettings extends StatefulWidget {
  @override
  _DinningTableSettingsState createState() => _DinningTableSettingsState();
}

class _DinningTableSettingsState extends State<DinningTableSettings> {
  List<TableCategory> _tableCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchTableCategories();
  }

  Future<void> _fetchTableCategories() async {
    final response = await http.get(Uri.parse('http://localhost:3000/table_category_all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data);

      setState(() {
        _tableCategories = data.map((item) => TableCategory.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load table categories');
    }
  }

  Future<void> _updateCategoryStatus(String categoryId, int isActive) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/update_category_status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'category_id': categoryId,
        'is_active': isActive,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category status');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dinning Table Settings'),
      ),
      body: _tableCategories.isNotEmpty
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
                        _updateCategoryStatus(category.category_id, category.is_active);
                      });
                    },
                  ),
                  title: Text(category.category_name),
                  subtitle: Text('ID: ${category.category_id}'),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
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