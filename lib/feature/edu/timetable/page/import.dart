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

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/timetable/page/preview.dart';
import 'package:kite/feature/edu/util/selector.dart';
import 'package:kite/util/alert_dialog.dart';

import '../entity.dart';
import '../init.dart';

const _semesterDescription = {
  Semester.all: '全学年',
  Semester.firstTerm: '第一学期',
  Semester.secondTerm: '第二学期',
};

class TimetableImportDialog extends StatefulWidget {
  const TimetableImportDialog({Key? key}) : super(key: key);

  @override
  State<TimetableImportDialog> createState() => _TimetableImportDialogState();
}

class _TimetableImportDialogState extends State<TimetableImportDialog> {
  final timetableService = TimetableInitializer.timetableService;
  final timetableStorage = TimetableInitializer.timetableStorage;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  final tableNameController = TextEditingController();
  final tableDescriptionController = TextEditingController();

  @override
  void initState() {
    final DateTime now = DateTime.now();
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
                if (date != null) selectedDate.value = date;
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
              onPressed: () {
                // 关闭用户交互
                EasyLoading.instance.userInteractions = false;
                EasyLoading.show(status: '正在导入', dismissOnTap: false);
                _fetchTimetable().then((value) {
                  Navigator.of(context).pop(value);
                }).onError((e, t) {
                  EasyLoading.showError('导入失败\n$e');
                  Catcher.reportCheckedError(e, t);
                }).whenComplete(() {
                  // 关闭对话框
                  EasyLoading.dismiss();
                  // 允许用户交互
                  EasyLoading.instance.userInteractions = true;
                });
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
  final timetableStorage = TimetableInitializer.timetableStorage;

  Widget _buildTableMetaInfo(TimetableMeta meta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('课表名称：${meta.name}'),
        Text('课表描述：${meta.description}'),
        Text('课表学年：${meta.schoolYear} - ${meta.schoolYear + 1} 学年'),
        Text('课表学期：${_semesterDescription[Semester.values[meta.semester]]}'),
        Text('开始时间：${DateFormat('yyyy-MM-dd').format(meta.startDate)}'),
      ],
    );
  }

  Widget _buildTableNameListView(List<String> names) {
    final currentTableName = timetableStorage.currentTableName;
    return ListView(
      children: names.map((e) {
        final meta = timetableStorage.getTableMetaByName(e);
        return ListTile(
          title: Text(e),
          trailing: e == currentTableName ? const Icon(Icons.check, color: Colors.green) : null,
          onTap: () {
            showAlertDialog(
              context,
              title: '课表信息',
              content: [
                _buildTableMetaInfo(meta!),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                          return TimetablePreviewPage(
                            meta: meta,
                            courses: timetableStorage.getTableCourseByName(e)!,
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
          },
        );
      }).toList(),
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
              return const TimetableImportDialog();
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
