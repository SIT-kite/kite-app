/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:kite/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

class BoxSection extends StatelessWidget {
  final String boxName;
  final Box<dynamic>? box;

  const BoxSection({super.key, this.box, required this.boxName});

  @override
  Widget build(BuildContext context) {
    final curBox = box;
    final boxNameStyle = context.textTheme.headline1;
    return [
      Text(boxName, style: boxNameStyle).padOnly(b: 20),
      if (curBox == null) Placeholders.loading() else BoxItemList(box: curBox),
    ].column(mas: MainAxisSize.min).sized(width: double.infinity).padAll(20).inCard();
  }
}

class BoxItemList extends StatefulWidget {
  final Box<dynamic> box;

  const BoxItemList({super.key, required this.box});

  @override
  State<BoxItemList> createState() => _BoxItemListState();
}

class _BoxItemListState extends State<BoxItemList> {
  late final keys = widget.box.keys.toList();

  @override
  Widget build(BuildContext context) {
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    final box = widget.box;
    if (box.isEmpty) {
      return i18n.emptyContent.text(style: context.textTheme.displayMedium);
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: keys.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) => BoxItem(
                boxKey: keys[index],
                box: box,
                routeStyle: routeStyle,
                typeStyle: typeStyle,
                contentStyle: contentStyle,
              )).container().scrolled(physics: const NeverScrollableScrollPhysics());
    }
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
