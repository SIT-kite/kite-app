/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rettulf/rettulf.dart';

/// 搜索对象的WidgetBuilder
typedef SearchItemBuilder<T> = Widget Function(T itemData, String highlighted);

/// 搜索对象文档化
typedef SearchItemDocumented<T> = String Function(T itemData);

class SimpleTextSearchDelegate<T> extends SearchDelegate {
  final List<T> recentList, suggestionList;
  SearchItemBuilder<T>? searchItemBuilder;
  SearchItemDocumented<T>? searchItemDocumented;
  final bool onlyUseSuggestion;
  final double maxCrossAxisExtent;
  final double childAspectRatio;

  SimpleTextSearchDelegate({
    required this.recentList,
    required this.suggestionList,
    this.searchItemBuilder,
    this.searchItemDocumented,
    this.onlyUseSuggestion = true,
    this.maxCrossAxisExtent = 150.0,
    this.childAspectRatio = 2.0,
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

  String highlight(BuildContext ctx, String e) {
    final splitTextList = e.split(query).map((e1) => "<span style='color:grey'>$e1</span>");
    final highlight = "<span style='color:${ctx.highlightColor};font-weight: bold'>$query</span>";
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
      final highlighted = highlight(context, documented);

      // 搜索结果Widget构建
      final widget = GestureDetector(
        child: searchItemBuilder!(item, highlighted),
        onTap: () => close(context, item),
      );

      children.add(widget);
    }

    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio),
      children: children,
    );
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

extension _CssColorEx on BuildContext {
  String get highlightColor => isDarkMode ? "white" : "black";
}
