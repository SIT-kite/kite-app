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

import '../../entity/course.dart';
import '../../entity/meta.dart';
import '../../init.dart';
import '../../user_widget/meta_editor.dart';
import '../../using.dart';

enum ImportStatus {
  none,
  importing,
  end,
  failed;

  String get tipString {
    switch (this) {
      case ImportStatus.none:
        return i18n.timetableSelectSemesterTip;
      case ImportStatus.importing:
        return i18n.timetableImportImporting;
      case ImportStatus.end:
        return i18n.timetableImportEndTip;
      default:
        return i18n.timetableImportFailedTip;
    }
  }
}

class ImportTimetablePage extends StatefulWidget {
  final DateTime? defaultStartDate;

  const ImportTimetablePage({super.key, this.defaultStartDate});

  @override
  State<ImportTimetablePage> createState() => _ImportTimetablePageState();
}

class _ImportTimetablePageState extends State<ImportTimetablePage> {
  final service = TimetableInit.timetableService;
  final storage = TimetableInit.timetableStorage;

  // 当前课表导入状态
  late ImportStatus _status;
  // 被选择的学年
  late int _selectedYear;
  // 被选择的学期
  late Semester _selectedSemester;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 8, 20);
    // 先根据当前时间估算出是哪个学期
    _selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    _selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;
    _status = ImportStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    return buildImportPage(context).padFromLTRB(12, 0, 12, 12);
  }

  Widget buildTip(BuildContext ctx) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.fastLinearToSlowEaseIn,
      switchOutCurve: Curves.fastLinearToSlowEaseIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        _status.tipString,
        key: ValueKey(_status),
        style: ctx.textTheme.titleLarge,
      ),
    );
  }

  Widget buildImportPage(BuildContext ctx) {
    final isImporting = _status == ImportStatus.importing;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          margin: isImporting ? const EdgeInsets.all(60) : EdgeInsets.zero,
          width: isImporting ? 120.0 : 0.0,
          height: isImporting ? 120.0 : 0.0,
          alignment: isImporting ? Alignment.center : AlignmentDirectional.topCenter,
          duration: const Duration(seconds: 2),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Placeholders.loading(
            size: 120,
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: buildTip(ctx)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SemesterSelector(
            onNewYearSelect: (year) {
              setState(() => _selectedYear = year);
            },
            onNewSemesterSelect: (semester) {
              setState(() => _selectedSemester = semester);
            },
            initialYear: _selectedYear,
            initialSemester: _selectedSemester,
            showEntireYear: false,
            showNextYear: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: buildImportButton(ctx),
        )
      ],
    );
  }

  // 持久化课表数据
  Future<bool> handleTimetableData(BuildContext ctx, List<Course> courses, int year, Semester semester) async {
    final meta = TimetableMeta()
      ..name = i18n.timetableInfoDefaultName(semester.localized(), year, year + 1)
      ..schoolYear = year
      ..semester = semester.index;
    final saved = await ctx.showSheet((ctx) {
      return MetaEditor(meta: meta).padOnly(b: MediaQuery.of(ctx).viewInsets.bottom);
    });
    if (saved) {
      storage.addTable(meta, courses);
      return true;
    }
    return false;
  }

  Widget buildImportButton(BuildContext ctx) {
    final isImporting = _status == ImportStatus.importing;
    return ElevatedButton(
      onPressed: _status == ImportStatus.importing
          ? null
          : () async {
              if (!mounted) return;
              setState(() => isImporting);
              try {
                final semester = _selectedSemester;
                final year = SchoolYear(_selectedYear);
                final timetable = await service.getTimetable(year, semester);
                setState(() => _status = ImportStatus.end);
                if (!mounted) return;
                final saved = await handleTimetableData(ctx, timetable, _selectedYear, semester);
                if (mounted) Navigator.of(ctx).pop(saved);
                setState(() {
                  _status = ImportStatus.none;
                });
              } catch (e) {
                setState(() {
                  _status = ImportStatus.failed;
                });
                if (!mounted) return;
                await context.showTip(
                  title: i18n.timetableImportFailed,
                  desc: i18n.timetableImportFailedDesc,
                  ok: i18n.ok,
                );
              } finally {
                if (isImporting) {
                  setState(() {
                    _status = ImportStatus.end;
                  });
                }
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          i18n.timetableImportImportBtn,
          style: ctx.textTheme.titleLarge,
        ),
      ),
    );
  }
}
