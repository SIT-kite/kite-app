import 'package:flutter/material.dart';

import 'item.dart';

class HomeItemGroup extends StatelessWidget {
  final List<ItemWidget> _items;

  const HomeItemGroup(this._items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Column(children: _items),
    );
  }
}
