import 'package:flutter/material.dart';
import 'package:kite/entity/library/hot_search.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/mock/HotSearchMock.dart';
import 'package:kite/pages/library/suggestion_items.dart';
import 'package:kite/storage/search_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  /// 给定一个关键词，开始搜索该关键词
  void _searchByGiving(String title, BuildContext context) {
    query = title;
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
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: const Icon(Icons.search),
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
    SharedPreferences.getInstance().then((value) {
      SearchHistoryStorage(value).add(SearchHistoryItem(
        query,
        DateTime.now(),
      ));
    });
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            '历史记录',
            style: TextStyle(fontSize: 16),
          ),
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // 请求已结束
              if (snapshot.connectionState == ConnectionState.done) {
                SharedPreferences prefs = snapshot.data;
                return SuggestionItemView(
                  titleItems: SearchHistoryStorage(prefs).getAllByTimeDesc().itemList.map((e) => e.keyword).toList(),
                  onItemTap: (title) => _searchByGiving(title, context),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            '大家都在搜',
            style: TextStyle(fontSize: 16),
          ),
          FutureBuilder<HotSearch>(
            future: HotSearchMock().getHotSearch(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // 若请求结束
              if (snapshot.connectionState == ConnectionState.done) {
                // 获取数据
                HotSearch hotSearch = snapshot.data;
                return SuggestionItemView(
                  titleItems: hotSearch.recentMonth.map((e) => e.hotSearchWord).toList(),
                  onItemTap: (title) => _searchByGiving(title, context),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
