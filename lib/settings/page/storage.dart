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
import 'package:rettulf/rettulf.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({Key? key}) : super(key: key);

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  late final name2Box = HiveBoxInit.name2Box.map((key, value) => MapEntry(key, Future(() => value)));

  @override
  void initState() {
    super.initState();
    debugPaintSizeEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: i18n.localStorageTitle.text()),
      body: buildPortraitBody(ctx).scrolledWithBar(),
    );
  }

  String? selectedBoxName;

  Widget buildLandscape(BuildContext ctx) {
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
    final list = name2Box.entries.map((e) {
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
      final boxGetter = name2Box[name];
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

  Widget buildPortraitBody(BuildContext context) {
    return name2Box.entries
        .map((p) => PlaceholderFutureBuilder<Box<dynamic>>(
            future: p.value,
            builder: (ctx, box, _) {
              return BoxSection(box: box, boxName: p.key);
            }))
        .toList()
        .column();
  }
}

class BoxSection extends StatelessWidget {
  final String boxName;
  final Box<dynamic>? box;

  const BoxSection({super.key, this.box, required this.boxName});

  @override
  Widget build(BuildContext context) {
    final boxNameStyle = context.textTheme.headline1;
    return [
      Text(boxName, style: boxNameStyle).padOnly(b: 20),
      BoxItemList(
        box: box,
        emptyPlaceholder: (ctx) => i18n.emptyContent.text(style: context.textTheme.displayMedium),
      ),
    ].column(mas: MainAxisSize.min).sized(width: double.infinity).padAll(20).inCard();
  }
}

class BoxItemList extends StatefulWidget {
  final Box<dynamic>? box;
  final WidgetBuilder emptyPlaceholder;

  const BoxItemList({super.key, this.box, required this.emptyPlaceholder});

  @override
  State<BoxItemList> createState() => _BoxItemListState();
}

class _BoxItemListState extends State<BoxItemList> {
  @override
  Widget build(BuildContext context) {
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    final box = widget.box;
    final List<Widget> items;
    if (box == null) {
      items = [];
    } else {
      if (box.isEmpty) {
        items = [widget.emptyPlaceholder.call(context)];
      } else {
        items = box.keys
            .map((e) => BoxItem(
                  boxKey: e,
                  box: box,
                  routeStyle: routeStyle,
                  typeStyle: typeStyle,
                  contentStyle: contentStyle,
                ))
            .toList();
      }
    }

    return items.column();
  }
}

class BoxItem extends StatefulWidget {
  final TextStyle? routeStyle;

  final TextStyle? typeStyle;
  final TextStyle? contentStyle;
  final dynamic boxKey;
  final Box<dynamic> box;

  const BoxItem(
      {super.key, this.routeStyle, this.typeStyle, this.contentStyle, required this.boxKey, required this.box});

  @override
  State<BoxItem> createState() => _BoxItemState();

  static Widget skeleton(TextStyle? routeStyle, TextStyle? typeStyle, TextStyle? contentStyle) => [
        Text(
          "...",
          style: routeStyle,
        ),
        Text("...", style: typeStyle),
        Text(
          '.........',
          maxLines: 3,
          style: contentStyle,
        ),
      ].column(caa: CrossAxisAlignment.start).align(at: Alignment.topLeft).padAll(10).inCard(elevation: 5);
}

class _BoxItemState extends State<BoxItem> {
  @override
  Widget build(BuildContext context) {
    final key = widget.boxKey.toString();
    final value = widget.box.get(widget.boxKey);
    final type = value.runtimeType.toString();
    Widget res = [
      Text(
        key,
        style: widget.routeStyle,
      ),
      Text(type, style: widget.typeStyle?.copyWith(color: Editor.isSupport(value) ? Colors.green : null)),
      Text(
        '$value',
        maxLines: 3,
        style: widget.contentStyle?.copyWith(overflow: TextOverflow.ellipsis),
      ),
    ].column(caa: CrossAxisAlignment.start).align(at: Alignment.topLeft).padAll(10).inCard(elevation: 5);
    if (kDebugMode) {
      res = res.on(tap: () async => showContentDialog(context, widget.box, key, value));
      res = Dismissible(
        key: ValueKey(key),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (dir) async {
          final confirm = await context.showRequest(
              title: i18n.warning,
              desc: i18n.localStorageEmptyValueDesc,
              yes: i18n.confirm,
              no: i18n.cancel,
              highlight: true);
          if (confirm == true) {
            widget.box.put(key, _emptyValue(value));
            if (!mounted) return false;
            setState(() {});
          }
          return false;
        },
        child: res,
      );
    }
    return res;
  }

  Future<void> showContentDialog(BuildContext context, Box<dynamic> box, String key, dynamic value) async {
    if (Editor.isSupport(value)) {
      final newValue = await Editor.showAnyEditor(context, value, desc: key, readonlyIfNotSupport: false);
      bool isModified = value != newValue;
      if (isModified) {
        box.put(key, newValue);
        if (!mounted) return;
        setState(() {});
      }
    } else {
      await Editor.showAnyEditor(context, value, desc: key, readonlyIfNotSupport: true);
    }
  }
}

/// THIS IS VERY DANGEROUS!!!
dynamic _emptyValue(dynamic value) {
  if (value is String) {
    return "";
  } else if (value is bool) {
    return false;
  } else if (value is int) {
    return 0;
  } else if (value is double) {
    return 0.0;
  } else if (value is List) {
    value.clear();
    return value;
  } else if (value is Set) {
    value.clear();
    return value;
  } else if (value is Map) {
    value.clear();
    return value;
  } else {
    return null;
  }
}
