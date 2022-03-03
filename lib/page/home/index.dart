/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/kite/weather.dart';
import 'package:kite/session/exception.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/network.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../global/quick_button.dart';
import 'background.dart';
import 'drawer.dart';
import 'greeting.dart';
import 'group.dart';
import 'item/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _updateWeather() {
    Log.info('更新天气');
    Future.delayed(const Duration(milliseconds: 800), () async {
      try {
        final weather = await WeatherService().getCurrentWeather(StoragePool.homeSetting.campus);
        eventBus.emit(EventNameConstants.onWeatherUpdate, weather);
      } catch (_) {}
    });
  }

  Future<void> _doLogin(BuildContext context) async {
    final String username = StoragePool.authSetting.currentUsername!;
    final String password = StoragePool.authPool.get(username)!.password;

    await SessionPool.ssoSession.login(username, password);
  }

  /// 显示检查网络的flash
  void _showCheckNetwork(BuildContext context, {Widget? title}) {
    showBasicFlash(
      context,
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(Icons.dangerous),
        title ?? const Text('请检查当前是否处于校园网环境，例如已连接 EasyConnect'),
        TextButton(
          child: const Text('检查网络'),
          onPressed: () => Navigator.of(context).pushNamed('/connectivity'),
        )
      ]),
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _onHomeRefresh(BuildContext context) async {
    // 如果未登录 (老用户直接进入 Home 页不会处于登录状态, 但新用户经过 login 页时已登录)
    if (!SessionPool.ssoSession.isOnline) {
      try {
        await _doLogin(context);
        showBasicFlash(context, const Text('登录成功'));
      } on Exception catch (e) {
        // 如果是认证相关问题, 弹出相应的错误信息.
        if (e is UnknownAuthException || e is CredentialsInvalidException) {
          showBasicFlash(context, Text('登录异常: $e'));
        } else {
          // 如果是网络问题, 提示检查网络.
          _showCheckNetwork(context, title: Text('$e: 网络异常'));
        }
      }
    }

    if (SessionPool.ssoSession.isOnline) {
      eventBus.emit(EventNameConstants.onHomeRefresh);
    }
    _refreshController.refreshCompleted(resetFooterState: true);

    // 下拉也要更新一下天气 :D
    _updateWeather();
  }

  Widget _buildTitleLine(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        onDoubleTap: () => Navigator.of(context).pushNamed('/egg'),
        child: Center(child: SvgPicture.asset('assets/home/kite.svg', width: 80.w, height: 80.h)),
      ),
    );
  }

  List<Widget> buildFunctionWidgets() {
    return [
      const GreetingWidget(),
      SizedBox(height: 20.h),
      HomeItemGroup([
        UpgradeItem(),
        NoticeItem(),
        TimetableItem(),
        ReportItem(),
        ExamItem(),
      ]),
      SizedBox(height: 20.h),
      HomeItemGroup([
        // ElectricityItem(),
        HomeFunctionButton(
            route: '/classroom', icon: 'assets/home/icon_classroom.svg', title: '空教室', subtitle: '查看教学楼当前空闲的教室'),
        EventItem(),
        ExpenseItem(),
        ScoreItem(),
        LibraryItem(),
        OfficeItem(),
        MailItem(),
        BulletinItem(),
      ]),
      SizedBox(height: 20.h),
      HomeItemGroup([
        // const NightItem(),
        HomeFunctionButton(
            route: '/contact', icon: 'assets/home/icon_contact.svg', title: '常用电话', subtitle: '学校和学院各部门电话'),
        // HomeItem(route: '/lost-found', icon: 'assets/home/icon_lost_found.svg', title: '失物 & 招领', subtitle: '物归原主是一种美'),
        // HomeItem(route: '/market', icon: 'assets/home/icon_market.svg', title: '二手书广场', subtitle: '买与卖都是收获'),
        // HomeItem(route: '/event', icon: 'assets/home/icon_market.svg', title: '第二课堂', subtitle: '买与卖都是收获'),
        HomeFunctionButton(route: '/game', icon: 'assets/home/icon_game.svg', title: '小游戏', subtitle: '放松一下'),
        HomeFunctionButton(route: '/wiki', icon: 'assets/home/icon_wiki.svg', title: 'Wiki', subtitle: '上应大生存指南'),
      ]),
      SizedBox(height: 40.h),
      Image.asset('assets/home/bottom.png'),
    ];
  }

  Widget _buildBody(BuildContext context) {
    final items = buildFunctionWidgets();

    return Stack(
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
              expandedHeight: 0.6.sh,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              elevation: 0,
              pinned: false,
            ),
            SliverList(
              // Functions
              delegate: SliverChildBuilderDelegate(
                (_, index) => Padding(padding: EdgeInsets.only(left: 10.w, right: 10.w), child: items[index]),
                childCount: items.length,
              ),
            ),
          ]),
          onRefresh: () => _onHomeRefresh(context),
        ),
      ],
    );
  }

  @override
  void initState() {
    Log.info('开始加载首页');
    Future.delayed(Duration.zero, () {
      showBasicFlash(
        context,
        const Text('正在检查网络连接'),
        duration: const Duration(seconds: 3),
      );
    });
    // 检查校园网情况
    checkConnectivity().then((ok) {
      if (!ok) {
        _showCheckNetwork(
          context,
          title: const Text('无法连接校园网，部分功能暂不可用'),
        );
      } else {
        showBasicFlash(
          context,
          const Text('当前已连接校园网环境'),
          duration: const Duration(seconds: 3),
        );
      }
    });

    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      QuickButton.init(context);
    }
    _updateWeather();
    eventBus.on(EventNameConstants.onCampusChange, (_) => _updateWeather());
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onCampusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Build Home');
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
      drawer: const KiteDrawer(),
      floatingActionButton: UniversalPlatform.isDesktopOrWeb
          ? FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () async {
                // 刷新页面
                Log.info('浮动按钮被点击');
                // 触发下拉刷新
                final pos = _refreshController.position!;
                await pos.animateTo(-100, duration: const Duration(milliseconds: 800), curve: Curves.linear);

                // pos.jumpTo(-20);
              },
            )
          : null,
    );
  }
}
