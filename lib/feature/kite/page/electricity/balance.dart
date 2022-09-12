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
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/util/flash.dart';

import '../../entity/electricity.dart';
import '../../init.dart';

class BalanceSection extends StatelessWidget {
  final String room;
  final TextStyle style = const TextStyle(fontSize: 20);
  const BalanceSection(this.room, {Key? key}) : super(key: key);

  Widget _buildView(BuildContext context, Balance balance) {
    return Container(
      margin: const EdgeInsets.fromLTRB(35, 30, 35, 0),
      width: 400.w,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // 设置四周圆角 角度
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        // 设置四周边框
        border: Border.all(width: 2, color: Colors.blue.shade400),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'ℹ余额信息',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Text('🏠︎房间号:  ${balance.room}', style: style),
            Text('👛剩余金额:  ${balance.balance.toStringAsFixed(2)}元', style: style),
            Text('🔋剩余电量:  ${balance.power.toStringAsFixed(2)}度', style: style),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text('⏲更新时间:  ${DateFormat('yyyy-MM-dd HH:mm').format(balance.ts.toLocal())}', style: style),
            ),
            SizedBox(height: 30.h),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.info),
                onPressed: () {
                  const String electricityHint = '数据来自校内在线电费查询平台。如有错误，请以充值机显示金额为准~';
                  showBasicFlash(context, const Text(electricityHint));
                },
                label: const Text('数据不一致?', style: TextStyle(fontSize: 18)),
              )
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<Balance>(
      futureGetter: () => KiteInitializer.electricityService.getBalance(room),
      builder: (context, data) {
        return _buildView(context, data);
      },
    );
  }
}
