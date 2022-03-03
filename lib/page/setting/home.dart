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
import 'package:kite/entity/home.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/storage_pool.dart';

String functionTypeToString(FunctionType type) {
  switch (type) {
    case FunctionType.upgrade:
      return '更新';
    case FunctionType.notice:
      return '公告';
    case FunctionType.timetable:
      return '课程表';
    case FunctionType.report:
      return '体温上报';
    case FunctionType.exam:
      return '考试信息';
    case FunctionType.classroom:
      return '课程表';
    case FunctionType.event:
      return '活动';
    case FunctionType.expense:
      return '消费';
    case FunctionType.score:
      return '查成绩';
    case FunctionType.library:
      return '图书馆';
    case FunctionType.office:
      return '办公';
    case FunctionType.mail:
      return '邮件';
    case FunctionType.bulletin:
      return 'OA 公告';
    case FunctionType.contact:
      return '常用电话';
    case FunctionType.game:
      return '小游戏';
    case FunctionType.wiki:
      return 'Wiki';
    case FunctionType.separator:
      return '分隔符';
  }
}

class HomeSettingPage extends StatefulWidget {
  const HomeSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSettingPageState();
}

class _HomeSettingPageState extends State<HomeSettingPage> {
  List<FunctionType> homeItems = StoragePool.homeSetting.homeItems ?? defaultFunctionList.toList();

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // 交换数据
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = homeItems.removeAt(oldIndex);
      homeItems.insert(newIndex, item);
    });
    _onSave();
  }

  void _onSave() {
    StoragePool.homeSetting.homeItems = homeItems;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildWidgetItems(List<FunctionType> homeItems) {
      final List<Widget> listItems = [];
      for (int i = 0; i < homeItems.length; ++i) {
        listItems.add(
          ListTile(
            key: Key(i.toString()),
            dense: true,
            trailing: const Icon(Icons.menu),
            title: Text(
              functionTypeToString(homeItems[i]),
              style: homeItems[i] == FunctionType.separator ? const TextStyle(color: Colors.cyan) : null,
            ),
          ),
        );
      }
      return listItems;
    }

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('首页菜单'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() => homeItems = defaultFunctionList);
                  _onSave();
                },
                icon: const Icon(Icons.restore_page_outlined))
          ],
        ),
        body: ReorderableListView(
          children: buildWidgetItems(homeItems),
          onReorder: _onReorder,
        ),
      ),
      onWillPop: () async {
        eventBus.emit(EventNameConstants.onHomeItemReorder);
        return true;
      },
    );
  }
}
