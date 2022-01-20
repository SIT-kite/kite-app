import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/service/weather.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:universal_platform/universal_platform.dart';

import '../global/quick_button.dart';
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
        child: Center(child: SvgPicture.asset('assets/home/kite.svg', width: 80, height: 80)),
      ),
    );
  }

  List<Widget> buildFunctionWidgets(Weather weather) {
    return [
      GreetingWidget(weather),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem(route: '/electricity', icon: AssetImage('assets/home/icon_daily_report.png'), title: '电费查询'),
        HomeItem(route: '/score', icon: AssetImage('assets/home/icon_daily_report.png'), title: '成绩'),
        HomeItem(route: '/library', icon: AssetImage('assets/home/icon_library.png'), title: '图书馆'),
        HomeItem(route: '/expense', icon: AssetImage('assets/home/icon_consumption.png'), title: '消费查询'),
        HomeItem(route: "/timetable", icon: AssetImage('assets/home/icon_timetable.png'), title: '课程表')
      ]),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem(route: '/report', icon: AssetImage('assets/home/icon_daily_report.png'), title: '体温上报'),
        HomeItem(route: '/office', icon: AssetImage('assets/home/icon_library.png'), title: '办公')
      ]),
      const SizedBox(height: 20.0),
      const HomeItemGroup([
        HomeItem(route: '/game', icon: AssetImage('assets/home/icon_library.png'), title: '小游戏'),
        HomeItem(route: '/wiki', icon: AssetImage('assets/home/icon_library.png'), title: 'Wiki'),
        HomeItem(route: '/market', icon: AssetImage('assets/home/icon_library.png'), title: '二手书广场'),
      ]),
      const SizedBox(height: 40),
    ];
  }

  Widget _buildBody(BuildContext context, Weather weather) {
    final windowSize = MediaQuery.of(context).size;
    final items = buildFunctionWidgets(weather);

    return Stack(
      children: [
        HomeBackground(int.parse(weather.icon)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      QuickButton.init(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder<Weather>(
        future: getCurrentWeather(1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final weather = snapshot.data!;
            return _buildBody(context, weather);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      drawer: const KiteDrawer(),
    );
  }
}
