import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/entity/edu/timetable.dart';
import 'package:kite/entity/library/search_history.dart';

class DebugStoragePage extends StatelessWidget {
  const DebugStoragePage({Key? key}) : super(key: key);

  final textStyle = const TextStyle(fontFamily: "monospace");

  Widget _buildBoxSection<T>(String boxName) {
    final box = Hive.box<T>(boxName);
    final items = box.keys.map((e) {
      final key = e.toString();
      final value = box.get(e);
      final type = value.runtimeType.toString();

      return ListTile(
          title: Text(key, style: textStyle),
          subtitle: Text(value.toString(), style: textStyle),
          trailing: Text(type, style: textStyle),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text(boxName, style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold))] +
                sectionBody,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildBoxSection<dynamic>('setting'),
        _buildBoxSection<AuthItem>('auth'),
        _buildBoxSection<LibrarySearchHistoryItem>('library.search_history'),
        _buildBoxSection<ContactData>('contactSetting'),
        _buildBoxSection<Course>('course'),
        _buildBoxSection<dynamic>('userEvent'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本机存储内容')),
      body: SingleChildScrollView(child: _buildBody()),
    );
  }
}
