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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kite/hive/init.dart';
import 'package:kite/module/activity/using.dart';
import 'package:kite/user_widget/layz_list.dart';
import 'package:rettulf/rettulf.dart';

import '../user_widget/box.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({Key? key}) : super(key: key);

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  late final name2Box = HiveBoxInit.name2Box.map((key, value) => MapEntry(key, Future(() => value)));

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? StorageList(name2Box) : StorageBox(name2Box);
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
      body: buildPortraitBody(ctx).scrolledWithBar(),
    );
  }

  Widget buildPortraitBody(BuildContext context) {
    return widget.name2box.entries
        .map((p) => PlaceholderFutureBuilder<Box<dynamic>>(
            future: p.value,
            builder: (ctx, box, _) {
              return BoxSection(box: box, boxName: p.key);
            }))
        .toList()
        .column();
  }
}

class StorageBox extends StatefulWidget {
  final Map<String, Future<Box<dynamic>>> name2box;

  const StorageBox(this.name2box, {super.key});

  @override
  State<StorageBox> createState() => _StorageBoxState();
}

class _StorageBoxState extends State<StorageBox> {
  String? selectedBoxName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: i18n.localStorageTitle.text(),
          elevation: 0,
        ),
        body: [
          buildBoxIntroduction(ctx).expanded(),
          const VerticalDivider(
            thickness: 5,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: buildBoxContentView(ctx),
          ).padAll(10).flexible(flex: 2)
        ].row());
  }

  Widget buildBoxIntroduction(BuildContext ctx) {
    final boxNameStyle = context.textTheme.headline4;
    final list = widget.name2box.entries.map((e) {
      final name2Box = e;
      final color = name2Box.key == selectedBoxName ? ctx.theme.secondaryHeaderColor : null;
      return name2Box.key.text(style: boxNameStyle).padAll(10).inCard(elevation: 3, color: color).on(tap: () {
        if (selectedBoxName != name2Box.key) {
          setState(() {
            selectedBoxName = name2Box.key;
          });
        }
      });
    }).toList();
    return list.scrolledWithBar();
  }

  Widget buildBoxContentView(BuildContext ctx) {
    final name = selectedBoxName;
    if (name == null) {
      return _buildUnselectBoxTip(ValueKey(name), ctx);
    } else {
      final boxGetter = widget.name2box[name];
      final key = ValueKey(name);
      if (boxGetter == null) {
        return _buildUnselectBoxTip(key, ctx);
      } else {
        final routeStyle = context.textTheme.titleMedium;
        final typeStyle = context.textTheme.bodySmall;
        final contentStyle = context.textTheme.bodyText2;
        return PlaceholderFutureBuilder<Box<dynamic>>(
            key: key,
            future: boxGetter,
            builder: (ctx, box, _) {
              final Widget res;
              if (box == null) {
                res = [
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                ].column();
              } else {
                if (box.isEmpty) {
                  res = _buildEmptyBoxTip(key, ctx);
                } else {
                  res = box.keys
                      .map((e) => BoxItem(
                            boxKey: e,
                            box: box,
                            routeStyle: routeStyle,
                            typeStyle: typeStyle,
                            contentStyle: contentStyle,
                          ))
                      .toList()
                      .scrolledWithBar();
                }
              }
              return res.align(
                at: Alignment.topCenter,
              );
            });
      }
    }
  }

  Widget _buildUnselectBoxTip(Key? key, BuildContext ctx) {
    return LeavingBlank(key: key, icon: Icons.unarchive_outlined, desc: i18n.settingsStorageSelectTip);
  }

  Widget _buildEmptyBoxTip(Key? key, BuildContext ctx) {
    return LeavingBlank(key: key, icon: Icons.inbox_outlined, desc: i18n.emptyContent).sized(height: 300);
  }
}
