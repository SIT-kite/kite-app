import 'package:flutter/material.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/electricity/util.dart';

Widget buildRank(String room, List<ConditionDays> list) {
  return FutureBuilder<Map<String, dynamic>>(
      future: getRank(room), builder: (context, snapshot) {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: Border.all(width: 2, color: Colors.blue.shade400),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${snapshot.data!['consumption']}', style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black)),
              const Text('元', style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey)),
            ]),
            Text('24小时消费超越了 ${snapshot.data!['percentage']}% 的寝室', style: const TextStyle(fontSize: 16)),
            Container(margin: const EdgeInsets.only(top: 5, bottom: 5),
                height: 1,
                color: Colors.blue),
            Text('上次充值 ${getCharge(list)} 元'),
            const Text('( 仅可查询七天内且最新一次充值记录 )')
          ],
        ));
  });
}
