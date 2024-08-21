import 'package:flutter/material.dart';

class DinningTableSettingsPage extends StatefulWidget {
  @override
  _DinningTableSettingsPageState createState() => _DinningTableSettingsPageState();
}

class _DinningTableSettingsPageState extends State<DinningTableSettingsPage> {
  String _tableType = 'Round';
  int _tableNumber = 1;
  List<String> _tableNicknames = [''];
  List<TableType> _tableTypes = [
    TableType(name: 'Round', enabled: true),
    TableType(name: 'Square', enabled: true),
    TableType(name: 'Rectangle', enabled: true),
  ];
  TextEditingController _newTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DinningTable Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Table Type:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _tableType,
              onChanged: (String? newValue) {
                setState(() {
                  _tableType = newValue!;
                });
              },
              items: _tableTypes
                  .where((type) => type.enabled)
                  .map<DropdownMenuItem<String>>((TableType type) {
                return DropdownMenuItem<String>(
                  value: type.name,
                  child: Text(type.name),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Number of Tables:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_tableNumber > 1) _tableNumber--;
                      _updateTableNicknames();
                    });
                  },
                ),
                Text('$_tableNumber', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _tableNumber++;
                      _updateTableNicknames();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Table Nicknames:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: _tableNumber,
                itemBuilder: (context, index) {
                  return TextField(
                    decoration: InputDecoration(
                      labelText: 'Table ${index + 1} Nickname',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _tableNicknames[index] = value;
                      });
                    },
                    controller: TextEditingController(text: _tableNicknames[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings logic here
                  print('Table Type: $_tableType');
                  print('Number of Tables: $_tableNumber');
                  print('Table Nicknames: $_tableNicknames');
                },
                child: Text('Save Settings'),
              ),
            ),
            SizedBox(height: 16),
            Text('Add New Table Type:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTypeController,
                    decoration: InputDecoration(
                      labelText: 'New Table Type',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _tableTypes.add(TableType(name: _newTypeController.text, enabled: true));
                      _newTypeController.clear();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Enable/Disable Table Types:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: _tableTypes.length,
                itemBuilder: (context, index) {
                  return SwitchListTile(
                    title: Text(_tableTypes[index].name),
                    value: _tableTypes[index].enabled,
                    onChanged: (bool value) {
                      setState(() {
                        _tableTypes[index].enabled = value;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTableNicknames() {
    if (_tableNumber > _tableNicknames.length) {
      _tableNicknames.addAll(List.generate(_tableNumber - _tableNicknames.length, (index) => ''));
    } else if (_tableNumber < _tableNicknames.length) {
      _tableNicknames = _tableNicknames.sublist(0, _tableNumber);
    }
  }
}

class TableType {
  String name;
  bool enabled;

  TableType({required this.name, this.enabled = true});
}

// DinningTableLogPage widget
class DinningTableLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DinningTable Log'),
      ),
      body: Center(
        child: Text('This is the dinningtable log page. View your dinningtable logs here.'),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DinningTableSettingsPage()),
                );
              },
              child: Text('Go to DinningTable Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DinningTableLogPage()),
                );
              },
              child: Text('Go to DinningTable Log'),
            ),
          ],
        ),
      ),
    );
  }
}

void onDinningTableIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DinningTableSettingsPage()),
  );
}

void handleDinningTableAction(BuildContext context) {
  onDinningTableIconClicked(context);
}

void onDinningTableLogIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DinningTableLogPage()),
  );
}