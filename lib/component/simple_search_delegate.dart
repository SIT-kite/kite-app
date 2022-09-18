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
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("搜索的结果：$query"),
    );
  }

  Widget buildRecentList({
    TextSelectCallback? onSelect,
  }) {
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

  Widget buildSearchList({
    TextSelectCallback? onSelect,
  }) {
    final suggestionList = searchList.where((input) => input.contains(query)).map((e) {
      final splitTextList = e.split(query).map((e) => "<span style='color:grey'>$e</span>");
      final highlight = "<span style='color:black;font-weight: bold'>$query</span>";
      return splitTextList.join(highlight);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final String itemText = suggestionList[index];
        return ListTile(
          title: () {
            return HtmlWidget(itemText);
            // return RichText(
            //   text: TextSpan(
            //     text: itemText.substring(0, query.length),
            //     style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            //     children: [
            //       TextSpan(
            //         text: itemText.substring(query.length),
            //         style: const TextStyle(color: Colors.grey),
            //       )
            //     ],
            //   ),
            // );
          }(),
          onTap: () {
            if (onSelect != null) onSelect(itemText);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 用户未输入
    if (query.isEmpty) {
      return buildRecentList(onSelect: (select) => query = select);
    } else {
      return buildSearchList(
        onSelect: (select) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(query)));
        },
      );
    }
  }
}
