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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/design/user_widgets/dialog.dart';
import 'package:kite/module/symbol.dart';
import 'package:rettulf/rettulf.dart';

import '../../activity/using.dart';
import '../user_widget/picker.dart';
import '../user_widget/timetable_editor.dart';
import 'preview.dart';

class MyTimetablePage extends StatefulWidget {
  const MyTimetablePage({Key? key}) : super(key: key);

  @override
  State<MyTimetablePage> createState() => _MyTimetablePageState();
}

class _MyTimetablePageState extends State<MyTimetablePage> {
  final timetableStorage = TimetableInit.timetableStorage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.timetableMineTitle.txt,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed =
              await Navigator.of(context).push((MaterialPageRoute(builder: (_) => const ImportTimetablePage())));
          if (changed == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: buildTimetables(context),
      ),
    );
  }

  Widget buildTimetables(BuildContext ctx) {
    final tableNames = timetableStorage.tableNames ?? [];
    if (tableNames.isEmpty) {
      return _buildEmptyBody(ctx);
    }
    final currentTableName = timetableStorage.currentTableName;
    return ListView(
        children: tableNames.map((e) {
      final meta = timetableStorage.getTableMetaByName(e);
      if (meta == null) {
        return const SizedBox();
      } else {
        return buildTimetableEntry(ctx, meta, isSelected: currentTableName == meta.name);
      }
    }).toList());
  }

  Widget buildTimetableEntry(BuildContext ctx, TimetableMeta meta, {required bool isSelected}) {
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () async {
            Navigator.of(ctx).pop();
            final changed = await showModalBottomSheet(
                context: ctx,
                isScrollControlled: true,
                shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48))),
                builder: (ctx) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                      child: TimetableEditor(meta: meta));
                });
            if (changed == true) {
              setState(() {});
            }
          },
          trailingIcon: CupertinoIcons.doc_text,
          child: i18n.timetableEdit.txt,
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(ctx).pop();
            timetableStorage.currentTableName = meta.name;
            setState(() {});
          },
          trailingIcon: CupertinoIcons.checkmark,
          child: i18n.timetableSetToDefault.txt,
        ),
        CupertinoContextMenuAction(
          onPressed: () async {
            Navigator.of(ctx).pop();
            final date = await pickDate(context, initial: meta.startDate);
            if (date != null) {
              meta.startDate = DateTime(date.year, date.month, date.day, 8, 20);
              timetableStorage.addTableMeta(meta.name, meta);
            }
          },
          trailingIcon: CupertinoIcons.time,
          child: i18n.timetableSetStartDate.txt,
        ),
        CupertinoContextMenuAction(
          onPressed: () async {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).push(MaterialPageRoute(
                builder: (ctx) =>
                    TimetablePreviewPage(meta: meta, courses: timetableStorage.getTableCourseByName(meta.name) ?? [])));
          },
          trailingIcon: CupertinoIcons.eye,
          child: i18n.timetablePreviewBtn.txt,
        ),
        CupertinoContextMenuAction(
          onPressed: () async {
            Navigator.of(ctx).pop();
            // Have to wait until the aniamtion has been suspended because flutter is buggy without check `mounted` in _CupertinoContextMenuState.
            await showDeleteTimetableRequest(ctx, meta);
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: i18n.timetableDelete.txt,
        ),
      ],
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      child: Text(
                    meta.name,
                    style: ctx.textTheme.titleMedium,
                  )),
                  if (isSelected) const Icon(Icons.check, color: Colors.green)
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      child: Text(
                    meta.description,
                  )),
                ])
              ],
            ))),
      ),
    );
  }

  Future<void> showDeleteTimetableRequest(BuildContext ctx, TimetableMeta meta) async {
    final confirm = await ctx.showRequest(
        title: i18n.timetableDeleteRequest,
        desc: i18n.timetableDeleteRequestDesc,
        yes: i18n.delete,
        no: i18n.cancel,
        highlight: true);
    if (confirm) {
      timetableStorage.removeTable(meta.name);
      if (mounted) setState(() {});
    }
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return [
      const Icon(Icons.calendar_month_rounded, size: 120).padAll(20),
      i18n.timetableMineEmptyTip.text(
        style: ctx.theme.textTheme.titleLarge,
      ),
    ].column(maa: MAAlign.spaceAround).center();
  }
}
