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
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/component/simple_search_delegate.dart';
import 'package:kite/util/logger.dart';

import '../entity.dart';
import '../init.dart';
import 'component/chart.dart';

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
        cardTitle('用电视图'),
        const SizedBox(height: 20),
        ElectricityChartWidget(
          room: widget.room,
          mode: mode,
        ),
        const SizedBox(height: 5),
        SizedBox(
            width: 300,
            child: AnimatedButtonBar(
              radius: 20,
              invertedSelection: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              children: [
                ButtonBarEntry(
                    onTap: () => setState(() {
                          mode = ElectricityChartMode.hourly;
                        }),
                    child: const Text('最近24小时')),
                ButtonBarEntry(
                    onTap: () => setState(() {
                          mode = ElectricityChartMode.daily;
                        }),
                    child: const Text('最近一周')),
              ],
            ))
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
  String room = '1021501';
  bool isDaily = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电费查询'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SimpleTextSearchDelegate(
                    recentList: ['222', '234'], // 最近查询(需要从hive里获取)，也可留空
                    searchList: ['222', '333', '234'], // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
                  ),
                ).then((value) {
                  Log.info('选择寝室：$value');
                });
              },
              icon: const Icon(
                Icons.search_rounded,
              )),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 5),
          balanceCard(),
          const SizedBox(height: 5),
          rankCard(),
          const SizedBox(height: 25),
          ElectricityChart(room),
        ],
      ),
    );
  }

  ///余额卡片
  Widget balanceCard() {
    return Column(
      children: [
        cardTitle('余额查询'),
        const SizedBox(height: 10),
        MyFutureBuilder<Balance>(
          future: ElectricityInitializer.electricityService.getBalance(room),
          builder: (context, data) {
            return balanceContent(data);
          },
        ),
      ],
    );
  }

  ///余额内容
  Widget balanceContent(Balance data) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 400,
          alignment: AlignmentDirectional.centerEnd,
          decoration: BoxDecoration(
              color: Colors.blueAccent.withAlpha(70),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 5, 10, 5),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 2, color: Colors.black87))),
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    balanceInfo(
                      Icons.offline_bolt,
                      '剩余电量',
                      '${data.power.toStringAsFixed(2)}度',
                    ),
                    balanceInfo(Icons.savings, '剩余金额',
                        '${data.balance.toStringAsFixed(2)}元'),
                  ],
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    balanceInfo(Icons.house, '房间号码', data.room.toString(),
                        width: 90),
                    balanceInfo(Icons.update, '更新时间',
                        DateFormat('MM/dd HH:mm').format(data.ts.toLocal()),
                        width: 90)
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        data.balance > 10 ? const Text('余额充足') : const Text('余额低于10元请尽快充值')
      ],
    );
  }

  ///余额Row封装
  Widget balanceInfo(IconData icon, String title, String content,
      {double? width}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 2),
        Text(title),
        SizedBox(
          width: width ?? 70,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(content),
          ]),
        ),
      ],
    );
  }

  ///排名卡片
  Widget rankCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cardTitle('用电排名'),
        const SizedBox(height: 10),
        MyFutureBuilder<Rank>(
          future: ElectricityInitializer.electricityService.getRank(room),
          builder: (context, data) {
            return rankContent(data);
          },
        ),
      ],
    );
  }

  ///排名内容
  Widget rankContent(Rank data) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: 400,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.blueAccent.withAlpha(70),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            const Icon(
              Icons.stacked_bar_chart,
              size: 100,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '24小时用电消费： ${data.consumption.toStringAsFixed(2)}元',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                    '超过了${(data.rank * 100 / data.roomCount).toStringAsFixed(2)}%宿舍')
              ],
            ))
          ],
        ));
  }
}
