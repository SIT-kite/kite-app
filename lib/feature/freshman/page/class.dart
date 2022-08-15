import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';

import '../cached_service.dart';
import '../dao.dart';
import '../entity.dart';
import '../init.dart';
import 'component/mate_list.dart';

class FreshmanClassPage extends StatefulWidget {
  const FreshmanClassPage({Key? key}) : super(key: key);

  @override
  State<FreshmanClassPage> createState() => _FreshmanClassPageState();
}

class _FreshmanClassPageState extends State<FreshmanClassPage> {
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  void onRefresh() {
    freshmanCacheManager.clearClassmates();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('班级同学'),
      ),
      body: MyFutureBuilder<List<Mate>>(
        future: freshmanDao.getClassmates(),
        builder: (context, data) {
          return MateListWidget(
            data,
            callBack: onRefresh,
          );
        },
      ),
    );
  }
}
