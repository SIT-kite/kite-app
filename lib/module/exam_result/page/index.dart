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
import 'package:flutter_svg/svg.dart';
import 'package:kite/module/library/using.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/result.dart';
import '../init.dart';
import '../using.dart';
import '../util.dart';
import 'item.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({super.key});

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  /// 成绩列表
  List<ExamResult>? _allResults;
  List<ExamResult>? _selectedExams;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = Semester.all;
    onRefresh();
  }

  void onRefresh() {
    if (!mounted) return;
    setState(() {
      _allResults = null;
    });
    ExamResultInit.resultService.getResultList(SchoolYear(selectedYear), selectedSemester).then((value) {
      if (!mounted) return;
      setState(() {
        _allResults = value;
        _selectedExams = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Auth.hasLoggedIn) return UnauthorizedTipPage(title: i18n.ftype_examArr.text());
    final selectedExams = _selectedExams;
    final String title;
    if (selectedExams != null) {
      var gpa = calcGPA(selectedExams);
      if (gpa.isNaN) {
        gpa = 0;
      }
      title = i18n.gpaPointLabel(selectedSemester.localized(), gpa.toStringAsPrecision(2));
    } else {
      title = i18n.ftype_examResult;
    }

    return Scaffold(
      appBar: AppBar(
        title: title.text(),
        centerTitle: true,
      ),
      body: _allResults == null
          ? Placeholders.loading()
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _allResults!.isNotEmpty ? _buildListView() : _buildNoResult()),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.assessment_outlined),
        onPressed: () => Navigator.of(context).pushNamed(RouteTable.examResultEvaluation),
        label: const Text('评教'),
      ),
    );
  }

  Widget _buildHeader() {
    return [
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: SemesterSelector(
          onNewYearSelect: (year) {
            setState(() => selectedYear = year);
            onRefresh();
          },
          onNewSemesterSelect: (semester) {
            setState(() => selectedSemester = semester);
            onRefresh();
          },
          initialYear: selectedYear,
          initialSemester: selectedSemester,
        ),
      ),
    ].column();
  }

  Widget _buildListView() {
    return ListView(
      children: _allResults!
          .map(
            (e) => Column(
              children: [
                ScoreItem(e),
                Divider(
                  height: 2.0,
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildNoResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/common/not-found.svg',
          width: 260,
          height: 260,
        ),
        Text(i18n.examResultNoResult, style: const TextStyle(color: Colors.grey)),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            i18n.examResultBePatientLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
