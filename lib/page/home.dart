import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home/background.dart';
import 'home/drawer.dart';
import 'home/greeting.dart';
import 'home/group.dart';
import 'home/item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onHomeRefresh() {
    _refreshController.refreshCompleted(resetFooterState: true);

    // TODO: Signal all functions to refresh.
  }

  Widget _buildTitleLine(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Row(children: [
          SvgPicture.asset('assets/home/kite.svg', width: 30, height: 30),
          Image.asset('assets/home/title.png', height: 30),
        ]),
      ),
    );
  }

  List<Widget> buildFunctionWidgets() {
    return [
      const GreetingWidget(),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem('/electricity', AssetImage('assets/home/icon_daily_report.png'), '电费查询'),
        HomeItem('/score', AssetImage('assets/home/icon_daily_report.png'), '成绩'),
        HomeItem('/library', AssetImage('assets/home/icon_library.png'), '图书馆'),
        HomeItem('/expense', AssetImage('assets/home/icon_consumption.png'), '消费查询'),
        HomeItem("/timetable", AssetImage('assets/home/icon_timetable.png'), '课程表')
      ]),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem('/report', AssetImage('assets/home/icon_daily_report.png'), '体温上报'),
        HomeItem('/office', AssetImage('assets/home/icon_library.png'), '办公')
      ]),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem('/game', AssetImage('assets/home/icon_library.png'), '小游戏'),
        HomeItem('/wiki', AssetImage('assets/home/icon_library.png'), 'Wiki'),
        HomeItem('/market', AssetImage('assets/home/icon_library.png'), '二手书广场'),
      ]),
      const SizedBox(height: 40),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final items = buildFunctionWidgets();

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          const HomeBackground(),
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            child: CustomScrollView(slivers: [
              SliverAppBar(
                // AppBar
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(title: _buildTitleLine(context)),
                expandedHeight: windowSize.height * 0.6,
                backgroundColor: Colors.transparent,
                centerTitle: false,
                elevation: 0,
                pinned: false,
              ),
              SliverList(
                // Functions
                delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: items[index]),
                  childCount: items.length,
                ),
              ),
            ]),
            onRefresh: _onHomeRefresh,
          ),
        ],
      ),
      drawer: const KiteDrawer(),
    );
  }
}
