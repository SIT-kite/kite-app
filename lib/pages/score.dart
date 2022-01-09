import 'package:flutter/material.dart';

const _semesterItems = ['第一学期', '第二学期', '整个学年'];
var _items = [
  _ListItem(item: {
    'name': 'Python程序设计',
    'isValued': true,
    'score': 85,
    'info': {
      'required': true,
      'credit': 2.5,
    },
    'detail': [
      {
        'category': 'normal',
        'score': 99,
        'percent': 80,
      }
    ]
  }),
  _ListItem(item: {
    'name': 'Python程序设计',
    'isValued': true,
    'score': 85,
    'info': {
      'required': true,
      'credit': 2.5,
    },
    'detail': [
      {
        'category': 'normal',
        'score': 99,
        'percent': 80,
      }
    ]
  }),
  _ListItem(item: {
    'name': 'Python程序设计',
    'isValued': true,
    'score': 85,
    'info': {
      'required': true,
      'credit': 2.5,
    },
    'detail': [
      {
        'category': 'normal',
        'score': 99,
        'percent': 80,
      }
    ]
  })
];
enum _Mode { year, semester }


class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Map<String, Map<String, dynamic>> selectorInfo = {};

  @override
  _ScorePageState() {
    selectorInfo = _getInitSelectorInfo((_Mode mode, newValue) {
      setState(() {
        switch (mode) {
          case _Mode.year:
            selectorInfo['year']!['dropdownValue'] = newValue;
            break;
          case _Mode.semester:
            selectorInfo['semester']!['dropdownValue'] = newValue;
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 10),
          child: _buildHeader(selectorInfo)),
      Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0xFFd9d9d9), offset: Offset(0, 2), blurRadius: 1)
          ]),
          child: _buildGpaBlock()),
      Expanded(
        flex: 1,
        child: _buildListView(_items),
      )
    ])));
  }
}

Widget _buildHeader(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelectorBox(selectorInfo),
    ),
    Container(
        margin: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.refresh, color: Colors.blue, size: 30))
  ]);
}

Widget _buildSelectorBox(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(children: [
    Container(
      child: _buildSelector(
          _Mode.year,
          selectorInfo['year']!['dropdownValue'],
          selectorInfo['year']!['items'],
          selectorInfo['year']!['setDropdownValue']),
    ),
    Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelector(
          _Mode.semester,
          selectorInfo['semester']!['dropdownValue'],
          selectorInfo['semester']!['items'],
          selectorInfo['semester']!['setDropdownValue']),
    )
  ]);
}

Widget _buildSelector(
    _Mode mode, String dropdownValue, List<String> _items, setDropdownValue) {
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
      setDropdownValue(mode, newValue);
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

Widget _buildListView(List<_ListItem> items) {
  return ListView.separated(
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      return items[index];
    },
    separatorBuilder: (BuildContext context, int index) {
      return index == 0 || index == 3 ? Text('第一学期') : Container();
    },
  );
}

class _ListItem extends StatefulWidget {
  @override
  _ListItem({Key? key, required Map<String, dynamic> item}) : super(key: key) {
    name = item['name'];
    score = item['score'];
    isValued = item['isValued'];
    info = item['info'];
    detail = item['detail'];
  }

  String name = '';
  bool isValued = true;
  int score = 0;
  Map<String, dynamic> info = {};
  List<Map<String, dynamic>> detail = [];

  @override
  _ListItemState createState() =>
      _ListItemState(name, isValued, score, info, detail);
}

class _ListItemState extends State<_ListItem> {
  @override
  _ListItemState(String _name, bool _isValued, int _score,
      Map<String, dynamic> _info, List<Map<String, dynamic>> _detail) {
    name = _name;
    isValued = _isValued;
    score = _score;
    info = _info;
    detail = _detail;
  }

  String name = '';
  bool isValued = true;
  int score = 0;
  Map<String, dynamic> info = {};
  List<Map<String, dynamic>> detail = [];

  bool isFolded = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isFolded = !isFolded;
          });
        },
        child: Container(
            margin: const EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
            ),
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.blue, width: 1))),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.orange.shade300, width: 3))),
                        child: Text(name == '' ? '( 空 )' : name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Text(
                            '${info['required'] == true ? '必修' : '选修'} | 学分: ${info['credit']}'),
                      ),
                      !isFolded
                          ? Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.blue, width: 3))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: detail.map((item) {
                                    if (item['category'] == 'normal')
                                      return Text(
                                          '平时: ${item['score']} 占比: ${item['percent']}%');
                                    else if (item['category'] == 'midTerm')
                                      return Text(
                                          '期中: ${item['score']} 占比: ${item['percent']}%');
                                    else if (item['category'] == 'endTerm')
                                      return Text(
                                          '期末: ${item['score']} 占比: ${item['percent']}%');
                                    return Container();
                                  }).toList()),
                            )
                          : Container(),
                    ]),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text('${isValued ? score : '待评教'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue)))
            ])));
  }
}

String _getInitDropdownValue(_Mode mode) {
  switch (mode) {
    case _Mode.year:
      {
        return '2020 - 2021';
      }

    case _Mode.semester:
      {
        return '第一学期';
      }
  }
}

List<String> _getInitYearItems(String studentId) {
  final date = DateTime.now();
  final nowMonth = date.month;
  final nowYear = int.parse(date.year.toString().substring(2, 4));
  final startYear = int.parse(studentId.toString().substring(0, 2));
  final monthInterval = (nowYear - startYear) * 12 + nowMonth - 9;
  const baseString = '20';
  List<String> yearItems = [];

  for (int i = 0, year = startYear;
      i < (monthInterval / 12 + 1).toInt();
      i++, year++) {
    yearItems.add('$baseString$year - $baseString${year + 1}');
  }

  return yearItems;
}

Map<String, Map<String, dynamic>> _getInitSelectorInfo(setDropdownValue) {
  return {
    'year': {
      'dropdownValue': _getInitDropdownValue(_Mode.year),
      'items': _getInitYearItems('2010'),
      'setDropdownValue': setDropdownValue
    },
    'semester': {
      'dropdownValue': _getInitDropdownValue(_Mode.semester),
      'items': _semesterItems,
      'setDropdownValue': setDropdownValue
    }
  };
}
