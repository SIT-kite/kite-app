import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

typedef TextSelectCallback = void Function(String);

class SimpleTextSearchDelegate extends SearchDelegate {
  final List<String> recentList, searchList;
  SimpleTextSearchDelegate({
    required this.recentList,
    required this.searchList,
  });

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
    return Container();
  }

  Widget buildRecentList({TextSelectCallback? onSelect}) {
    return ListView(
      children: recentList.map((e) {
        return ListTile(
          title: Text(e),
          onTap: () {
            if (onSelect != null) {
              onSelect(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildSearchList({TextSelectCallback? onSelect}) {
    final suggestionList = searchList.where((input) => input.contains(query)).map((e) {
      final splitTextList = e.split(query).map((e1) => "<span style='color:grey'>$e1</span>");
      final highlight = "<span style='color:black;font-weight: bold'>$query</span>";
      return [
        e, // 原文
        splitTextList.join(highlight), // 带有高亮信息的文字
      ];
    }).toList();

    return ListView(
      children: suggestionList.map((e) {
        return ListTile(
          title: HtmlWidget(e[1]),
          onTap: () {
            if (onSelect != null) onSelect(e[0]);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 用户未输入
    if (query.isEmpty) {
      return buildRecentList(onSelect: (select) => close(context, select));
    } else {
      return buildSearchList(onSelect: (select) => close(context, select));
    }
  }
}
