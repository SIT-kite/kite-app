import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的舍友'),
      ),
      body: MyFutureBuilder<List<Mate>>(
        future: freshmanDao.getRoommates(),
        builder: (context, data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MateListWidget(data),
          );
        },
      ),
    );
  }
}
