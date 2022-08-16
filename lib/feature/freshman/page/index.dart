/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:kite/setting/init.dart';

import '../../../route.dart';

List<FreshmanFunction> list = [
  const FreshmanFunction(Icons.info, RouteTable.freshmanInfo, '我的信息', '查询个人宿舍，辅导员，学院专业等重要信息'),
  const FreshmanFunction(Icons.group, RouteTable.freshmanClass, '我的班级', '查询班级信息'),
  const FreshmanFunction(Icons.bed, RouteTable.freshmanRoommate, '我的舍友', '查询同寝室舍友'),
  const FreshmanFunction(Icons.emoji_emotions, RouteTable.freshmanFamiliar, '新的朋友', '来看看可能认识的人吧'),
  const FreshmanFunction(Icons.safety_check, RouteTable.freshmanContact, '隐私安全', '设置个人联系方式与隐私可见'),
  const FreshmanFunction(Icons.analytics, RouteTable.freshmanAnalysis, '风筝分析报告', '一些关于你有趣的数据分析，可能可以窥探你的大学未来'),
];

//抽象功能
class FreshmanFunction {
  final IconData iconData;
  final String name;
  final String title;
  final String summary;

  const FreshmanFunction(this.iconData, this.name, this.title, this.summary);
}

class FreshmanPage extends StatefulWidget {
  FreshmanPage({Key? key}) : super(key: key);

  @override
  State<FreshmanPage> createState() => _FreshmanPageState();
}

class _FreshmanPageState extends State<FreshmanPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的入学信息'),
      ),
      body: Column(
        children: [Expanded(child: buildFunctionList(list))],
      ),
    );
  }

//建立功能列表项
  Widget buildFunctionItem(FreshmanFunction function) {
    return ListTile(
      leading: SizedBox(
          height: 40,
          width: 40,
          child: Center(
              child: Icon(
            function.iconData,
            size: 35,
            color: Colors.blueAccent,
          ))),
      title: Text(function.title),
      subtitle: Text(function.summary),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        // 若存在新生信息
        if (SettingInitializer.freshman.freshmanSecret != null && SettingInitializer.freshman.freshmanSecret != null) {
          Navigator.of(context).pushNamed(function.name);
          return;
        }
        // 若非新生但存在新生信息则进入
        Navigator.of(context).pushNamed(RouteTable.freshmanLogin);
      },
    );
  }

  //建立功能列表
  Widget buildFunctionList(List<FreshmanFunction> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return buildFunctionItem(list[index]);
      },
    );
  }
}
