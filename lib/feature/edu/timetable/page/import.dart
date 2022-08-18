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
import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/util/selector.dart';

import '../entity.dart';
import '../init.dart';

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

  @override
  void initState() {
    final DateTime now = DateTime.now();
    // 先根据当前时间估算出是哪个学期
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;

    super.initState();
  }

  Widget _buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
        yearSelectCallback: (year) {
          setState(() => selectedYear = year);
        },
        semesterSelectCallback: (semester) {
          setState(() => selectedSemester = semester);
        },
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
        showNextYear: true,
      ),
    );
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
                decoration: const InputDecoration(labelText: '课表名称'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> _fetchTimetable() async {
    const semesterDescription = {
      Semester.all: '全学年',
      Semester.firstTerm: '第一学期',
      Semester.secondTerm: '第二学期',
    };

    final year = selectedYear;
    final semester = selectedSemester;

    final tableCourse = await timetableService.getTimetable(SchoolYear(year), semester);
    final tableMeta = TimetableMeta()
      ..name = '$year - ${year + 1} 学年 ${semesterDescription[semester]}'
      ..startDate = selectedDate.value
      ..schoolYear = year
      ..semester = semester.index
      ..description = '无';
    return [tableCourse, tableMeta];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _buildBody(),
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

  Widget _buildTableNameListView(List<String> names) {
    return ListView(
      children: names.map((e) {
        return ListTile(
          title: Text(e),
          onTap: () {
            // 对话框？
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
          );
          setState(() {});
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
