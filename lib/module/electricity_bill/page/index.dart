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

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kite/design/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../entity/account.dart';
import '../init.dart';
import '../user_widget/chart.dart';
import '../using.dart';

Widget cardTitle(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      )
    ],
  );
}

class ElectricityChart extends StatefulWidget {
  final String room;

  const ElectricityChart(this.room, {Key? key}) : super(key: key);

  @override
  State<ElectricityChart> createState() => _ElectricityChartState();
}

class _ElectricityChartState extends State<ElectricityChart> {
  ElectricityChartMode mode = ElectricityChartMode.hourly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cardTitle(i18n.elecBillElecChart),
        const SizedBox(height: 20),
        SizedBox(
            width: 300,
            child: AnimatedButtonBar(
              radius: 20,
              invertedSelection: true,
              foregroundColor: context.isDarkMode ? null : context.themeColor,
              children: [
                ButtonBarEntry(
                    onTap: () => setState(() {
                          mode = ElectricityChartMode.hourly;
                        }),
                    child: i18n.elecBillLast24Hour.txt),
                ButtonBarEntry(
                    onTap: () => setState(() {
                          mode = ElectricityChartMode.daily;
                        }),
                    child: i18n.elecBillLast7Day.txt),
              ],
            )),
        const SizedBox(height: 20),
        ElectricityChartWidget(
          room: widget.room,
          mode: mode,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

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

  Future<List> getRoomList() async {
    String jsonData = await rootBundle.loadString("assets/roomlist.json");
    List list = await jsonDecode(jsonData);

    return list;
  }

  @override
  void initState() {
    storage.lastRoomList ??= [];
    if (storage.lastRoomList!.isNotEmpty) room = storage.lastRoomList!.last;
    super.initState();
    getRoomList().then((value) {
      roomList = value.map((e) => e.toString()).toList();
    });
  }

  void search() {
    showSearch(
      context: context,
      delegate: SimpleTextSearchDelegate(
        recentList: storage.lastRoomList!.reversed.toList(), // 最近查询(需要从hive里获取)，也可留空
        suggestionList: roomList, // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
        onlyUseSuggestion: true, // 只允许使用搜索建议里的
      ),
    ).then((value) {
      if (value != null) {
        Log.info('选择宿舍：$value');
        final list = storage.lastRoomList!;
        list.remove(value);
        list.add(value);
        storage.lastRoomList = list;
        setState(() => room = value);
      }
    });
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final selectedRoom = room;
    return Scaffold(
      appBar: AppBar(
        title: selectedRoom != null ? i18n.electricityBillTitle(selectedRoom).txt : i18n.ftype_elecBill.txt,
        actions: <Widget>[
          IconButton(
              onPressed: search,
              icon: const Icon(
                Icons.search_rounded,
              )),
          // IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        scrollDirection: Axis.vertical,
        header: const ClassicHeader(),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext ctx) {
    final selectedRoom = room;
    if (selectedRoom == null) {
      return const Center(
        child: Text('未指定房间号'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 5),
          buildBalanceCard(ctx, selectedRoom),
          const SizedBox(height: 5),
          buildRankCard(ctx, selectedRoom),
          const SizedBox(height: 25),
          ElectricityChart(selectedRoom),
        ],
      ),
    );
  }

  Widget buildBalanceCard(BuildContext ctx, String room) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(children: [cardTitle(i18n.electricityBillBalance), _buildBalanceCardContent(ctx, room)])));
  }

  Widget _buildBalanceCardContent(BuildContext ctx, String room) {
    return PlaceholderFutureBuilder<Balance>(
      future: ElectricityBillInit.electricityService.getBalance(room),
      builder: (context, balance, placeholder) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                if (balance == null)
                  _buildBalanceInfoRowWithPlaceholder(
                      Icons.offline_bolt, i18n.electricityBillRemainingPower, placeholder)
                else
                  _buildBalanceInfoRow(Icons.offline_bolt, i18n.electricityBillRemainingPower,
                      i18n.powerKwh(balance.power.toStringAsFixed(2))),
                if (balance == null)
                  _buildBalanceInfoRowWithPlaceholder(Icons.savings, i18n.electricityBillBalance, placeholder)
                else
                  _buildBalanceInfoRow(
                      Icons.savings, i18n.electricityBillBalance, '¥${balance.balance.toStringAsFixed(2)}',
                      color: balance.balance < 10 ? Colors.red : null),
              ],
            ));
      }
    );
  }

  Widget _buildBalanceInfoRow(IconData icon, String title, String content, {Color? color}) {
    final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(icon),
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
          Icon(icon),
          const SizedBox(width: 10),
          Text(title, style: style),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          LimitedBox(maxWidth: 10, maxHeight: 10, child: placeholder),
        ]),
      ],
    );
  }

  Widget buildUpdateTime(Balance balance, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const Icon(Icons.update),
          const SizedBox(width: 10),
          Text(i18n.electricityBillUpdateTime,
              style: TextStyle(color: balance.ts.difference(DateTime.now()).inDays > 1 ? Colors.redAccent : null)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(updateTimeFormatter.format(balance.ts.toLocal())),
        ]),
      ],
    );
  }

  Widget buildRankCard(BuildContext ctx, String room) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(children: [cardTitle(i18n.electricityBillRank), _buildRankContent(ctx, room)])));
  }

  ///排名内容
  Widget _buildRankContent(BuildContext ctx, String room) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          const Icon(
            Icons.stacked_bar_chart,
            size: 100,
          ),
          Expanded(
              child: PlaceholderFutureBuilder<Rank>(
            future: ElectricityBillInit.electricityService.getRank(room),
            builder: (context, rank, placeholder) {
              if (rank == null) return placeholder;
              final percent = rank.rank * 100 / rank.roomCount;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    i18n.electricityBill24hBill(rank.consumption.toStringAsFixed(2)),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(i18n.electricityBillRankAbove(percent.toStringAsFixed(2)))
                ],
              );
            },
          ))
        ]));
  }
}
