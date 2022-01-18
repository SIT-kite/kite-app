import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

///测试数据
import 'package:kite/mock/expense.dart';

import 'line_chart.dart';

var today = DateTime.now();
List<FlSpot> daysData = [];

class StatisticalPage extends StatefulWidget {
  StatisticalPage({Key? key}) : super(key: key);

  @override
  _StatisticalPageState createState() => _StatisticalPageState();
}

class _StatisticalPageState extends State<StatisticalPage> {
  var year = today.year;
  var month = today.month;
  num number = 0;
  num Summation = 0;
  List monthData = [];
  List CategoricalData = [];
  @override
  Widget build(BuildContext context) {
    getMonthData();
    getDaysData(monthData);
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      ListTile(
        minVerticalPadding: 10.0,
        title: Row(
          children: <Widget>[
            PopupMenuButton(
                tooltip: '日期选择',
                onSelected: (String value) {
                  setState(() {
                    monthData = [];
                    year = int.parse(value);
                    if (year == today.year) {
                      month = today.month;
                    }
                  });
                },
                child: Text('${year}年', textScaleFactor: 1.5),
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                itemBuilder: (BuildContext context) {
                  List<PopupMenuItem<String>> widgets = [];
                  for (int i = today.year; i >= 2021; i--) {
                    widgets.add(
                      PopupMenuItem(value: "${i}", child: Text('${i}年')),
                    );
                  }
                  return widgets;
                }),
            PopupMenuButton(
                tooltip: '日期选择',
                onSelected: (String value) {
                  setState(() {
                    monthData = [];
                    month = int.parse(value);
                  });
                  // setState(() {});
                },
                child: Text('${month}月', textScaleFactor: 1.5),
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                itemBuilder: (BuildContext context) {
                  List<PopupMenuItem<String>> widgets = [];
                  int i = year == today.year ? month : 12;
                  for (i; i > 0; i--) {
                    widgets.add(
                      PopupMenuItem(value: "${i}", child: Text('${i}月')),
                    );
                  }
                  return widgets;
                }),
          ],
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getSummation(),
        ),
      ),
      Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
                      child: Text('支出对比', textScaleFactor: 1.2),
                    ),
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: PayLineChart(),
                    )
                  ]))),
      Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: const Text('支出分类', textScaleFactor: 1.2),
            ),
            Column(
              children: _getclassification(),
            )
          ],
        ),
      )
    ]));
  }

  _getclassification() {
    List<Widget> widgets = [];

    for (int i = 0; i < CategoricalData.length; i++) {
      var icon;
      if (CategoricalData[i]["label"] == 'canteen')
        icon = Icon(Icons.food_bank_outlined, size: 30);
      else if (CategoricalData[i]["label"] == 'coffee')
        icon = Icon(Icons.coffee_rounded, size: 30);
      else if (CategoricalData[i]["label"] == 'hotWater')
        icon = Icon(Icons.water_damage_outlined, size: 30);
      else if (CategoricalData[i]["label"] == 'shower')
        icon = Icon(Icons.shower_outlined, size: 30);
      else if (CategoricalData[i]["label"] == 'store') icon = Icon(Icons.storefront, size: 30);
      widgets.add(ListTile(
        leading: icon,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${CategoricalData[i]["label"]}', textScaleFactor: 1.5),
          Text('${CategoricalData[i]["percentage"]}%'),
        ]),
        subtitle: LinearProgressIndicator(
          value: CategoricalData[i]["percentage"] / 100,
        ),
        trailing: Text('￥${CategoricalData[i]["money"]}', textScaleFactor: 1.5),
        dense: true,
      ));
    }
    String _dateToString(DateTime date) {
      final local = date.toLocal();

      return '$local.year-$local.month-$local.day $local.hour-$local.minute';
    }

    String _tsToString(int ts) {
      return _dateToString(DateTime.fromMillisecondsSinceEpoch(ts));
    }

    // widgets.add(Text("${today.month}"));
    return widgets;
  }

  getMonthData() {
    number = 0;
    Summation = 0;
    // List monthData = [];
    for (int i = 0; i < data.length; i++) {
      if (int.parse(data[i]['year']) == year) {
        number++;
        Summation += data[i]['money'];
        monthData.add(data[i]);
        print(data[i]);
      }
      // print(data);
    }
    print(monthData);
    getCategoricalData(monthData);
  }

  getDaysData(List monthData) {
    daysData = [];
    var monthStartDate =
        DateTime(int.parse(monthData[0]['year']), int.parse(monthData[0]['month']), 1).microsecondsSinceEpoch;

    var monthEndtDate =
        DateTime(int.parse(monthData[1]['year']), int.parse(monthData[1]['month']) + 1, 1).microsecondsSinceEpoch;
    var index_day = 0;
    var dayTime = (monthEndtDate - monthStartDate) / (1000000 * 60 * 60 * 24);
    print('$dayTime');

    for (int i = 1; i < dayTime; i++) {
      if (DateTime.parse(monthData[index_day]['time']).day == i) {
        double daymoney = 0;
        while (DateTime.parse(monthData[index_day]['time']).day == i) {
          daymoney += monthData[index_day]['money'];
          daysData.add(FlSpot(i.toDouble(), daymoney));
          index_day++;
        }
      } else {
        daysData.add(FlSpot(i.toDouble(), 0));
      }
    }
  }

  getCategoricalData(List monthData) {
    CategoricalData = [];
    num sum = 0;
    List labels = ['hotWater', 'shower', 'coffee', 'canteen', 'store'];
    for (int i = 0; i < labels.length; i++) {
      CategoricalData.add({'label': labels[i], 'money': 0, 'percentage': sum == 0 ? 1 : monthData[i]['money'] / sum});
    }
    for (int i = 0; i < monthData.length; i++) {
      for (int j = 0; j < CategoricalData.length; j++) {
        if (monthData[i]['label'] == CategoricalData[j]['label']) {
          sum += monthData[i]['money'];

          CategoricalData[j]['money'] += monthData[i]['money'];
          CategoricalData[j]['percentage'] = sum == 0 ? 1 : monthData[i]['money'] / sum;
        }
      }
    }
    for (int i = 0; i < CategoricalData.length; i++) {
      CategoricalData[i]['percentage'] = sum == 0 ? 1 : CategoricalData[i]['money'] * 100 ~/ sum;
    }
    CategoricalData.sort((a, b) => b['money'].compareTo(a['money']));
  }

  getSummation() {
    return [Text('支出 ${number} 笔 合计'), Text('￥${Summation}', textScaleFactor: 1.8)];
  }
}
