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
        ItemWidget('/dailyReport', Icon(Icons.access_alarm), '体温上报'),
        ItemWidget('/welcome', Icon(Icons.access_alarm), '欢迎页'),
        ItemWidget('/login', Icon(Icons.access_alarm), '登录页'),
        SizedBox(height: 20.0),
        ItemWidget('/dailyReport', Icon(Icons.access_alarm), '体温上报'),
      ],
    );
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
    );
  }
}
