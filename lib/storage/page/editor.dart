/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kite/module/activity/using.dart';
import 'package:rettulf/rettulf.dart';

import '../user_widget/box.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({Key? key}) : super(key: key);

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  final Map<String, Future<Box<dynamic>>> name2Box = {};

  @override
  void initState() {
    super.initState();
    refreshBoxes();
  }

  void refreshBoxes() {
    name2Box.clear();
    for (final entry in HiveBoxInit.name2Box.entries) {
      final boxName = entry.key;
      final box = entry.value;
      if (box.isOpen) {
        name2Box[boxName] = Future(() => box);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait
        ? StorageList(
            name2Box,
          )
        : StorageBox(name2Box);
  }
}

class StorageList extends StatefulWidget {
  final Map<String, Future<Box<dynamic>>> name2box;

  const StorageList(this.name2box, {super.key});

  @override
  State<StorageList> createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  final List<MapEntry<String, Future<Box<dynamic>>>> opened = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: i18n.localStorageTitle.text()),
      body: buildBody(ctx).scrolledWithBar(),
    );
  }

  Widget buildBody(BuildContext context) {
    return widget.name2box.entries
        .mapIndexed((i, p) => PlaceholderFutureBuilder<Box<dynamic>>(
            future: p.value.withDelay(Duration(milliseconds: 200 * i)),
            builder: (ctx, box, _) {
              return BoxSection(
                box: box,
                boxName: p.key,
              );
            }))
        .toList()
        .column();
  }
}
