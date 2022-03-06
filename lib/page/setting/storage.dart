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
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/domain/library/entity/search_history.dart';

class DebugStoragePage extends StatelessWidget {
  const DebugStoragePage({Key? key}) : super(key: key);

  Widget _buildBoxSection<T>(BuildContext context, String boxName) {
    final box = Hive.box<T>(boxName);
    final items = box.keys.map((e) {
      final key = e.toString();
      final value = box.get(e);
      final type = value.runtimeType.toString();

      return ListTile(
          title: Text(key, style: Theme.of(context).textTheme.headline3),
          subtitle: Text(value.toString(), style: Theme.of(context).textTheme.bodyText2),
          trailing: Text(type, style: Theme.of(context).textTheme.bodyText1),
          dense: true);
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
            children: <Widget>[Text(boxName, style: Theme.of(context).textTheme.headline3)] + sectionBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildBoxSection<dynamic>(context, 'setting'),
        _buildBoxSection<AuthItem>(context, 'auth'),
        _buildBoxSection<LibrarySearchHistoryItem>(context, 'library.search_history'),
        _buildBoxSection<ContactData>(context, 'contactSetting'),
        _buildBoxSection<dynamic>(context, 'course'),
        _buildBoxSection<dynamic>(context, 'userEvent'),
      ],
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
