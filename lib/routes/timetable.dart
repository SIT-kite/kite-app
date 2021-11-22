import 'package:flutter/material.dart';

class TimetableWidget extends StatefulWidget {
  const TimetableWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimetableState();
}

class _TimetableState extends State<TimetableWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const IconButton(
            icon: Icon(Icons.menu),
            tooltip: '菜单',
            onPressed: null,
          ),
          title: const TabBar(
            tabs: [
              Tab(text: '今天'),
              Tab(text: '明天'),
              Tab(text: '后天'),
            ],
          ),
          actions: const [
            IconButton(
              icon: Icon(Icons.calendar_today),
              tooltip: '切换课表视图',
              onPressed: null,
            )
          ],
        ),
        body: TabBarView(
          children: [
            ListView(
              children: const [
                Center(child: Text('第一节课')),
                Center(child: Text('第二节课')),
              ],
            ),
            const Center(child: Text('明天的课表')),
            const Center(child: Text('后天的课表')),
          ],
        ),
      ),
    );
  }
}
