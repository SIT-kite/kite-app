import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fl_chart/fl_chart.dart';

///测试数据
List data = [
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/12/28',
    'month': '12'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/12/27',
    'month': '12'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/12/27',
    'month': '12'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/12/27',
    'month': '12'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/11/27',
    'month': '11'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/11/27',
    'month': '11'
  },
  {
    'place': '商店',
    'label': 'store',
    'money': 90,
    'time': '2021/11/27',
    'month': '11'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/10/28',
    'month': '10'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/10/28',
    'month': '10'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/9/28',
    'month': '9'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/9/28',
    'month': '9'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/9/28',
    'month': '9'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/8/28',
    'month': '8'
  },
  {
    'place': '食堂',
    'label': 'canteen',
    'money': 100,
    'time': '2021/8/28',
    'month': '8'
  },
];

class ExpensePage extends StatefulWidget {
  ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _currentIndex = 1; // 底部导航键的标志位

  @override
  Widget build(BuildContext context) {
    // num money = 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          tooltip: '返回',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text("消费"),
        centerTitle: true,
        backgroundColor: Colors.red[300],
        actions: const [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down_outlined),
            tooltip: '筛选',
            onPressed: null,
          ),
        ],
      ),
      body: _currentIndex == 0
          ? GroupedListView<dynamic, String>(
              elements: data,
              groupBy: (element) => element['month'],
              sort: false,
              useStickyGroupSeparators: true,
              itemBuilder: (c, element) {
                var place = element["place"];
                var money = element["money"];
                var time = element["time"];
                var icon = element["label"] == 'canteen'
                    ? Icon(Icons.food_bank_outlined)
                    : Icon(Icons.storefront);
                return ListTile(
                  leading: icon,
                  title: Text('$place'),
                  trailing: Text('-$money', textScaleFactor: 1.5),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text('$time')]),
                );
              },
              groupHeaderBuilder: (Data) {
                num money = 0;
                data.forEach((value) {
                  value['month'] == Data['month']
                      ? money += value['money']
                      : '';
                });
                return ListTile(
                  title: Text('${Data['month']}月', textScaleFactor: 1.5),
                  subtitle: Text('支出:${money}￥'),
                  //   trailing: Image.asset(
                  //        'D:/WORK/wechat/text-app/text_app/assets/telegram .png'),
                );
              },
            )
          : statistical(),
      // : Column(children: _getListBill(30)),
      // : ListView(children: _getListBill(30)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: '账单',
            icon: Icon(Icons.assignment_rounded),
          ),
          BottomNavigationBarItem(
            label: '概览',
            icon: Icon(Icons.data_saver_off),
          )
        ],
        currentIndex: _currentIndex,
        onTap: (int tapIndex) {
          //进行状态更新，将系统返回的你点击的标签位标赋予当前位标属性，告诉系统当前要显示的导航标签被用户改变了。
          setState(() {
            _currentIndex = tapIndex;
          });
        },
        selectedItemColor: Colors.red[300],
      ),
    );
  }

  _getListBill(int width) {
    List<Widget> widgets = [
      // ListTile(
      //   title: Row(children: <Widget>[
      //     Text('2021年12月', textScaleFactor: 1.5),
      //     IconButton(
      //       icon: Icon(Icons.keyboard_arrow_down),
      //       onPressed: null,
      //     ),
      //   ]),
      //   subtitle: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         Text('支出 102 笔 合计'),
      //         Text('￥12345', textScaleFactor: 1.5)
      //       ]),
      // ),
      Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: MyLineChart(),
      )),
      // Card(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   color: Colors.red[300],
      //   child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         Text('  支出对比', textScaleFactor: 1.5),
      //         // Image.asset('assets/home/icon_daily_report.png'),
      //         MyLineChart(),
      //         // Center(child: MyLineChart())
      //       ]),
      // )
    ];
    return widgets;
  }
}

class MyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 第一条线
    List<FlSpot> spots1 = [
      FlSpot(1, 1),
      FlSpot(2, 1.5),
      FlSpot(3, 1.4),
      FlSpot(4, 3.4),
      FlSpot(5, 2),
      FlSpot(6, 1.8),
      FlSpot(7, 1.8),
      FlSpot(8, 1.8),
      FlSpot(9, 1.8),
      FlSpot(10, 1.8),
      FlSpot(11, 1.8),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ];
    return LineChart(
      LineChartData(
        borderData:
            FlBorderData(border: Border(bottom: BorderSide(width: 1.0))),
        // backgroundColor: Colors.red[100],
        lineBarsData: [
          LineChartBarData(
            belowBarData: BarAreaData(
                show: true, colors: [Color.fromRGBO(228, 242, 253, 1)]),
            spots: spots1,
            colors: [Color.fromRGBO(49, 127, 227, 100)],
            preventCurveOverShooting: false,
            isCurved: true,
            barWidth: 3,
            preventCurveOvershootingThreshold: 3.0,
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.blue[100],
              strokeWidth: 1,
              dashArray: [20, 10],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
      ),
    );
  }
}

class statistical extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        minVerticalPadding: 10.0,
        title: Row(children: <Widget>[
          Text('2021年12月', textScaleFactor: 1.5),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: null,
          ),
        ]),
        subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('支出 102 笔 合计'),
              Text('￥12345', textScaleFactor: 1.5)
            ]),
      ),
      Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
          // shadowColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // elevation: 10, // 阴影高度
          child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 10),
                      child: Text('支出对比', textScaleFactor: 1.5),
                    ),
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: MyLineChart(),
                    )
                  ]))),
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('支出分类', textScaleFactor: 1.5),
          ],
        ),
      )
    ]);
  }
}
