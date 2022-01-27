import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/kite/electricity.dart';
import 'package:kite/util/flash.dart';

class BalanceSection extends StatelessWidget {
  final String room;

  const BalanceSection(this.room, {Key? key}) : super(key: key);

  Widget _buildView(BuildContext context, Balance balance) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        //设置四周圆角 角度
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
              child: Text('数据不一致?', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            )
          ]),
          Text('　房间号: ${balance.room}'),
          Text('剩余金额: ${balance.balance.toStringAsFixed(2)}'),
          Text('剩余电量: ${balance.power.toStringAsFixed(2)}'),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              '更新时间: ${DateFormat('yyyy-MM-dd hh:mm').format(balance.ts)}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
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
