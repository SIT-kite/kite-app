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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/domain/edu/init.dart';
import 'package:kite/domain/edu/entity/index.dart';
import 'package:kite/util/edu/selector.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  static final dateFormat = DateFormat('MM月dd日 HH:mm');

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;

    super.initState();
  }

  Widget _buildItem(BuildContext context, String icon, String text) {
    final itemStyle = Theme.of(context).textTheme.headline5;
    final iconImage = AssetImage('assets/' + icon);
    return Row(
      children: [
        icon.isEmpty ? const SizedBox(height: 35, width: 35) : Image(image: iconImage, width: 35, height: 35),
        Container(width: 8),
        Expanded(child: Text(text, softWrap: true, style: itemStyle))
      ],
    );
  }

  Widget buildExamItem(BuildContext context, ExamRoom examItem) {
    final itemStyle = Theme.of(context).textTheme.bodyText2;
    final name = examItem.courseName;
    final startTime = examItem.time[0];
    final endTime = examItem.time[1];
    final place = examItem.place;
    final seatNumber = examItem.seatNumber;
    final isRebuild = examItem.isRebuild;

    TableRow buildRow(String icon, String title, String content) {
      return TableRow(children: [
        _buildItem(context, icon, title),
        Text(content, style: itemStyle),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.headline1),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(8),
            1: FlexColumnWidth(10),
          },
          children: [
            buildRow('timetable/campus.png', '考试地点', place),
            buildRow('timetable/courseId.png', '座位号', '$seatNumber'),
            buildRow('timetable/day.png', '开始时间', dateFormat.format(startTime)),
            buildRow('timetable/day.png', '结束时间', dateFormat.format(endTime)),
            buildRow('', '是否重修', isRebuild),
          ],
        )
      ],
    );
  }

  Widget buildExamItems(BuildContext context, List<ExamRoom> examItems) {
    return ListView(
      children: examItems
          .map(
            (e) => Card(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: buildExamItem(context, e),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildBody(BuildContext context) {
    return MyFutureBuilder<List<ExamRoom>>(
      future: EduInitializer.exam.getExamList(
        SchoolYear(selectedYear),
        selectedSemester,
      ),
      builder: (context, data) {
        data.sort((a, b) {
          return a.time[0].isAfter(b.time[0]) ? 1 : -1;
        });
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: SemesterSelector(
                (year) {
                  setState(() => selectedYear = year);
                },
                (semester) {
                  setState(() => selectedSemester = semester);
                },
                initialYear: selectedYear,
                initialSemester: selectedSemester,
                showEntireYear: false,
              ),
            ),
            Expanded(child: buildExamItems(context, data)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考试安排')),
      body: buildBody(context),
    );
  }
}
