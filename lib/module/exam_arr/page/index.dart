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

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/exam.dart';
import '../init.dart';
import '../user_widget/exam.dart';
import '../using.dart';

class ExamArrangementPage extends StatefulWidget {
  const ExamArrangementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamArrangementPageState();
}

class _ExamArrangementPageState extends State<ExamArrangementPage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;
  List<ExamEntry>? _exams;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: i18n.ftype_examArr.text()),
        body: [
          buildSemesterSelector(),
          buildExamEntries(context).expanded(),
        ].column());
  }

  void refresh() {
    ExamArrInit.examService
        .getExamList(
      SchoolYear(selectedYear),
      selectedSemester,
    )
        .then((value) {
      value.sort(ExamEntry.comparator);
      setState(() {
        _exams = value;
      });
    });
  }

  Widget buildExamEntries(BuildContext ctx) {
    final exams = _exams;
    if (exams == null) {
      return Placeholders.loading();
    }
    if (exams.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/common/not-found.svg',
            width: 260,
            height: 260,
          ).flexible(flex: 3),
          Text(i18n.examNoExamThisSemester, style: const TextStyle(color: Colors.grey)).flexible(flex: 1),
        ],
      );
    } else {
      return LayoutBuilder(builder: (ctx, constraints) {
        final count = constraints.maxWidth ~/ 300;
        return LiveGrid(
          itemCount: exams.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            childAspectRatio: 1.55,
          ),
          showItemInterval: const Duration(milliseconds: 40),
          itemBuilder: (ctx, index, animation) => ExamCard(exam: exams[index])
              .padSymmetric(v: 8, h: 16)
              .inCard(elevation: 5)
              .padAll(8)
              .aliveWith(animation),
        );
      });
    }
  }

  Widget buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
        onNewYearSelect: (year) {
          setState(() {
            selectedYear = year;
            refresh();
          });
        },
        onNewSemesterSelect: (semester) {
          setState(() {
            selectedSemester = semester;
            refresh();
          });
        },
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
      ),
    );
  }
}
