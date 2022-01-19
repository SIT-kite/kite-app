import 'package:flutter/material.dart';
import 'package:kite/entity/library/hot_search.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/library/component/search_result.dart';
import 'package:kite/page/library/component/suggestion_item.dart';
import 'package:kite/service/library.dart';
import 'package:kite/util/logger.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  Widget? _suggestionView;

  /// 给定一个关键词，开始搜索该关键词
  void _searchByGiving(String title, BuildContext context) async {
    query = title;

    // 若已经显示过结果，这里无法直接再次显示结果
    // 经测试，需要先返回搜索建议页，在等待若干时间后显示结果
    showSuggestions(context);
    await Future.delayed(const Duration(seconds: 1));
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
        _searchByGiving(key, context);
      },
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
            const Text(
              '历史记录',
              style: TextStyle(fontSize: 16),
            ),
            SuggestionItemView(
              titleItems: StoragePool.librarySearchHistory.getAllByTimeDesc().map((e) => e.keyword).toList(),
              onItemTap: (title) => _searchByGiving(title, context),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.clear_all),
                  Text('清空搜索历史'),
                ],
              ),
              onTap: () async {
                StoragePool.librarySearchHistory.deleteAll();
                close(context, '');
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '大家都在搜',
              style: TextStyle(fontSize: 16),
            ),
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
                    onItemTap: (title) => _searchByGiving(title, context),
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
