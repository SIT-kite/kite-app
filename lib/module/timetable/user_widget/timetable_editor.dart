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
import 'package:kite/module/symbol.dart';
import 'package:rettulf/rettulf.dart';

import 'button.dart';
import '../using.dart';

class TimetableEditor extends StatefulWidget {
  final TimetableMeta meta;
  final DateTime? defaultStartDate;

  const TimetableEditor({super.key, required this.meta, this.defaultStartDate});

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  late TextEditingController _metaDescController;

  @override
  void initState() {
    super.initState();
    _metaDescController = TextEditingController(text: widget.meta.description);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildTimetableEditor(context),
    );
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _metaDescController,
            maxLines: 2,
            decoration: InputDecoration(labelText: i18n.timetableDescFormTitile, border: const OutlineInputBorder()),
          )
        ]));
  }

  Widget buildTimetableEditor(BuildContext ctx) {
    final year = '${widget.meta.schoolYear} - ${widget.meta.schoolYear + 1}';
    final semesterNames = makeSemesterL10nName();
    final semster = semesterNames[Semester.values[widget.meta.semester]] ?? "";
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(widget.meta.name, style: ctx.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Text(year),
                  Text(semster),
                  Text(i18n.timetableImportStartDate(ctx.dateNum(widget.meta.startDate))),
                ]),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: buildDescForm(ctx)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ctx, i18n.timetableImportSaveBtn, onPressed: () {
                widget.meta.description = _metaDescController.text;
                Navigator.of(ctx).pop(true);
              }),
            ],
          ).vwrap()
        ],
      ),
    );
  }
}
