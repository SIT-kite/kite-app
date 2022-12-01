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
  final RefreshController _refreshController = RefreshController();
  final _rankViewKey = GlobalKey();
  final _chartKey = GlobalKey();

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

  void search() {
    showSearch(
      context: context,
      delegate: SimpleTextSearchDelegate(
        recentList: storage.lastRoomList!.reversed.toList(), // 最近查询(需要从hive里获取)，也可留空
        suggestionList: roomList, // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
        onlyUseSuggestion: true, // 只允许使用搜索建议里的
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
    _refreshController.refreshCompleted();
  }

  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final selectedRoom = room;
    return Scaffold(
        appBar: AppBar(
          title: selectedRoom != null ? i18n.elecBillTitle(selectedRoom).txt : i18n.ftype_elecBill.txt,
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
                controller: _refreshController,
                scrollDirection: Axis.vertical,
                onRefresh: _onRefresh,
                header: const ClassicHeader(),
                scrollController: _scrollController,
                child: _buildBody(context, selectedRoom),
              ));
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return buildLeavingBlankBody(ctx, icon: Icons.pageview_outlined, desc: i18n.elecBillInitialTip, onIconTap: search);
  }

  Widget _buildBody(BuildContext ctx, String room) {
    final balance = _balance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      // TODO: The pull to refresh is hard to use in landscape mode.
      child: ListView(
        controller: _scrollController,
        children: [
          const SizedBox(height: 5),
          buildBalanceCard(ctx),
          const SizedBox(height: 5),
          RankView(key: _rankViewKey),
          const SizedBox(height: 25),
          ElectricityChart(key: _chartKey, room: room),
          if (balance == null)
            Container()
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: buildUpdateTime(context, balance.ts),
            )
        ],
      ),
    );
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

  Widget buildUpdateTime(BuildContext ctx, DateTime time) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.update),
              const SizedBox(width: 10),
              Text(i18n.elecBillUpdateTime,
                  style: TextStyle(color: time.difference(DateTime.now()).inDays > 1 ? Colors.redAccent : null)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(updateTimeFormatter.format(time.toLocal())),
            ]),
          ],
        )).center();
  }
}
