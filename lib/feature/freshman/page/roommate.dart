import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/freshman/cached_service.dart';
import 'package:kite/feature/freshman/page/component/common.dart';

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
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;

  void onRefresh() {
    freshmanCacheManager.clearRoommates();
    setState(() {});
  }

  Widget buildBody(List<Mate> mateList, FreshmanInfo myInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInfoItemRow(
          iconData: Icons.home,
          text: '当前宿舍：${myInfo.campus}-${myInfo.building}-${myInfo.room}',
          context: context,
        ).withTitleBarStyle(context),
        Expanded(child: MateListWidget(mateList, callBack: onRefresh)),
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
          return buildBody(data[0], data[1]);
        },
      ),
    );
  }
}
