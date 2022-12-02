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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kite/module/activity/using.dart';
import 'package:kite/module/library/search/entity/search_history.dart';
import 'package:kite/util/logger.dart';
import 'package:rettulf/rettulf.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

bool _isTypeEditable(dynamic value) {
  return value is String || value is bool;
}

class _StoragePageState extends State<StoragePage> {
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
    final futures = [
      _buildBoxSection<dynamic>(context, 'setting'),
      _buildBoxSection<LibrarySearchHistoryItem>(context, 'librarySearchHistory'),
      _buildBoxSection<dynamic>(context, 'expense2'),
      _buildBoxSection<dynamic>(context, 'course'),
      _buildBoxSection<dynamic>(context, 'userEvent'),
    ];
    return MyFutureBuilder<List<Widget>>(
      future: Future.wait(futures),
      builder: (context, data) {
        return Column(
          children: data,
        );
      },
    );
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

  Future<Widget> _buildBoxSection<T>(BuildContext context, String boxName) async {
    final boxNameStyle = context.textTheme.headline1;
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    final box = await Hive.openBox<T>(boxName);
    final items = box.keys.map((e) {
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
