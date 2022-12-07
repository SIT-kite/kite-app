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
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:kite/l10n/extension.dart';
import 'package:kite/user_widget/paginated.dart';
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
  int currentPage = 0;
  final pageSize = 20;

  @override
  Widget build(BuildContext context) {
    final box = widget.box;
    if (box.isEmpty) {
      return i18n.emptyContent.text(style: context.textTheme.displayMedium);
    } else {
      return buildList(context);
    }
  }

  Widget buildList(BuildContext ctx) {
    final length = keys.length;
    if (length < pageSize) {
      return buildBoxItems(ctx, keys);
    } else {
      final start = currentPage * pageSize;
      final totalPages = length ~/ pageSize;
      return [
        buildPaginated(ctx, totalPages).padAll(10),
        buildBoxItems(ctx, keys.sublist(start, min(start + pageSize, length)))
      ].column();
    }
  }

  Widget buildBoxItems(BuildContext ctx, List<dynamic> keys) {
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    return keys
        .map((e) => BoxItem(
              boxKey: e,
              box: widget.box,
              routeStyle: routeStyle,
              typeStyle: typeStyle,
              contentStyle: contentStyle,
            ))
        .toList()
        .column();
  }

  Widget buildPaginated(BuildContext ctx, int totalPage) {
    return Paginated(
      paginateButtonStyles: PaginateButtonStyles(),
      prevButtonStyles: PaginateSkipButton(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
      nextButtonStyles: PaginateSkipButton(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      onPageChange: (number) {
        setState(() {
          currentPage = number;
        });
      },
      useGroup: true,
      totalPage: totalPage,
      show: min(3, totalPage - 1),
      currentPage: currentPage,
    );
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
        direction: _canEmptyValue(value) ? DismissDirection.horizontal : DismissDirection.endToStart,
        confirmDismiss: (dir) async {
          if (dir == DismissDirection.startToEnd) {
            // Empty the value
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
          } else {
            // Set the value to null
            final confirm = await context.showRequest(
                title: i18n.warning,
                desc: i18n.localStorageSetValueNullDesc,
                yes: i18n.confirm,
                no: i18n.cancel,
                highlight: true);
            if (confirm == true) {
              widget.box.put(key, null);
              if (!mounted) return false;
              setState(() {});
            }
          }
          return false;
        },
        child: res,
      );
    } else {
      res = res.on(tap: () async => showContentDialog(context, widget.box, key, value, readonly: true));
    }
    return res;
  }

  Future<void> showContentDialog(BuildContext context, Box<dynamic> box, String key, dynamic value,
      {bool readonly = false}) async {
    if (readonly || !Editor.isSupport(value)) {
      await Editor.showReadonlyEditor(context, key, value);
    } else {
      final newValue = await Editor.showAnyEditor(context, value, desc: key);
      bool isModified = value != newValue;
      if (isModified) {
        box.put(key, newValue);
        if (!mounted) return;
        setState(() {});
      }
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
    return value;
  }
}

dynamic _canEmptyValue(dynamic value) {
  return value is String ||
      value is bool ||
      value is int ||
      value is double ||
      value is List ||
      value is Set ||
      value is Map;
}
