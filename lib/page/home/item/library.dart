import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class LibraryItem extends StatefulWidget {
  const LibraryItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeItem(route: '/library', icon: 'assets/home/icon_library.svg', title: '图书馆');
  }
}
