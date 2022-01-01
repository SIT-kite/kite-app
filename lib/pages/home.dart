import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home/gretting.dart';
import 'home/item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onHomeRefresh() {
    _refreshController.loadComplete();

    // TODO: Signal all functions to refresh.
  }

  Widget buildTitleLine() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('上应小风筝',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildFunctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        ItemWidget('/dailyReport',
            AssetImage('assets/home/icon_daily_report.png'), '体温上报'),
        ItemWidget(
            '/library', AssetImage('assets/home/icon_library.png'), '图书馆'),
        SizedBox(height: 20.0),
        ItemWidget('/dailyReport',
            AssetImage('assets/home/icon_daily_report.png'), '体温上报'),
      ],
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('用户信息区域'),
      ),
      ListTile(
        title: const Text('主题'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('设置'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('关于'),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).pushNamed('/about');
        },
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            child: Column(
              children: [
                buildTitleLine(),
                const SizedBox(height: 20.0),
                GreetingWidget(),
                const SizedBox(height: 20.0),
                buildFunctions(),
              ],
            ),
            onRefresh: _onHomeRefresh,
          ),
        ),
      ),
      drawer: buildDrawer(context),
    );
  }
}
