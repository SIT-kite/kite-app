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
import 'package:intl/intl.dart';
import 'package:kite/domain/kite/entity/electricity.dart';
import 'package:kite/domain/kite/service/electricity.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/util/flash.dart';

class BalanceSection extends StatelessWidget {
  final String room;

  const BalanceSection(this.room, {Key? key}) : super(key: key);

  Widget _buildView(BuildContext context, Balance balance) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // 设置四周圆角 角度
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        // 设置四周边框
        border: Border.all(width: 2, color: Colors.blue.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
              onPressed: () {
                const String electricityHint = '数据来自校内在线电费查询平台。如有错误，请以充值机显示金额为准~';
                showBasicFlash(context, const Text(electricityHint));
              },
              child: Text('数据不一致?', style: Theme.of(context).textTheme.headline4),
            )
          ]),
          Text('　房间号: ${balance.room}'),
          Text('剩余金额: ${balance.balance.toStringAsFixed(2)}'),
          Text('剩余电量: ${balance.power.toStringAsFixed(2)}'),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text('更新时间: ${DateFormat('yyyy-MM-dd hh:mm').format(balance.ts)}',
                style: Theme.of(context).textTheme.bodyText2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final future = ElectricityService(SessionPool.ssoSession).getBalance(room);

    return FutureBuilder<Balance>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return _buildView(context, snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.runtimeType.toString()));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
