import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';

import '../dao.dart';
import '../entity.dart';
import '../init.dart';
import 'component/mate_list.dart';

class FreshmanRoommatePage extends StatefulWidget {
  const FreshmanRoommatePage({Key? key}) : super(key: key);

  @override
  State<FreshmanRoommatePage> createState() => _FreshmanRoommatePageState();
}

class _FreshmanRoommatePageState extends State<FreshmanRoommatePage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  Widget buildBody(List<Mate> mateList, FreshmanInfo myInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('当前宿舍：${myInfo.campus}-${myInfo.building}-${myInfo.room}'),
        Expanded(child: MateListWidget(mateList)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的舍友'),
      ),
      body: MyFutureBuilder<List<dynamic>>(
        future: Future.wait([freshmanDao.getRoommates(), freshmanDao.getInfo()]),
        builder: (context, data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildBody(data[0], data[1]),
          );
        },
      ),
    );
  }
}
