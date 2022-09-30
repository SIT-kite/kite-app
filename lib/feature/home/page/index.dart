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
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/exception/session.dart';
import 'package:kite/feature/kite/service/weather.dart';
import 'package:kite/feature/login/init.dart';
import 'package:kite/feature/override/entity.dart';
import 'package:kite/feature/override/init.dart';
import 'package:kite/feature/quick_button/init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/launch.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/dsl.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/scanner.dart';
import 'package:kite/util/user.dart';
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
  final overrideFunctionNotifier = ValueNotifier<FunctionOverrideInfo?>(null);
  late bool isFreshman;

  void _updateWeather() {
    Log.info('更新天气');
    Future.delayed(const Duration(milliseconds: 800), () async {
      try {
        final weather = await WeatherService().getCurrentWeather(KvStorageInitializer.home.campus);
        Global.eventBus.emit(EventNameConstants.onWeatherUpdate, weather);
      } catch (_) {}
    });
  }

  Future<void> _doLogin(BuildContext context) async {
    final String username = KvStorageInitializer.auth.currentUsername!;
    final String password = KvStorageInitializer.auth.ssoPassword!;

    await HomeInitializer.ssoSession.login(username, password);

    if (KvStorageInitializer.auth.personName == null) {
      final personName = await LoginInitializer.authServerService.getPersonName();
      KvStorageInitializer.auth.personName = personName;
    }
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

  Future<void> _onHomeRefresh(
    BuildContext context, [
    bool loginSso = false, // 默认不登录oa，使用懒加载的方式登录
  ]) async {
    if (isFreshman) {
      _refreshController.refreshCompleted(resetFooterState: true);
      _updateWeather();
      return;
    }
    if (loginSso) {
      // 如果未登录 (老用户直接进入 Home 页不会处于登录状态, 但新用户经过 login 页时已登录)
      try {
        await _doLogin(context);
        if (!mounted) return;
        showBasicFlash(context, i18n.kiteLoggedInTip.txt);
      } on Exception catch (e) {
        // 如果是认证相关问题, 弹出相应的错误信息.
        if (e is UnknownAuthException || e is CredentialsInvalidException) {
          showBasicFlash(context, Text('${i18n.kiteLoginFailedTip}: $e'));
        } else {
          // 如果是网络问题, 提示检查网络.
          _showCheckNetwork(context, title: i18n.networkXcpWarn.txt);
        }
      } catch (e, s) {
        Catcher.reportCheckedError(e, s);
      }

      if (HomeInitializer.ssoSession.isOnline) {
        Global.eventBus.emit(EventNameConstants.onHomeRefresh);
      }
    }
    _refreshController.refreshCompleted(resetFooterState: true);

    // 下拉也要更新一下天气 :D
    _updateWeather();

    // TODO 未设置缓存策略，暂时先直接清空缓存
    KvStorageInitializer.override.cache = null;
    FunctionOverrideInitializer.cachedService.get().then((value) {
      Global.eventBus.emit(
        EventNameConstants.onRouteRefresh,
        value,
      );
      overrideFunctionNotifier.value = value;
    });
  }

  Widget _buildTitleLine(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        onDoubleTap: () => Navigator.of(context).pushNamed(RouteTable.egg),
        child: Center(child: SvgPicture.asset('assets/home/kite.svg', width: 80.w, height: 80.h)),
      ),
    );
  }

  List<Widget> buildFunctionWidgets(List<ExtraHomeItem>? extraItemList, List<HomeItemHideInfo>? hideInfoList) {
    // print(extraItemList);
    UserType userType = AccountUtils.getUserType()!;
    List<FunctionType> list = KvStorageInitializer.home.homeItems ?? getDefaultFunctionList(userType);
    final filter = HomeItemHideInfoFilter(hideInfoList ?? []);

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
        if (!filter.accept(item, userType)) {
          currentGroup.add(FunctionButtonFactory.createFunctionButton(context, item));
        }
      }
    }

    if (extraItemList != null) {
      result.addAll([
        HomeItemGroup(
          extraItemList.map((e) => buildHomeFunctionButtonByExtraHomeItem(context, e)).toList(),
        ),
        separator,
      ]);
    }

    return [
      const GreetingWidget(),
      separator,
      ...result,
      separator,
      Image.asset('assets/home/bottom.png'),
    ];
  }

  Widget buildMainBody() {
    Widget buildByChildren(List<Widget> items) {
      return SliverList(
        // Functions
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: items[index],
          ),
          childCount: items.length,
        ),
      );
    }

    return ValueListenableBuilder<FunctionOverrideInfo?>(
      valueListenable: overrideFunctionNotifier,
      builder: (context, data, child) => buildByChildren(
        buildFunctionWidgets(
          data?.extraHomeItem,
          data?.homeItemHide,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        const HomeBackground(),
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                // AppBar
                actions: [
                  if (!UniversalPlatform.isDesktopOrWeb)
                    IconButton(
                      onPressed: () async {
                        final result = await scan(context);
                        Log.info('扫码结果: $result');
                        if (result != null) GlobalLauncher.launch(result);
                      },
                      icon: const Icon(Icons.qr_code_scanner_outlined),
                      iconSize: 30,
                    )
                ],
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildTitleLine(context),
                ),
                expandedHeight: 0.6.sh,
                backgroundColor: Colors.transparent,
                centerTitle: false,
                elevation: 0,
                pinned: false,
              ),
              buildMainBody(),
            ],
          ),
          onRefresh: () => _onHomeRefresh(context, true),
        ),
      ],
    );
  }

  @override
  void initState() {
    isFreshman = AccountUtils.getUserType() == UserType.freshman;
    Log.info('开始加载首页');

    Future.delayed(Duration.zero, () async {
      if (KvStorageInitializer.home.autoLaunchTimetable ?? false) {
        Navigator.of(context).pushNamed(RouteTable.timetable);
      }
      // 非新生才执行该网络检查逻辑
      if (!isFreshman && await HomeInitializer.ssoSession.checkConnectivity()) {
        showBasicFlash(
          context,
          i18n.homepageCampusNetworkConnected.txt,
          duration: const Duration(seconds: 3),
        );
      }
    });

    _onHomeRefresh(context);
    // 非新生且使用手机
    if (!isFreshman && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
      QuickButton.init(context);
    }
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

  Widget? buildFloatingActionButton() {
    return UniversalPlatform.isDesktopOrWeb
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
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Build Home');
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        child: _buildBody(context),
        onHorizontalDragEnd: (d) {
          // 速度达标，展示drawer
          if (d.velocity.pixelsPerSecond.dx > 100) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
      ),
      drawer: const KiteDrawer(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}
