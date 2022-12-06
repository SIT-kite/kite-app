
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
import 'package:kite/module/exam_arr/entity/exam.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

class ExamCard extends StatefulWidget {
  final ExamEntry exam;

  const ExamCard({super.key, required this.exam});

  @override
  State<ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  ExamEntry get exam => widget.exam;

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyText2;
    final name = stylizeCourseName(exam.courseName);
    final strStartTime = exam.time.isNotEmpty ? dateFullNum(exam.time[0]) : '/';
    final strEndTime = exam.time.isNotEmpty ? dateFullNum(exam.time[1]) : '/';
    final place = stylizeCourseName(exam.place);
    final seatNumber = exam.seatNumber;
    final isSecondExam = exam.isSecondExam;

    TableRow buildRow(String icon, String title, String content) {
      return TableRow(children: [
        _buildItem(icon, title),
        Text(content, style: itemStyle),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.headline6).padAll(12),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(5)},
          children: [
            buildRow('timetable/campus.png', i18n.examLocation, place),
            buildRow('timetable/courseId.png', i18n.examSeatNumber, '$seatNumber'),
            buildRow('timetable/day.png', i18n.examStartTime, strStartTime),
            buildRow('timetable/day.png', i18n.examEndTime, strEndTime),
            buildRow('', i18n.examIsRetake, isSecondExam),
          ],
        )
      ],
    );
  }

  Widget _buildItem(String icon, String text) {
    final itemStyle = Theme.of(context).textTheme.bodyText1;
    final iconImage = AssetImage('assets/$icon');
    return Row(
      children: [
        icon.isEmpty ? const SizedBox(height: 24, width: 24) : Image(image: iconImage, width: 24, height: 24),
        const SizedBox(width: 8, height: 32),
        Expanded(child: Text(text, softWrap: true, style: itemStyle))
      ],
    );
  }
}
