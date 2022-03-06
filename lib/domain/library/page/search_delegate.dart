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
import 'package:kite/domain/library/entity/book_search.dart';
import 'package:kite/domain/library/entity/hot_search.dart';
import 'package:kite/domain/library/entity/search_history.dart';
import 'package:kite/domain/library/service/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/util/logger.dart';

import 'component/search_result.dart';
import 'component/suggestion_item.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  Widget? _suggestionView;

  /// 当前的搜索模式
  SearchWay _searchWay = SearchWay.any;

  /// 给定一个关键词，开始搜索该关键词
  void _searchByGiving(BuildContext context, String key, {SearchWay searchWay = SearchWay.any}) async {
    query = key;

    // 若已经显示过结果，这里无法直接再次显示结果
    // 经测试，需要先返回搜索建议页，在等待若干时间后显示结果
    showSuggestions(context);
    await Future.delayed(const Duration(seconds: 1));

    _searchWay = searchWay;
    showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // 右侧的action区域，这里放置一个清除按钮
    return [
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        if (query.isEmpty) {
          close(context, "");
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    StoragePool.librarySearchHistory.add(
      LibrarySearchHistoryItem()
        ..keyword = query
        ..time = DateTime.now(),
    );
    return BookSearchResultWidget(
      query,
      requestQueryKeyCallback: (String key) {
        _searchByGiving(
          context,
          key,
          searchWay: SearchWay.author,
        );
      },
      searchWay: _searchWay,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 第一次使用时，_suggestionView为空，那就构造，后面直接用
    _suggestionView ??= _buildSearchSuggestion(context);
    return _suggestionView!;
  }

  /// 构造下方搜索建议
  Widget _buildSearchSuggestion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Text('历史记录', style: Theme.of(context).textTheme.bodyText1),
            SuggestionItemView(
              titleItems: StoragePool.librarySearchHistory.getAllByTimeDesc().map((e) => e.keyword).toList(),
              onItemTap: (title) => _searchByGiving(context, title),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.clear_all),
                  Text('清空搜索历史', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onTap: () async {
                StoragePool.librarySearchHistory.deleteAll();
                close(context, '');
              },
            ),
            const SizedBox(height: 20),
            Text('大家都在搜', style: Theme.of(context).textTheme.bodyText1),
            FutureBuilder<HotSearch>(
              // future: HotSearchMock().getHotSearch(),
              future: HotSearchService(SessionPool.librarySession).getHotSearch(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Log.info('获取热搜状态: ${snapshot.connectionState}');

                if (snapshot.hasData) {
                  // 获取数据
                  HotSearch hotSearch = snapshot.data!;
                  return SuggestionItemView(
                    titleItems: hotSearch.recentMonth.map((e) => e.hotSearchWord).toList(),
                    onItemTap: (title) => _searchByGiving(context, title),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
