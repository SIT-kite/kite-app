import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/pages/library/compoents/fake_search_field.dart';

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
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
    //点击了搜索显示的页面
    return Center(
      child: Text('12312321'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return SearchContentView();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }
}

class SearchContentView extends StatefulWidget {
  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              '大家都在搜',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SearchItemView(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              '历史记录',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SearchItemView()
        ],
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = [
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        // spacing: 10,

        // runSpacing: 0,
        children: items.map((item) {
          return Container(
            padding: EdgeInsets.all(3),
            child: SearchItem(title: item),
          );
        }).toList(),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  @required
  final String? title;
  const SearchItem({Key? key, this.title}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          label: Text(widget.title ?? ""),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () {
          print(widget.title);
        },
      ),
      color: Colors.white,
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: FakeSearchField(
                  onTap: () {
                    showSearch(context: context, delegate: SearchBarDelegate());
                  },
                  suggestion: "Search",
                ),
              ),
              height: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {},
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(),
      ),
    );
    // backgroundColor: BaseColor.colorFFF5F5F5,
  }
}
