import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/freshman/cache.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/feature/freshman/page/component/familar_list.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanFamiliarPage extends StatefulWidget {
  const FreshmanFamiliarPage({Key? key}) : super(key: key);

  @override
  State<FreshmanFamiliarPage> createState() => _FreshmanFamiliarPageState();
}

class _FreshmanFamiliarPageState extends State<FreshmanFamiliarPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;
  void onRefresh() {
    freshmanCacheManager.clearFamiliars();
    setState(() {});
  }

  Widget buildBody(List<Familiar> familiarList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FamiliarListWidget(
            familiarList,
            onRefresh: onRefresh,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('可能认识的人'),
      ),
      body: MyFutureBuilder<List<Familiar>>(
        future: freshmanDao.getFamiliars(),
        builder: (context, data) {
          return buildBody(data);
        },
      ),
    );
  }
}
