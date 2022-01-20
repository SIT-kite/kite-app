import 'package:flutter/material.dart';
import 'package:kite/page/electricity/model.dart';
import 'package:kite/service/electricity.dart';
import 'package:kite/entity/electricity.dart';

Widget buildBalance(context, String room) {
  return FutureBuilder<Balance>(
      future: fetchBalance(room),
      builder: (context, snapshot) {
        return Container(
            padding: const EdgeInsets.only(
              top: 5,
              right: 10,
              left: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              //设置四周边框
              border: Border.all(width: 2, color: Colors.blue.shade400),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {
                    buildModel(context, '此数据来源于校内在线电费查询平台。如有错误，请以充值机显示金额为准～');
                  },
                  // Change button text when light changes state.
                  child: Text('数据不一致?',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                )
              ]),
              Text('房间号: ${snapshot.data!.room}'),
              Text('剩余金额: ${snapshot.data!.balance}'),
              Text('剩余电量: ${snapshot.data!.power}'),
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text('更新时间: ${snapshot.data!.ts}',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12))),
            ]));
      });
}
