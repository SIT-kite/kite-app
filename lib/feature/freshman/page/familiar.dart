import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
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
  bool isFatherChange = false;

  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  Widget buildBody(List<Familiar> familiarList, Function callBack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: FamiliarListWidget(familiarList, callBack)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isFatherChange.toString()),
      ),
      body: MyFutureBuilder<List<Familiar>>(
        future: freshmanDao.getFamiliars(),
        builder: (context, data) {
          return buildBody(data, callBack());
        },
      ),
    );
  }

  ///回调方法 用于子组件控制父组件刷新页面
  Function callBack() {
    return (bool isChange) {
      setState(() {
        isFatherChange = isChange;
      });
    };
  }
}
