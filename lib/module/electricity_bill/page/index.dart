import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/module/electricity_bill/symbol.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import 'dashboard.dart';
import 'search.dart';

class ElectricityBillPage extends StatefulWidget {
  const ElectricityBillPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityBillPageState();
}

class _Page {
  static const bill = 0;
  static const search = 1;
}

class _ElectricityBillPageState extends State<ElectricityBillPage> {
  /// elevated the `room` to share the state
  /// Null means user should select a room number before all.
  String? _selectedRoom;
  final storage = ElectricityBillInit.electricityStorage;
  List<String>? _searchHistory;
  List<String>? _allRoomNumbers;

  /// For landscape mode Full.
  int curNavigation = _Page.bill;

  Future<List> getRoomNumberList() async {
    String jsonData = await rootBundle.loadString("assets/roomlist.json");
    List list = await jsonDecode(jsonData);
    return list;
  }

  @override
  void initState() {
    super.initState();
    final searchHistory = storage.searchHistory;
    if (searchHistory != null) {
      _searchHistory = searchHistory;
      if (searchHistory.isNotEmpty) {
        _selectedRoom = searchHistory.last;
      }
    }
    getRoomNumberList().then((value) {
      _allRoomNumbers = value.map((e) => e.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (ctx, orient) => orient == Orientation.portrait ? buildPortrait(ctx) : buildLandscape(ctx));
  }

  Widget buildPortrait(BuildContext context) {
    final selectedRoom = _selectedRoom;
    return Scaffold(
        appBar: AppBar(
          title: selectedRoom != null ? i18n.elecBillTitle(selectedRoom).text() : i18n.ftype_elecBill.text(),
          actions: <Widget>[
            IconButton(
                onPressed: search,
                icon: const Icon(
                  Icons.search_rounded,
                )),
          ],
        ),
        body: selectedRoom == null
            ? EmptySearchTip(
                search: search,
              )
            : Dashboard(selectedRoom: selectedRoom));
  }

  Widget buildLandscape(BuildContext ctx) {
    final selectedRoom = _selectedRoom;
    final Widget right;
    if (selectedRoom == null) {
      right = EmptySearchTip(
        search: search,
      );
    } else {
      switch (curNavigation) {
        case _Page.bill:
          right = Dashboard(selectedRoom: selectedRoom);
          break;
        default:
          right = Search(
            searchHistory: _searchHistory ?? [selectedRoom],
            search: search,
            onSelected: selectRoomNumber,
          );
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                ctx.navigator.pop();
              },
            ),
            selectedIndex: curNavigation,
            groupAlignment: 1.0,
            onDestinationSelected: (int index) {
              if (selectedRoom == null && index == _Page.search) {
                search();
              } else {
                setState(() {
                  curNavigation = index;
                });
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.electric_bolt_rounded),
                selectedIcon: const Icon(Icons.bolt_outlined),
                label: i18n.elecBillBillNavigation.text(),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.search_rounded),
                selectedIcon: const Icon(Icons.saved_search_rounded),
                label: i18n.elecBillSearchNavigation.text(),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          right.expanded()
        ],
      ),
    );
  }

  void search() {
    final recentList = _searchHistory ?? [];
    showSearch(
      context: context,
      delegate: SimpleTextSearchDelegate(
        // 最近查询(需要从hive里获取)，也可留空
        recentList: recentList.reversed.toList(),
        // 待搜索提示的列表(需要从服务器获取，可以缓存至数据库)
        suggestionList: _allRoomNumbers ?? [],
        // 只允许使用搜索建议里的
        onlyUseSuggestion: true,
        childAspectRatio: 2.0,
        maxCrossAxisExtent: 150.0,
      ),
    ).then((value) async {
      if (value is String) {
        selectRoomNumber(value);
      }
    });
  }

  void selectRoomNumber(String roomNumber) {
    final recentList = _searchHistory ?? [];
    recentList.remove(roomNumber);
    recentList.add(roomNumber);
    storage.searchHistory = recentList;
    if (!mounted) return;
    setState(() {
      _selectedRoom = roomNumber;
      curNavigation = _Page.bill;
    });
  }
}
