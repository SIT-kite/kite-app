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
import 'package:kite/module/activity/using.dart';
import 'package:kite/module/library/search/entity/search_history.dart';
import 'package:rettulf/rettulf.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({Key? key}) : super(key: key);

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.localStorageTitle.txt),
      body: Scrollbar(
          //always show scrollbar
          thickness: 20,
          radius: const Radius.circular(12),
          interactive: true,
          child: _buildBody(context).scrolled()),
    );
  }

  Widget _buildBody(BuildContext context) {
    final futures = {
      "setting": Future(() => Hive.openBox<dynamic>("setting")),
      "librarySearchHistory": Future(() => Hive.openBox<LibrarySearchHistoryItem>("librarySearchHistory")),
      "expense2": Future(() => Hive.openBox<dynamic>("expense2")),
      "course": Future(() => Hive.openBox<dynamic>("course")),
      "userEvent": Future(() => Hive.openBox<dynamic>("userEvent")),
    };
    return futures.entries
        .map((p) => PlaceholderFutureBuilder<Box<dynamic>>(
            future: p.value,
            builder: (ctx, box, _) {
              return BoxSection(box: box, boxName: p.key);
            }))
        .toList()
        .column();
  }
}

class BoxSection extends StatefulWidget {
  final Box<dynamic>? box;
  final String boxName;

  const BoxSection({super.key, required this.boxName, this.box});

  @override
  State<BoxSection> createState() => _BoxSectionState();
}

class _BoxSectionState extends State<BoxSection> {
  @override
  Widget build(BuildContext context) {
    final boxNameStyle = context.textTheme.headline1;
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    final box = widget.box;
    final List<Widget> items;
    if (box == null) {
      items = [Placeholders.loading()];
    } else {
      items = box.keys.map((e) {
        final key = e.toString();
        final value = box.get(e);
        final type = value.runtimeType.toString();
        return [
          Text(
            key,
            style: routeStyle,
          ),
          Text(type, style: typeStyle?.copyWith(color: Editor.isSupport(value) ? Colors.green : null)),
          Text(
            '$value',
            maxLines: 3,
            style: contentStyle?.copyWith(overflow: TextOverflow.ellipsis),
          ),
        ]
            .column(caa: CrossAxisAlignment.start)
            .align(at: Alignment.topLeft)
            .padAll(10)
            .inCard(elevation: 5)
            .on(tap: kDebugMode ? () async => showContentDialog(context, box, key, value) : null);
      }).toList();
    }
    final sectionBody = items.isNotEmpty ? items : [i18n.emptyContent.text().padAll(10)];
    return [
      Text(widget.boxName, style: boxNameStyle).padOnly(b: 20),
      ...sectionBody,
    ].column(mas: MainAxisSize.min).sized(width: double.infinity).padAll(20).inCard();
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
