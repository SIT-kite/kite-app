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
import 'package:kite/util/logger.dart';
import 'package:rettulf/rettulf.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({Key? key}) : super(key: key);

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

bool _isTypeEditable(dynamic value) {
  return value is String || value is bool;
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
              return buildBoxSection(ctx, box, p.key);
            }))
        .toList()
        .column();
  }

  Future<void> showContentDialog(BuildContext context, Box<dynamic> box, String key, dynamic value) async {
    if (_isTypeEditable(value)) {
      final edit = await context.showAnyRequest(
          title: key,
          make: (ctx) => SingleChildScrollView(
                child: Column(
                  children: [value.toString().txt],
                ),
              ),
          yes: i18n.edit,
          no: i18n.close,
          highlight: true);
      if (edit == true) {
        if (!mounted) return;
        dynamic newValue;
        if (value is String) {
          newValue = await context.editString(initialValue: value);
        } else if (value is bool) {
          newValue = await context.editBool(initialValue: value);
        } else {
          return;
        }
        // 是否被修改了
        bool isModified = value != newValue;
        if (isModified) box.put(key, newValue);
        if (!mounted) return;
        setState(() {});
      }
    }
  }

  Widget buildBoxSection(BuildContext context, Box<dynamic>? box, String boxName) {
    final boxNameStyle = context.textTheme.headline1;
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    final items = box == null
        ? [Placeholders.loading()]
        : box.keys.map((e) {
            final key = e.toString();
            final value = box.get(e);
            final type = value.runtimeType.toString();
            return [
              Text(
                key,
                style: routeStyle,
              ),
              Text(type, style: typeStyle),
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
    final sectionBody = items.isNotEmpty ? items : [i18n.emptyContent.text().padAll(10)];
    return [
      Text(boxName, style: boxNameStyle).padOnly(b: 20),
      ...sectionBody,
    ].column(mas: MainAxisSize.min).sized(width: double.infinity).padAll(20).inCard();
  }
}

extension _EditDialogEx on BuildContext {
  Future<String?> editString({String? initialValue}) async {
    Log.info('inputString');
    if (initialValue == null) return null;
    final controller = TextEditingController();
    controller.text = initialValue;
    await showAlertDialog(
      this,
      content: TextFormField(
        controller: controller,
      ),
      actionTextList: [i18n.save, i18n.cancel],
    );
    return controller.text;
  }

  Future<bool?> editBool({bool? initialValue}) async {
    if (initialValue == null) return null;
    ValueNotifier<bool> notifier = ValueNotifier(initialValue);
    await showAlertDialog(
      this,
      content: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (BuildContext context, bool value, Widget? child) {
          return Checkbox(value: value, onChanged: (v) => notifier.value = v!);
        },
      ),
      actionTextList: [i18n.save, i18n.cancel],
    );
    return notifier.value;
  }
}
