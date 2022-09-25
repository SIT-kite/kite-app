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
import 'package:kite/feature/home/entity/home.dart';
import 'package:kite/global/global.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/user.dart';

class HomeSettingPage extends StatefulWidget {
  const HomeSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSettingPageState();
}

class _HomeSettingPageState extends State<HomeSettingPage> {
  List<FunctionType> homeItems =
      KvStorageInitializer.home.homeItems ?? getDefaultFunctionList(AccountUtils.getUserType()!);

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
    KvStorageInitializer.home.homeItems = homeItems;
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
              homeItems[i].toLocalized(),
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
                  setState(() => homeItems = getDefaultFunctionList(AccountUtils.getUserType()!));
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
        Global.eventBus.emit(EventNameConstants.onHomeItemReorder);
        return true;
      },
    );
  }
}
