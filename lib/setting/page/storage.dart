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
import 'package:hive/hive.dart';
import 'package:kite/feature/contact/entity/contact.dart';
import 'package:kite/feature/library/search/entity/search_history.dart';
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/logger.dart';

class SimpleInputDialog {
  final BuildContext context;
  SimpleInputDialog(this.context);

  Future<String?> inputString({String? initialValue}) async {
    Log.info('inputString');
    if (initialValue == null) return null;
    final controller = TextEditingController();
    controller.text = initialValue;
    await showAlertDialog(
      context,
      content: TextFormField(
        controller: controller,
      ),
      actionTextList: ['提交修改', '取消修改'],
    );
    return controller.text;
  }

  Future<bool?> inputBool({bool? initialValue}) async {
    if (initialValue == null) return null;
    ValueNotifier<bool> notifier = ValueNotifier(initialValue);
    await showAlertDialog(
      context,
      content: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (BuildContext context, bool value, Widget? child) {
          return Checkbox(value: value, onChanged: (v) => notifier.value = v!);
        },
      ),
      actionTextList: ['提交修改', '取消修改'],
    );
    return notifier.value;
  }
}

class DebugStoragePage extends StatefulWidget {
  const DebugStoragePage({Key? key}) : super(key: key);

  @override
  State<DebugStoragePage> createState() => _DebugStoragePageState();
}

class _DebugStoragePageState extends State<DebugStoragePage> {
  Future<bool?> modify(BuildContext context, Box<dynamic> box, String key, dynamic value) async {
    dynamic result = value;
    final input = SimpleInputDialog(context);
    if (value is String) {
      result = await input.inputString(initialValue: value);
    } else if (value is bool) {
      result = await input.inputBool(initialValue: value);
    } else {
      return null;
    }
    // 是否被修改了
    bool isModified = value != result;
    if (isModified) box.put(key, result);
    return isModified;
  }

  void showContentDialog(BuildContext context, Box<dynamic> box, String key, dynamic value) {
    showAlertDialog(
      context,
      title: key,
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(value.toString()),
            if (kDebugMode)
              TextButton(
                onPressed: () async {
                  final result = await modify(context, box, key, value);
                  if (result == null) {
                    EasyLoading.showError('不支持的操作');
                    return;
                  }
                  if (!result) return; // 未修改
                  if (!mounted) return;
                  Navigator.pop(context); // 关闭上一层对话框
                  setState(() {});
                },
                child: const Text('修改'),
              ),
          ],
        ),
      ),
      actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: const Text('关闭')),
      ],
    );
  }

  Future<Widget> _buildBoxSection<T>(BuildContext context, String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    final items = box.keys.map((e) {
      final key = e.toString();
      final value = box.get(e);
      final type = value.runtimeType.toString();

      return ListTile(
        title: Text(key, style: Theme.of(context).textTheme.headline3),
        subtitle: Text(
          '$value',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(overflow: TextOverflow.ellipsis),
        ),
        trailing: Text(type, style: Theme.of(context).textTheme.bodyText1),
        dense: true,
        onTap: () => showContentDialog(context, box, key, value),
      );
    }).toList();
    final sectionBody = items.isNotEmpty ? items : [const Text('无内容')];

    return Card(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(boxName, style: Theme.of(context).textTheme.headline3),
              ...sectionBody,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final futures = [
      _buildBoxSection<dynamic>(context, 'setting'),
      _buildBoxSection<LibrarySearchHistoryItem>(context, 'librarySearchHistory'),
      _buildBoxSection<ContactData>(context, 'contactSetting'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本机存储内容')),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }
}
