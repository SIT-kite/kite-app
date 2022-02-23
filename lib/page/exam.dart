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
import 'package:kite/component/future_builder.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/service_pool.dart';

class ExamTimePage extends StatelessWidget {
  const ExamTimePage({Key? key}) : super(key: key);

  Widget buildExamItem(ExamRoom examItem) {
    final name = examItem.courseName;
    final startTime = examItem.time[0];
    final endTime = examItem.time[1];
    final place = examItem.place;
    final campus = examItem.campus;
    final seatNumber = examItem.seatNumber;
    final isRebuild = examItem.isRebuild;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('课程名称: $name'),
        Text('考试地点: $campus  $place'),
        Text('座位号: $seatNumber'),
        Text('开始时间: $startTime'),
        Text('结束时间: $endTime'),
        Text('是否重修: $isRebuild'),
      ],
    );
  }

  Widget buildExamItems(List<ExamRoom> examItems) {
    return ListView(
      children: examItems
          .map(
            (e) => Card(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: buildExamItem(e),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('考试安排')),
        body: MyFutureBuilder<List<ExamRoom>>(
          future: ServicePool.exam.getExamList(
            const SchoolYear(2021),
            Semester.firstTerm,
          ),
          builder: (context, data) {
            data.sort((a, b) {
              return a.time[0].isAfter(b.time[0]) ? 1 : -1;
            });
            return buildExamItems(data);
          },
        ));
  }
}
