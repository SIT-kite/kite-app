import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home/background.dart';
import 'home/drawer.dart';
import 'home/greeting.dart';
import 'home/item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onHomeRefresh() {
    _refreshController.refreshCompleted(resetFooterState: true);

    // TODO: Signal all functions to refresh.
  }

  Widget buildTitleLine(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Row(children: [
          SvgPicture.asset('assets/home/kite.svg', width: 45, height: 45),
          Image.asset('assets/home/title.png', height: 40),
        ]),
      ),
    );
  }

  Widget buildFunctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        ItemWidget('/electricity', AssetImage('assets/home/icon_daily_report.png'), '电费查询'),
        ItemWidget('/score', AssetImage('assets/home/icon_daily_report.png'), '成绩'),
        ItemWidget('/library', AssetImage('assets/home/icon_library.png'), '图书馆'),
        ItemWidget('/expense', AssetImage('assets/home/icon_consumption.png'), '消费查询'),
        ItemWidget("/timetable", AssetImage('assets/home/icon_timetable.png'), '课程表'),
        SizedBox(height: 20.0),
        ItemWidget('/report', AssetImage('assets/home/icon_daily_report.png'), '体温上报'),
        ItemWidget('/office', AssetImage('assets/home/icon_library.png'), '办公'),
        SizedBox(height: 20.0),
        ItemWidget('/game', AssetImage('assets/home/icon_library.png'), '小游戏'),
        ItemWidget('/wiki', AssetImage('assets/home/icon_library.png'), 'Wiki'),
        ItemWidget('/market', AssetImage('assets/home/icon_library.png'), '二手书广场')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          const HomeBackground(),
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTitleLine(context),
                    const SizedBox(height: 20.0),
                    const GreetingWidget(),
                    const SizedBox(height: 20.0),
                    buildFunctions()
                  ],
                ),
              ),
            ),
            onRefresh: _onHomeRefresh,
          ),
        ],
      ),
      drawer: const KiteDrawer(),
    );
  }
}
