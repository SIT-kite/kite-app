import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

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

class ConsumptionPage extends StatefulWidget {
  ConsumptionPage({Key? key}) : super(key: key);

  @override
  _ConsumptionPageState createState() => _ConsumptionPageState();
}

class _ConsumptionPageState extends State<ConsumptionPage> {
  int _currentIndex = 0; // 底部导航键的标志位

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: const IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          tooltip: '返回',
          onPressed: null,
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
              // groupComparator: (value1, value2) => value2.compareTo(value1),
              // itemComparator: (item1, item2) =>
              //     item1['name'].compareTo(item2['name'])
              // order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) {
                // int money = 0;
                // int num = 0;
                // for (int row = 0; row < data[section].length; row++) {
                //   money = data[section][row]["money"];
                //   num += money;
                // }
                // string hhh = money.toString();
                return ListTile(
                  title: Text('${value}月', textScaleFactor: 1.5),
                  subtitle: Text('支出:￥'),
                  //   trailing: Image.asset(
                  //        'D:/WORK/wechat/text-app/text_app/assets/telegram .png'),
                );
              },
              itemBuilder: (c, element) {
                var place = element["place"];
                var money = element["money"];
                var time = element["time"];
                var icon = element["label"] == 'canteen'
                    ? Icon(Icons.liquor)
                    : Icon(Icons.storefront);
                return ListTile(
                  leading: icon,
                  title: Text('$place'),
                  trailing: Text('-$money', textScaleFactor: 1.5),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text('$place'), Text('$time')]),
                );
              })
          : ListView(children: _getListBill(30)),
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
    List<Widget> widgets = [];
    for (int i = 0; i < width; i++) {
      widgets.add(GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("消费 $i"),
        ),
        onTap: () {
          print('他想看 $i');
        },
      ));
    }
    return widgets;
  }
}
