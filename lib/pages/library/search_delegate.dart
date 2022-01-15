import 'package:flutter/material.dart';
import 'package:kite/pages/library/suggestion_items.dart';

class SearchBarDelegate extends SearchDelegate<String> {
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
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    const titleItems = [
      '面试',
      'Studio3',
      '动画dfsfds',
      '自定义View',
      '性能优化',
      'gradle',
      'Camera',
      '代码混淆 安全',
      '逆向加固'
    ];
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
          SuggestionItemView(
            titleItems: titleItems,
            onItemTap: (title) => _searchByGiving(title, context),
          ),
          const SizedBox(height: 20),
          const Text(
            '大家都在搜',
            style: TextStyle(fontSize: 16),
          ),
          SuggestionItemView(
            titleItems: titleItems,
            onItemTap: (title) => _searchByGiving(title, context),
          ),
        ],
      ),
    );
  }
}
