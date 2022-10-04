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
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/dsl.dart';

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
  Semester selectedSemester = Semester.all;

  @override
  void initState() {
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    super.initState();
  }

  Widget _buildHeader(List<Score> scoreList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
          ),
        ),
        GpaBanner(selectedSemester, scoreList),
      ],
    );
  }

  Widget _buildListView(List<Score> scoreList) {
    final list = scoreList.map((e) => ScoreItem(e)).toList();
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, _) => Divider(height: 2.0, color: Theme.of(context).primaryColor.withOpacity(0.4)),
      itemBuilder: (_, index) => list[index],
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
          child: Text(i18n.examResultBePatientLabel,
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return MyFutureBuilder<List<Score>>(
      future: ExamResultInit.scoreService.getScoreList(SchoolYear(selectedYear), selectedSemester),
      builder: (context, data) {
        final scoreList = data;
        return Column(
          children: [
            _buildHeader(scoreList),
            Expanded(child: scoreList.isNotEmpty ? _buildListView(scoreList) : _buildNoResult()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_examResult.txt,
      ),
      body: _buildBody(),
    );
  }
}
