import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/entity/edu/timetable.dart';
import 'package:kite/entity/library/search_history.dart';

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
        _buildBoxSection<Course>(context, 'course'),
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
