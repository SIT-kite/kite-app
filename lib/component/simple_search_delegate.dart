import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

/// 搜索对象的WidgetBuilder
typedef SearchItemBuilder<T> = Widget Function(T itemData, String highlighted);

/// 搜索对象文档化
typedef SearchItemDocumented<T> = String Function(T itemData);

class SimpleTextSearchDelegate<T> extends SearchDelegate {
  final List<T> recentList, suggestionList;
  SearchItemBuilder<T>? searchItemBuilder;
  SearchItemDocumented<T>? searchItemDocumented;
  final bool onlyUseSuggestion;

  SimpleTextSearchDelegate({
    required this.recentList,
    required this.suggestionList,
    this.searchItemBuilder,
    this.searchItemDocumented,
    this.onlyUseSuggestion = true,
  }) {
    searchItemDocumented ??= (item) => item.toString();
    searchItemBuilder ??= (item, highlight) => ListTile(title: HtmlWidget(highlight));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 是否允许用户不仅仅只使用建议里的搜索条目？
    if (!onlyUseSuggestion) {
      close(context, query);
    }
    return Container();
  }

  Widget buildRecentList(BuildContext context) {
    return ListView(
        children: recentList.map((e) {
      return GestureDetector(
        child: searchItemBuilder!(e, searchItemDocumented!(e)),
        onTap: () => close(context, e),
      );
    }).toList());
  }

  String highlight(String e) {
    final splitTextList = e.split(query).map((e1) => "<span style='color:grey'>$e1</span>");
    final highlight = "<span style='color:black;font-weight: bold'>$query</span>";
    return splitTextList.join(highlight);
  }

  Widget buildSearchList(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < suggestionList.length; i++) {
      // 获取对象
      final item = suggestionList[i];

      // 文档化对象
      final documented = searchItemDocumented!(item);

      // 过滤
      if (!documented.contains(query)) continue;

      // 高亮化
      final highlighted = highlight(documented);

      // 搜索结果Widget构建
      final widget = GestureDetector(
        child: searchItemBuilder!(item, highlighted),
        onTap: () => close(context, item),
      );

      children.add(widget);
    }

    return ListView(children: children);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 用户未输入
    if (query.isEmpty) {
      return buildRecentList(context);
    } else {
      return buildSearchList(context);
    }
  }
}
