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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../entity/meta.dart';
import '../init.dart';
import '../using.dart';
import 'preview.dart';

const _semesterDescription = {
  Semester.all: '全学年',
  Semester.firstTerm: '第一学期',
  Semester.secondTerm: '第二学期',
};

class TimetableImportDialog extends StatefulWidget {
  final DateTime? defaultStartDate;

  const TimetableImportDialog({Key? key, this.defaultStartDate}) : super(key: key);

  @override
  State<TimetableImportDialog> createState() => _TimetableImportDialogState();
}

class _TimetableImportDialogState extends State<TimetableImportDialog> {
  final timetableService = TimetableInit.timetableService;
  final timetableStorage = TimetableInit.timetableStorage;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  // 如果没指定默认起始日期，那么走默认日期计算逻辑
  late ValueNotifier<DateTime> selectedDate = ValueNotifier(
    widget.defaultStartDate != null
        ? widget.defaultStartDate!
        : Iterable.generate(7, (i) {
            return DateTime.now().add(Duration(days: i));
          }).firstWhere((e) => e.weekday == DateTime.monday),
  );

  final tableNameController = TextEditingController();
  final tableDescriptionController = TextEditingController();

  @override
  void initState() {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, 8, 20);

    // 先根据当前时间估算出是哪个学期
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;
    _updateTableName();
    super.initState();
  }

  Widget _buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
        yearSelectCallback: (year) {
          setState(() => selectedYear = year);
          _updateTableName();
        },
        semesterSelectCallback: (semester) {
          setState(() => selectedSemester = semester);
          _updateTableName();
        },
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
        showNextYear: true,
      ),
    );
  }

  void _updateTableName() {
    final year = selectedYear;
    final semester = selectedSemester;
    tableNameController.text = '$year - ${year + 1} 学年 ${_semesterDescription[semester]} 课表';
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('导入学期'), _buildSemesterSelector()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('起始日期'),
            TextButton(
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDate,
                builder: (context, value, child) {
                  return Text('${value.year} 年 ${value.month} 月 ${value.day} 日');
                },
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  currentDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 2),
                  selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
                );
                if (date != null) selectedDate.value = DateTime(date.year, date.month, date.day, 8, 20);
              },
            ),
          ],
        ),
        Form(
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: tableNameController,
                decoration: const InputDecoration(labelText: '课表名称'),
              ),
              TextFormField(
                autofocus: true,
                controller: tableDescriptionController,
                decoration: const InputDecoration(labelText: '课表备注'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // 关闭用户交互
                EasyLoading.instance.userInteractions = false;
                EasyLoading.show(status: '正在导入', dismissOnTap: false);
                try {
                  final value = await _fetchTimetable();
                  if (!mounted) return;
                  Navigator.of(context).pop(value);
                } catch (e) {
                  EasyLoading.showError('导入失败');
                  rethrow;
                } finally {
                  // 关闭对话框
                  EasyLoading.dismiss();
                  // 允许用户交互
                  EasyLoading.instance.userInteractions = true;
                }
              },
              child: const Text('导入课表'),
            ),
            SizedBox(width: 10.w),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消导入'),
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> _fetchTimetable() async {
    final year = selectedYear;
    final semester = selectedSemester;

    final tableCourse = await timetableService.getTimetable(SchoolYear(year), semester);
    final tableMeta = TimetableMeta()
      ..name = tableNameController.text
      ..startDate = selectedDate.value
      ..schoolYear = year
      ..semester = semester.index
      ..description = '无';
    return [tableMeta, tableCourse];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: _buildBody(),
      ),
    );
  }
}

class TimetableImportPage extends StatefulWidget {
  const TimetableImportPage({Key? key}) : super(key: key);

  @override
  State<TimetableImportPage> createState() => _TimetableImportPageState();
}

class _TimetableImportPageState extends State<TimetableImportPage> {
  final timetableStorage = TimetableInit.timetableStorage;
  final kiteTimetableService = TimetableInit.kiteTimetableService;

  DateTime? defaultStartDate;

  @override
  void initState() {
    // 静默赋值(忽略异常信息)
    kiteTimetableService.getSemesterDefaultStartDate().then((value) => defaultStartDate = value).ignore();
    super.initState();
  }

  Widget _buildTableMetaInfo(TimetableMeta meta) {
    final startDateNotifier = ValueNotifier(meta.startDate);

    final descriptionController = TextEditingController();
    descriptionController.text = meta.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('课表名称：${meta.name}'),
        Row(
          children: [
            const Text('课表描述：'),
            Expanded(
              child: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.save, semanticLabel: '保存修改'),
                    onPressed: () {
                      meta.description = descriptionController.text;
                      timetableStorage.addTableMeta(meta.name, meta);
                      EasyLoading.showSuccess('课表描述保存成功');
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Text('课表学年：${meta.schoolYear} - ${meta.schoolYear + 1} 学年'),
        Text('课表学期：${_semesterDescription[Semester.values[meta.semester]]}'),
        Row(
          children: [
            const Text('起始日期：'),
            TextButton(
              child: ValueListenableBuilder<DateTime>(
                valueListenable: startDateNotifier,
                builder: (context, value, child) {
                  return Text('${value.year} 年 ${value.month} 月 ${value.day} 日');
                },
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: startDateNotifier.value,
                  currentDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 2),
                  selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
                );
                if (date != null) {
                  startDateNotifier.value = DateTime(date.year, date.month, date.day, 8, 20);
                  meta.startDate = startDateNotifier.value;
                  timetableStorage.addTableMeta(meta.name, meta);
                  EasyLoading.showSuccess('课表起始日期已修改');
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void showTimetableInfoDialog(TimetableMeta meta) {
    showAlertDialog(
      context,
      title: '课表信息',
      content: [
        _buildTableMetaInfo(meta),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
          child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return TimetablePreviewPage(
                    meta: meta,
                    courses: timetableStorage.getTableCourseByName(meta.name)!,
                  );
                }));
              },
              child: const Text('预览课表')),
        ),
      ],
      actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: const Text('设为默认课表')),
        SizedBox(width: 10.w),
        ElevatedButton(onPressed: () {}, child: const Text('删除课表')),
      ],
    ).then((idx) {
      if (idx == null) return;
      [
        () => timetableStorage.currentTableName = meta.name,
        () => {},
        () => timetableStorage.removeTable(meta.name),
      ][idx]();
      setState(() {});
    });
  }

  Widget _buildTableNameListView(List<String> names) {
    final currentTableName = timetableStorage.currentTableName;
    return ListView(
      children: names
          .map((e) {
            final meta = timetableStorage.getTableMetaByName(e)!;
            return ListTile(
              title: Text(e),
              subtitle: ['', '无'].contains(meta.description) ? null : Text(meta.description),
              trailing: e == currentTableName ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () => showTimetableInfoDialog(meta),
            );
          })
          .map(
            (e) => Column(
              children: [e, const Divider()],
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody() {
    final tableNames = timetableStorage.tableNames ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('当前已导入的课表数：${tableNames.length}'),
        Expanded(
          child: _buildTableNameListView(tableNames),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入课表'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TimetableImportDialog(
                defaultStartDate: defaultStartDate,
              );
            },
          ).then((value) {
            if (value == null) return;
            timetableStorage.addTable(value[0], value[1]);
            final TimetableMeta meta = value[0];
            timetableStorage.currentTableName = meta.name;
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildBody(),
      ),
    );
  }
}
