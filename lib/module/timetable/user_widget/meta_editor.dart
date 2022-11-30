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
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/meta.dart';
import 'button.dart';
import 'picker.dart';
import '../using.dart';

class MetaEditor extends StatefulWidget {
  final TimetableMeta meta;
  final DateTime? defaultStartDate;

  const MetaEditor({super.key, required this.meta, this.defaultStartDate});

  @override
  State<MetaEditor> createState() => _MetaEditorState();
}

class _MetaEditorState extends State<MetaEditor> {
  late final _nameController = TextEditingController(text: widget.meta.name);
  late final _descController = TextEditingController(text: widget.meta.description);
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final ValueNotifier<DateTime> _selectedDate = ValueNotifier(widget.defaultStartDate ??
      Iterable.generate(7, (i) {
        return DateTime.now().add(Duration(days: i));
      }).firstWhere((e) => e.weekday == DateTime.monday));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildMetaEditor(context),
    );
  }

  Widget _wrap(Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: widget,
    );
  }

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          _wrap(TextFormField(
            controller: _nameController,
            maxLines: 1,
            decoration:
                InputDecoration(labelText: i18n.timetableNameFormTitle, border: const OutlineInputBorder()),
          )),
          _wrap(TextFormField(
            controller: _descController,
            maxLines: 2,
            decoration:
                InputDecoration(labelText: i18n.timetableDescFormTitle, border: const OutlineInputBorder()),
          )),
        ]));
  }

  Widget buildMetaEditor(BuildContext ctx) {
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(i18n.timetableImportInfoTitle, style: ctx.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          buildDescForm(ctx),
          ValueListenableBuilder(
              valueListenable: _selectedDate,
              builder: (ctx, value, child) {
                return Text(i18n.timetableImportStartDate(ctx.dateNum(value)));
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ctx, i18n.timetableImportSaveBtn, onPressed: () {
                final meta = widget.meta;
                meta.name = _nameController.text;
                meta.description = _descController.text;
                meta.startDate = _selectedDate.value;
                Navigator.of(ctx).pop(true);
              }),
              buildButton(ctx, i18n.timetableSetStartDate, onPressed: () async {
                final date = await pickDate(context, initial: _selectedDate.value);
                if (date != null) {
                  _selectedDate.value = DateTime(date.year, date.month, date.day, 8, 20);
                }
              })
            ],
          ).vwrap()
        ],
      ),
    );
  }
}
