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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (SafeArea(
            child: Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 10),
          child: _buildHeader(selectorInfo)),
      Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(boxShadow:[BoxShadow(color: Color(0xFFd9d9d9), offset: Offset(0, 2), blurRadius:1)]),
          child: _buildGpaBlock()),
    ]))));
  }
}

Widget _buildHeader(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    _buildSelectorBox(selectorInfo),
    Container(
        margin: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.refresh, color: Colors.blue, size: 30))
  ]);
}

Widget _buildSelectorBox(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(children: [
    Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelector(
          selectorInfo['year']!['dropdownValue'],
          selectorInfo['year']!['items'],
          selectorInfo['year']!['setDropdownValue']),
    ),
    Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelector(
          selectorInfo['semester']!['dropdownValue'],
          selectorInfo['semester']!['items'],
          selectorInfo['semester']!['setDropdownValue']),
    )
  ]);
}

Widget _buildSelector(
    String dropdownValue, List<String> _items, setDropdownValue) {
  return DropdownButton<String>(
    value: dropdownValue,
    isDense: true,
    icon: const Icon(Icons.keyboard_arrow_down_outlined),
    style: const TextStyle(
      color: Color(0xFF002766),
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

Widget _buildGpaBlock() {
  return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFffe599),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Text(
          '该学期绩点为 2.81, 努力总会有回报哒!',
        )
      ]));
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
