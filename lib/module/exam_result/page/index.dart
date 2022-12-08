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
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import '../init.dart';
import '../using.dart';
import 'banner.dart';
import 'item.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  /// 成绩列表
  List<Score>? scoreList;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = Semester.all;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      scoreList = await ExamResultInit.scoreService.getScoreList(SchoolYear(selectedYear), selectedSemester);
      setState(() {});
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: SemesterSelector(
            onNewYearSelect: (year) {
              setState(() => selectedYear = year);
            },
            onNewSemesterSelect: (semester) {
              setState(() => selectedSemester = semester);
            },
            initialYear: selectedYear,
            initialSemester: selectedSemester,
          ),
        ),
        GpaBanner(selectedSemester, scoreList!),
      ],
    );
  }

  Widget _buildListView() {
    return ListView(
      children: scoreList!
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_examResult.text(),
      ),
      body: scoreList == null
          ? Placeholders.loading()
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: scoreList!.isNotEmpty ? _buildListView() : _buildNoResult()),
              ],
            ),
    );
  }
}
