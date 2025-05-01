import 'package:flutter/material.dart';

class CityPage extends StatefulWidget {

  const CityPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CityPageState();
  }

}

class _CityPageState extends State<CityPage> {

  final List<String> cities = ['Seoul', 'Tokyo', 'New York', 'Paris', 'London'];
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('city select...'),),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cities.map((city) {
                return RadioListTile<String>(
                  title: Text(city),
                  value: city,
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selected != null
                  ? () => Navigator.pop(context, selected)
                  : null,
              child: const Text('선택 완료'),
            ),
          )
        ],
      ),

    );
  }

}