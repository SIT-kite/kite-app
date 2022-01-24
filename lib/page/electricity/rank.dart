import 'package:flutter/material.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/kite/electricity.dart';

class RankView extends StatelessWidget {
  final String room;

  RankView(this.room, {Key? key}) : super(key: key);

  final _boxDecoration = BoxDecoration(
      color: Colors.white,
      //设置四周圆角 角度
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      //设置四周边框
      border: Border.all(width: 2, color: Colors.blue.shade400));

  Widget _buildView(Rank rank) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: _boxDecoration,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${rank.consumption}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black)),
            const Text('元', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
          ]),
          Text('24小时消费超越了 ${rank.rank / rank.roomCount}% 的寝室', style: const TextStyle(fontSize: 16)),
          Container(margin: const EdgeInsets.only(top: 5, bottom: 5), height: 1, color: Colors.blue),
          // Text('上次充值 ${getCharge(rank.)} 元'),
          // const Text('( 仅可查询七天内且最新一次充值记录 )')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final future = ElectricityService(SessionPool.ssoSession).getRank(room);

    return FutureBuilder<Rank>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return _buildView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.runtimeType.toString()));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
