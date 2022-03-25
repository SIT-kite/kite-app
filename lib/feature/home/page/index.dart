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
import 'package:kite/exception/session.dart';
import 'package:kite/feature/kite/service/weather.dart';
import 'package:kite/feature/quick_button/init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/network.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/home.dart';
import '../init.dart';
import 'background.dart';
import 'drawer.dart';
import 'greeting.dart';
import 'group.dart';
import 'item/index.dart';

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
        final weather = await WeatherService().getCurrentWeather(SettingInitializer.home.campus);
        Global.eventBus.emit(EventNameConstants.onWeatherUpdate, weather);
      } catch (_) {}
    });
  }

  Future<void> _doLogin(BuildContext context) async {
    final String username = SettingInitializer.auth.currentUsername!;
    final String password = SettingInitializer.auth.ssoPassword!;

    await HomeInitializer.ssoSession.login(username, password);
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
    if (!HomeInitializer.ssoSession.isOnline) {
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

    if (HomeInitializer.ssoSession.isOnline) {
      Global.eventBus.emit(EventNameConstants.onHomeRefresh);
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
    List<FunctionType> list =
        SettingInitializer.home.homeItems ?? getDefaultFunctionList(SettingInitializer.auth.userType!);

    // 先遍历一遍，过滤相邻重复元素
    FunctionType lastItem = list.first;
    for (int i = 1; i < list.length; ++i) {
      if (lastItem == list[i]) {
        list.removeAt(i);
        i -= 1;
      } else {
        lastItem = list[i];
      }
    }

    final separator = SizedBox(height: 20.h);
    final List<Widget> result = [];
    List<Widget> currentGroup = [];

    for (final item in list) {
      if (item == FunctionType.separator) {
        result.addAll([HomeItemGroup(currentGroup), separator]);
        currentGroup = [];
      } else {
        currentGroup.add(FunctionButtonFactory.createFunctionButton(item));
      }
    }
    return [const GreetingWidget(), separator] + result + [separator, Image.asset('assets/home/bottom.png')];
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

  /// 如果登录信息过期，那么自动刷新一次
  void _refreshIfOutdated() async {
    DateTime? lastLoginTime = SettingInitializer.loginTime.sso;
    if (lastLoginTime == null) {
      await _onHomeRefresh(context);
      return;
    }
    DateTime now = DateTime.now();
    final duration = now.difference(lastLoginTime);
    if (duration.inSeconds > 3600) {
      await _onHomeRefresh(context);
      return;
    }
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
    HomeInitializer.ssoSession.checkConnectivity().then((ok) {
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
        _refreshIfOutdated();
      }
    });

    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      QuickButton.init(context);
    }
    _updateWeather();
    Global.eventBus.on(EventNameConstants.onCampusChange, (_) => _updateWeather());
    Global.eventBus.on(EventNameConstants.onHomeItemReorder, (_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onCampusChange);
    Global.eventBus.off(EventNameConstants.onHomeItemReorder);
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
              },
            )
          : null,
    );
  }
}
