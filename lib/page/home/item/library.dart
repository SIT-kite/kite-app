import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kite/entity/library/hot_search.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';
import 'package:kite/service/library.dart';

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
    eventBus.on('onHomeRefresh', _onHomeRefresh);

    return super.initState();
  }

  @override
  void dispose() {
    eventBus.off('onHomeRefresh', _onHomeRefresh);
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

    final result = '热搜 ${hotItem.hotSearchWord} (${hotItem.count})';
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
