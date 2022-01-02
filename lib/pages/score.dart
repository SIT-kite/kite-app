import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Map<String, Map<String, dynamic>> selectorInfo = {};

  @override
  _ScorePageState() {
    selectorInfo = _getInitSelectorInfo((newValue) {
      setState(() {
        selectorInfo['year']!['dropdownValue'] = newValue;
      });
    }, (newValue) {
      setState(() {
        selectorInfo['semester']!['dropdownValue'] = newValue;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: (SafeArea(
            child: Column(children: [
      Container(
          margin: EdgeInsets.only(left: 30), child: _buildHeader(selectorInfo)),
    ]))));
  }
}

Widget _buildHeader(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(children: [
    Container(
        child: _buildSelector(
            selectorInfo['year']!['dropdownValue'],
            selectorInfo['year']!['items'],
            selectorInfo['year']!['setDropdownValue'])),
    Container(
        child: _buildSelector(
            selectorInfo['semester']!['dropdownValue'],
            selectorInfo['semester']!['items'],
            selectorInfo['semester']!['setDropdownValue'])),
  ]);
}

Widget _buildSelector(
    String dropdownValue, List<String> _items, setDropdownValue) {
  return DropdownButton<String>(
    value: dropdownValue,
    isDense: true,
    icon: const Icon(Icons.keyboard_arrow_down_outlined),
    style: const TextStyle(
      color: Colors.blue,
    ),
    underline: Container(
      height: 2,
      color: Colors.blue,
    ),
    onChanged: (String? newValue) {
      setDropdownValue(newValue);
    },
    items: _items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

String _getInitYearDropdownValue() {
  return '2020 - 2021';
}

String _getInitSemesterDropdownValue() {
  return '第一学期';
}

List<String> _getInitYearItems() {
  return ['2020 - 2021', '2021 - 2022'];
}

List<String> _getInitSemesterItems() {
  return ['第一学期', '第二学期', '整个学年'];
}

Map<String, Map<String, dynamic>> _getInitSelectorInfo(
    setYearDropdownValue, setSemesterDropdownValue) {
  return {
    'year': {
      'dropdownValue': _getInitYearDropdownValue(),
      'items': _getInitYearItems(),
      'setDropdownValue': setYearDropdownValue
    },
    'semester': {
      'dropdownValue': _getInitSemesterDropdownValue(),
      'items': _getInitSemesterItems(),
      'setDropdownValue': setSemesterDropdownValue
    }
  };
}
