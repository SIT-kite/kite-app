import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _semesterItems = ['第一学期', '第二学期', '整个学年'];
enum _Mode { year, semester }

List<Map<String, dynamic>> _items = [
  {
    'name': 'Python程序设计',
    'id': 'G123',
    'isValued': true,
    'score': 90,
    'info': {
      'semester': 1,
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
  },
  {
    'name': 'Python程序设计',
    'id': 'G123',
    'isValued': true,
    'score': 85,
    'info': {
      'semester': 1,
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
  },
  {
    'name': 'Python程序设计',
    'id': 'h123',
    'isValued': true,
    'score': 85,
    'info': {
      'semester': 1,
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
  },
];


class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Map<String, Map<String, dynamic>> selectorInfo = {};
  _Mode mode = _Mode.year;

  @override
  _ScorePageState() {
    selectorInfo = _getInitSelectorInfo((_Mode _mode, newValue) {
      setState(() {
        switch (_mode) {
          case _Mode.year:
            selectorInfo['year']!['dropdownValue'] = newValue;
            break;
          case _Mode.semester:
            {
              selectorInfo['semester']!['dropdownValue'] = newValue;
              switch (newValue) {
                case '第一学期':
                case '第二学期': mode = _Mode.semester; break;
                case '整个学年': mode = _Mode.year; break;
              }
              break;
            }
        }
      });
    });

    switch (selectorInfo['semester']!['dropdownValue']) {
      case '第一学期':
      case '第二学期':
        mode = _Mode.semester;
        break;
      case '整个学年':
        mode = _Mode.year;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 10),
          child: _buildHeader(selectorInfo)),
      _items.length !=0?
      Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0xFFd9d9d9), offset: Offset(0, 2), blurRadius: 1)
          ]),
          child: _buildGpaBlock(mode)) : Container(),
      _items.length !=0?
      Expanded(
        flex: 1,
        child: _buildListView(_getListItems(mode)),
      ) : Container(),
      _items.length !=0? Container() : _buildNotFound()
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
        child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.refresh, color: Colors.blue, size: 30)))
  ]);
}

Widget _buildSelectorBox(Map<String, Map<String, dynamic>> selectorInfo) {
  return Row(children: [
    Container(
      child: _buildSelector(_Mode.year, selectorInfo['year']!),
    ),
    Container(
      margin: const EdgeInsets.only(left: 15),
      child: _buildSelector(_Mode.semester, selectorInfo['semester']!),
    )
  ]);
}

Widget _buildSelector(_Mode mode, Map<String, dynamic> info) {
  return DropdownButton<String>(
    value: info['dropdownValue'],
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
      info['setDropdownValue'](mode, newValue);
    },
    items: info['items'].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Widget _buildGpaBlock(_Mode mode) {
  return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFffe599),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          '该学期绩点为 ${_getGpa(mode)}, 努力总会有回报哒!',
        )
      ]));
}

Widget _buildListView(List<Widget> listItems) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: listItems.length,
    itemBuilder: (BuildContext context, int index) {
      return listItems[index];
    },
  );
}

Widget _buildListSeparator(String content) {
  return Container(
      margin: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 3))),
      child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(content,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue))));
}

class _ListItem extends StatefulWidget {
  @override
  _ListItem({Key? key, required Map<String, dynamic> item}) : super(key: key) {
    name = item['name'];
    id = item['id'];
    score = item['score'];
    isValued = item['isValued'];
    info = item['info'];
    detail = item['detail'];
  }

  String name = '';
  String id = '';
  bool isValued = true;
  int score = 0;
  Map<String, dynamic> info = {};
  List<Map<String, dynamic>> detail = [];

  @override
  _ListItemState createState() =>
      _ListItemState(name, id, isValued, score, info, detail);
}

class _ListItemState extends State<_ListItem> {
  @override
  _ListItemState(String _name, String _id, bool _isValued, int _score,
      Map<String, dynamic> _info, List<Map<String, dynamic>> _detail) {
    name = _name;
    id = _id;
    isValued = _isValued;
    score = _score;
    info = _info;
    detail = _detail;
  }

  String name = '';
  String id = '';
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

Widget _buildNotFound() {
  return Column(
    children: [
      Container(child: _notFoundPicture,),
      const Text('暂时还没有成绩哦!', style: TextStyle(color: Colors.grey)),
      Container(margin: EdgeInsets.only(left:40, right:40),child: const Text('如果成绩刚刚出炉，可点击右上角刷新按钮尝试刷新~',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey)),)
    ]
  );
}

Widget _notFoundPicture = SvgPicture.asset(
    'assets/score/not-found.svg',
      width: 260, height: 260,
);

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

double _getGpa(_Mode mode) {
  List<Map<String, dynamic>> courseList = [];
  double totalCredits = 0.0;
  double t = 0.0;

  switch (mode) {
    case _Mode.semester:
      courseList.addAll(_items);
      break;
    case _Mode.year:
      courseList.addAll(_items);
      courseList.addAll(_items);
      break;
  }
  courseList.forEach((course) {
    if (course['id'][0] == 'G' && course['isValued'] == true) {
      t += course['info']['credit'] * course['score'];
      totalCredits += course['info']['credit'];
    }
  });
  double result = (t / totalCredits / 10.0) - 5.0;
  return result.isNaN ? 0.0 : result;
}

List<Widget> _getListItems(_Mode mode) {
  List<Widget> listItems = [];
  switch (mode) {
    case _Mode.semester:
      listItems.addAll(_items.map((_item) => _ListItem(item: _item)));
      break;
    case _Mode.year:
      listItems.add(_buildListSeparator('第一学期'));
      listItems.addAll(_items.map((_item) => _ListItem(item: _item)));
      listItems.add(_buildListSeparator('第二学期'));
      listItems.addAll(_items.map((_item) => _ListItem(item: _item)));
  }
  return listItems;
}
