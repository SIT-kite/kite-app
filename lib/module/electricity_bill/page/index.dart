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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/account.dart';
import '../init.dart';
import '../user_widget/card.dart';
import '../user_widget/chart.dart';
import '../user_widget/rank.dart';
import '../using.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final storage = ElectricityBillInit.electricityStorage;
  final updateTimeFormatter = DateFormat('MM/dd HH:mm');
  String? room;
  late List<String> roomList;
  Balance? _balance;
  final _rankViewKey = GlobalKey();
  final _chartKey = GlobalKey();

  final _scrollController = ScrollController();
  final _portraitRefreshController = RefreshController();
  final _landscapeRefreshController = RefreshController();

  RefreshController getCurrentRefreshController(BuildContext ctx) =>
      ctx.isPortrait ? _portraitRefreshController : _landscapeRefreshController;

  Future<List> getRoomList() async {
    String jsonData = await rootBundle.loadString("assets/roomlist.json");
    List list = await jsonDecode(jsonData);
    return list;
  }

  @override
  void initState() {
    storage.lastRoomList ??= [];
    if (storage.lastRoomList!.isNotEmpty) {
      room = storage.lastRoomList!.last;
    }
    super.initState();
    getRoomList().then((value) {
      roomList = value.map((e) => e.toString()).toList();
    });
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _portraitRefreshController.dispose();
    _landscapeRefreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    final selectedRoom = room;
    return Scaffold(
        appBar: AppBar(
          title: selectedRoom != null ? i18n.elecBillTitle(selectedRoom).text() : i18n.ftype_elecBill.text(),
          actions: <Widget>[
            IconButton(
                onPressed: search,
                icon: const Icon(
                  Icons.search_rounded,
                )),
          ],
        ),
        body: selectedRoom == null
            ? _buildEmptyBody(context)
            : SmartRefresher(
                controller: _portraitRefreshController,
                scrollDirection: Axis.vertical,
                onRefresh: _onRefresh,
                header: const ClassicHeader(),
                scrollController: _scrollController,
                child: buildBodyPortrait(context, selectedRoom),
              ));
  }

  Widget buildLandscape(BuildContext context) {
    final selectedRoom = room;
    return Scaffold(
        floatingActionButton: PlainButton(
          child: const Icon(Icons.arrow_back),
          tap: () {
            context.navigator.pop();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: selectedRoom == null
            ? _buildEmptyBody(context)
            : SmartRefresher(
                controller: _landscapeRefreshController,
                scrollDirection: Axis.vertical,
                onRefresh: _onRefresh,
                header: const ClassicHeader(),
                scrollController: _scrollController,
                child: buildBodyLandscape(context, selectedRoom),
              ).padAll(20));
  }

  void setRankViewState(void Function(RankViewState state) setter) {
    final state = _rankViewKey.currentState;
    if (state is RankViewState) {
      state.setState(() {
        setter(state);
      });
    }
  }

  void setChartState(void Function(ElectricityChartState state) setter) {
    final state = _chartKey.currentState;
    if (state is ElectricityChartState) {
      state.setState(() {
        setter(state);
      });
    }
  }

  ElectricityChartState? getChartState() {
    final state = _chartKey.currentState;
    if (state is ElectricityChartState) {
      return state;
    }
    return null;
  }

  Future<void> _onRefresh() async {
    final selectedRoom = room;
    if (selectedRoom == null) return;
    setState(() {
      _balance = null;
    });
    setChartState((state) {
      state.dailyBill = null;
      state.hourlyBill = null;
    });
    setRankViewState((state) {
      state.curRank = null;
    });
    await Future.wait([
      Future(() async {
        final newBalance = await ElectricityBillInit.electricityService.getBalance(selectedRoom);
        setState(() {
          _balance = newBalance;
        });
      }),
      Future(() async {
        final newRank = await ElectricityBillInit.electricityService.getRank(selectedRoom);
        setRankViewState((state) {
          state.curRank = newRank;
        });
      }),
      Future(() async {
        final chartState = getChartState();
        if (chartState != null) {
          if (chartState.mode == ElectricityChartMode.daily) {
            final newDailyBill = await ElectricityBillInit.electricityService.getDailyBill(selectedRoom);
            setChartState((state) {
              state.dailyBill = newDailyBill;
            });
          } else {
            final newHourlyBill = await ElectricityBillInit.electricityService.getHourlyBill(selectedRoom);
            setChartState((state) {
              state.hourlyBill = newHourlyBill;
            });
          }
        }
      })
    ]);
    if (!mounted) return;
    getCurrentRefreshController(context).refreshCompleted();
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return buildLeavingBlankBody(ctx, icon: Icons.pageview_outlined, desc: i18n.elecBillInitialTip, onIconTap: search);
  }

  Widget buildBodyPortrait(BuildContext ctx, String room) {
    final balance = _balance;
    return [
      const SizedBox(height: 5),
      buildBalanceCard(ctx),
      const SizedBox(height: 5),
      RankView(key: _rankViewKey),
      const SizedBox(height: 25),
      ElectricityChart(key: _chartKey, room: room),
      buildUpdateTime(context, balance?.ts).align(at: Alignment.bottomCenter),
    ].column().scrolled().padSymmetric(v: 8, h: 20);
  }

  Widget buildBodyLandscape(BuildContext ctx, String room) {
    final balance = _balance;
    return [
      [
        i18n.elecBillTitle(room).text(style: ctx.textTheme.titleSmall),
        const SizedBox(height: 5),
        buildUpdateTime(context, balance?.ts).align(at: Alignment.bottomCenter),
        const SizedBox(height: 5),
        buildBalanceCard(ctx),
        const SizedBox(height: 5),
        RankView(key: _rankViewKey)
      ].column().align(at: Alignment.topCenter).expanded(),
      SizedBox(width: 10.w),
      ElectricityChart(key: _chartKey, room: room).padV(12.h).expanded(),
      //if (balance == null) Container() else buildUpdateTime(context, balance.ts).align(at: Alignment.bottomCenter)
    ].row(maa: MainAxisAlignment.spaceEvenly).scrolled();
  }

  Widget buildBalanceCard(BuildContext ctx) {
    return buildCard(i18n.elecBillBalance, _buildBalanceCardContent(ctx));
  }

  Widget _buildBalanceCardContent(BuildContext ctx) {
    final balance = _balance;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            if (balance == null)
              _buildBalanceInfoRowWithPlaceholder(
                  Icons.offline_bolt, i18n.elecBillRemainingPower, const Center(child: CircularProgressIndicator()))
            else
              _buildBalanceInfoRow(
                  Icons.offline_bolt, i18n.elecBillRemainingPower, i18n.powerKwh(balance.power.toStringAsFixed(2))),
            if (balance == null)
              _buildBalanceInfoRowWithPlaceholder(
                  Icons.savings, i18n.elecBillBalance, const Center(child: CircularProgressIndicator()))
            else
              _buildBalanceInfoRow(Icons.savings, i18n.elecBillBalance, '¥${balance.balance.toStringAsFixed(2)}',
                  color: balance.balance < 10 ? Colors.red : null),
          ],
        ));
  }

  Widget _buildBalanceInfoRow(IconData icon, String title, String content, {Color? color}) {
    final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(
            icon,
            color: context.fgColor,
          ),
          const SizedBox(width: 10),
          Text(title, style: style),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(content, style: style),
        ]),
      ],
    );
  }

  Widget _buildBalanceInfoRowWithPlaceholder(IconData icon, String title, Widget placeholder) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(
            icon,
            color: context.fgColor,
          ),
          const SizedBox(width: 10),
          Text(title, style: style),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          LimitedBox(maxWidth: 10, maxHeight: 10, child: placeholder),
        ]),
      ],
    );
  }

  Widget buildUpdateTime(BuildContext ctx, DateTime? time) {
    final outOfDateColor = time != null && time.difference(DateTime.now()).inDays > 1 ? Colors.redAccent : null;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.update),
              const SizedBox(width: 10),
              Text(i18n.elecBillUpdateTime, style: TextStyle(color: outOfDateColor)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time != null ? updateTimeFormatter.format(time.toLocal()) : "..."),
            ]),
          ],
        )).center();
  }

  void search() {
    showSearch(
      context: context,
      delegate: SimpleTextSearchDelegate(
        recentList: storage.lastRoomList!.reversed.toList(),
        // 最近查询(需要从hive里获取)，也可留空
        suggestionList: roomList,
        // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
        onlyUseSuggestion: true,
        // 只允许使用搜索建议里的
        childAspectRatio: 2.0,
        maxCrossAxisExtent: 150.0,
      ),
    ).then((value) async {
      if (value != null) {
        Log.info('选择宿舍：$value');
        final list = storage.lastRoomList!;
        list.remove(value);
        list.add(value);
        storage.lastRoomList = list;
        setState(() => room = value);
        await _onRefresh();
      }
    });
  }
}
