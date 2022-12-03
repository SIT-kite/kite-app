import 'package:auto_animated/auto_animated.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/design/colors.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../user_widgets/contact.dart';

class NavigationContactList extends StatefulWidget {
  final List<ContactData> contacts;

  const NavigationContactList(this.contacts, {super.key});

  @override
  State<StatefulWidget> createState() => _NavigationContactListState();
}

class _NavigationContactListState extends State<NavigationContactList> {
  late Map<String, List<ContactData>> group2List;
  String? _selected;

  @override
  void initState() {
    super.initState();
    group2List = widget.contacts.groupListsBy((contact) => contact.department);
    _selected = group2List.isNotEmpty ? group2List.keys.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return [
      group2List.keys
          .map((name) => buildNavigationItem(context, name))
          .toList()
          .column()
          .scrolled()
          .constrained(BoxConstraints(minWidth: 50.w, maxWidth: 50.w))
          .align(at: Alignment.topCenter),
      const VerticalDivider(width: 0),
      buildListView(context).expanded()
    ].row();
  }

  Widget buildNavigationItem(BuildContext ctx, String name) {
    return ListTile(
            title: name.text(),
            selected: _selected == name,
            selectedColor: Colors.white,
            selectedTileColor: Colors.grey)
        .on(tap: () {
      setState(() {
        _selected = name;
      });
    }).align(at: Alignment.centerLeft);
  }

  Widget buildListView(BuildContext ctx) {
    final selected = _selected;
    if (selected == null) {
      return Container();
    } else {
      final list = group2List[selected];
      if (list == null) {
        return Container();
      }
      return LiveList(
          key: ValueKey(selected),
          itemCount: list.length,
          showItemInterval: const Duration(milliseconds: 100),
          showItemDuration: const Duration(milliseconds: 300),
          itemBuilder: (ctx, index, animation) => ContactTile(list[index]).withAnimation(animation));
    }
  }
}
