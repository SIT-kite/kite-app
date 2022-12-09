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
import 'package:kite/module/symbol.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import '../user_widget/picker.dart';
import '../user_widget/timetable_editor.dart';
import 'preview.dart';

class MyTimetablePage extends StatefulWidget {
  const MyTimetablePage({Key? key}) : super(key: key);

  @override
  State<MyTimetablePage> createState() => _MyTimetablePageState();
}

class _MyTimetablePageState extends State<MyTimetablePage> {
  final storage = TimetableInit.timetableStorage;

  Future<void> goImport() async {
    final changed = await Navigator.of(context).push(
      (MaterialPageRoute(builder: (_) => const ImportTimetableIndexPage())),
    );
    if (changed == true) {
      setState(() {});
    }
  }

  bool get canImport {
    return Kv.auth.currentUsername != null && Kv.auth.ssoPassword != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.timetableMineTitle.text(),
      ),
      floatingActionButton: canImport
          ? FloatingActionButton(
              onPressed: goImport,
              elevation: 10,
              child: const Icon(Icons.add_outlined),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: buildTimetables(context),
      ),
    );
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return LeavingBlank(icon: Icons.calendar_month_rounded, desc: i18n.timetableMineEmptyTip, onIconTap: goImport);
  }

  Widget buildTimetables(BuildContext ctx) {
    final tableNames = storage.tableNames ?? [];
    if (tableNames.isEmpty) {
      return _buildEmptyBody(ctx);
    }
    final currentTableName = storage.currentTableName;
    return ListView(
        children: tableNames.map((e) {
      final meta = storage.getTableMetaByName(e);
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
          trailingIcon: CupertinoIcons.doc_text,
          onPressed: () async {
            Navigator.of(ctx).pop();
            final changed = await ctx
                .showSheet((context) => TimetableEditor(meta: meta).padOnly(b: MediaQuery.of(ctx).viewInsets.bottom));

            if (changed == true) {
              setState(() {});
            }
          },
          child: i18n.timetableEdit.text(),
        ),
        if (storage.currentTableName != meta.name)
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.checkmark,
            onPressed: () {
              Navigator.of(ctx).pop();
              storage.currentTableName = meta.name;
              setState(() {});
            },
            child: i18n.timetableSetToDefault.text(),
          ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.time,
          onPressed: () async {
            Navigator.of(ctx).pop();
            final date = await pickDate(context, initial: meta.startDate);
            if (date != null) {
              meta.startDate = DateTime(date.year, date.month, date.day, 8, 20);
              storage.addTableMeta(meta.name, meta);
            }
          },
          child: i18n.timetableSetStartDate.text(),
        ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.eye,
          onPressed: () async {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).push(MaterialPageRoute(
                builder: (ctx) =>
                    TimetablePreviewPage(meta: meta, courses: storage.getTableCourseByName(meta.name) ?? [])));
          },
          child: i18n.timetablePreviewBtn.text(),
        ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.delete,
          onPressed: () async {
            Navigator.of(ctx).pop();
            // Have to wait until the animation has been suspended because flutter is buggy without check `mounted` in _CupertinoContextMenuState.
            await showDeleteTimetableRequest(ctx, meta);
          },
          isDestructiveAction: true,
          child: i18n.timetableDelete.text(),
        ),
      ],
      child: buildTimetableItemCard(ctx, meta, isSelected: isSelected),
      previewBuilder: (ctx, animation, child) => buildTimetableItemCardPreview(ctx, meta, isSelected: isSelected),
    );
  }

  Widget buildTimetableItemCard(BuildContext ctx, TimetableMeta meta, {required bool isSelected}) {
    final bodyTextStyle = ctx.textTheme.titleSmall;
    return [
      [
        meta.name.text(style: ctx.textTheme.titleMedium).expanded(),
        if (isSelected) const Icon(Icons.check, color: Colors.green)
      ].row(maa: MainAxisAlignment.spaceBetween),
      if (meta.description.isNotEmpty)
        [
          const Icon(CupertinoIcons.doc_text),
          meta.description.text(style: bodyTextStyle).padAll(10).expanded(),
        ].row(maa: MainAxisAlignment.spaceBetween)
    ].column().scrolled().padAll(20).inCard(elevation: 5);
  }

  Widget buildTimetableItemCardPreview(BuildContext ctx, TimetableMeta meta, {required bool isSelected}) {
    final year = '${meta.schoolYear} - ${meta.schoolYear + 1}';
    final semesterNames = makeSemesterL10nName();
    final semester = semesterNames[Semester.values[meta.semester]] ?? "";
    final bodyTextStyle = ctx.textTheme.titleSmall;
    return [
      [
        [
          meta.name.text(style: ctx.textTheme.titleMedium).expanded(),
          if (isSelected) const Icon(Icons.check, color: Colors.green),
        ].row(maa: MainAxisAlignment.spaceBetween),
        [
          year.text(style: bodyTextStyle),
          semester.text(style: bodyTextStyle),
        ].row(maa: MainAxisAlignment.spaceEvenly).padV(5),
      ].column().padSymmetric(v: 10, h: 20).inCard(elevation: 8),
      [
        const Icon(CupertinoIcons.doc_text),
        if (meta.description.isNotEmpty)
          meta.description.text(style: bodyTextStyle).padAll(10).expanded()
        else
          i18n.timetableNoDescPlaceholder
              .text(style: bodyTextStyle?.copyWith(fontStyle: FontStyle.italic))
              .padAll(10)
              .expanded(),
      ].row(maa: MainAxisAlignment.spaceBetween).padAll(10),
      i18n.timetableImportStartDate(ctx.dateNum(meta.startDate)).text(style: bodyTextStyle).padFromLTRB(20, 20, 20, 10),
    ].column().scrolled().padAll(4).inCard(elevation: 5);
  }

  Future<void> showDeleteTimetableRequest(BuildContext ctx, TimetableMeta meta) async {
    final confirm = await ctx.showRequest(
        title: i18n.timetableDeleteRequest,
        desc: i18n.timetableDeleteRequestDesc,
        yes: i18n.delete,
        no: i18n.cancel,
        highlight: true);
    if (confirm == true) {
      storage.removeTable(meta.name);
      if (storage.hasAnyTimetable) {
        // Refresh Mine page and show other timetables
        if (mounted) setState(() {});
      } else {
        // Otherwise, go out
        ctx.navigator.pop();
      }
    }
  }
}
