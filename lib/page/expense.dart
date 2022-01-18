import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

///测试数据s
import 'package:kite/mock/expense.dart';

import '../../service/expense/expense.dart';
import 'expense/statistical.dart';

class ExpensePage extends StatefulWidget {
  ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _currentIndex = 0; // 底部导航键的标志位
  @override
  Widget build(BuildContext context) {
    // num money = 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          tooltip: '返回',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text("消费"),
        centerTitle: true,
        backgroundColor: Colors.red[300],
        actions: [
          _currentIndex == 0 ? _screening() : Padding(padding: EdgeInsets.all(0)),
        ],
      ),
      body: _currentIndex == 0 ? BillPage() : StatisticalPage(),
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

  ///筛选
  _screening() {
    return PopupMenuButton(
        tooltip: '筛选',
        onSelected: (String value) {
          // setState(() {});
        },
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem(value: "canteen", child: Icon(Icons.food_bank_outlined, color: Colors.grey)),
              const PopupMenuItem(value: "store", child: Icon(Icons.storefront, color: Colors.grey))
            ]);
  }
}

///账单
class BillPage extends StatefulWidget {
  BillPage({Key? key}) : super(key: key);

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return GroupedListView<dynamic, String>(
      elements: parseExpenseDatail("1"),
      groupBy: (element) => element['month'],
      sort: false,
      useStickyGroupSeparators: true,
      itemBuilder: (c, element) {
        var place = element["place"];
        var money = element["money"];
        var time = element["time"];
        var icon;
        if (element["label"] == 'canteen')
          icon = Icon(Icons.food_bank_outlined, size: 30);
        else if (element["label"] == 'coffee')
          icon = Icon(Icons.coffee_rounded, size: 30);
        else if (element["label"] == 'hotWater')
          icon = Icon(Icons.water_damage_outlined, size: 30);
        else if (element["label"] == 'shower')
          icon = Icon(Icons.shower_outlined, size: 30);
        else if (element["label"] == 'store') icon = Icon(Icons.storefront, size: 30);

        return ListTile(
          leading: icon,
          title: Text('$place'),
          trailing: Text('-$money', textScaleFactor: 1.5),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text('$time')]),
        );
      },
      groupHeaderBuilder: (Data) {
        num money = 1;
        data.forEach((value) {
          value['month'] == Data['month'] ? money += value['money'] : '';
        });
        return ListTile(
          title: Text('${Data['month']}月', textScaleFactor: 1.5),
          subtitle: Text('支出:${money}￥'),
        );
      },
    );
  }
}
