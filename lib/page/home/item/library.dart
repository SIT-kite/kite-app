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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kite/entity/library/hot_search.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item/item.dart';
import 'package:kite/service/library/index.dart';

class LibraryItem extends StatefulWidget {
  const LibraryItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
  static const String defaultContent = '馆藏书籍和借阅情况';
  String? content;

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);

    return super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent();
    setState(() => content = result);
  }

  Future<String> _buildContent() async {
    final librarySession = SessionPool.librarySession;
    late HotSearch hotSearch;

    try {
      hotSearch = await HotSearchService(librarySession).getHotSearch();
    } catch (e) {
      return e.runtimeType.toString();
    }
    final monthlyHot = hotSearch.recentMonth;
    final randomIndex = Random().nextInt(monthlyHot.length);
    final hotItem = monthlyHot[randomIndex];

    final result = '热搜: ${hotItem.hotSearchWord} (${hotItem.count})';
    StoragePool.homeSetting.lastHotSearch = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载
    if (content == null) {
      final lastHotSearch = StoragePool.homeSetting.lastHotSearch;
      content = lastHotSearch ?? defaultContent;
    }
    return HomeItem(route: '/library', icon: 'assets/home/icon_library.svg', title: '图书馆', subtitle: content);
  }
}
