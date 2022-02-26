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
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/score/item.dart';
import 'package:kite/service/edu/index.dart';
import 'package:kite/util/edu/selector.dart';
import 'package:kite/util/logger.dart';

import 'banner.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  /// 四位年份
  int selectedYear = DateTime.now().year;

  /// 要查询的学期
  Semester selectedSemester = Semester.all;

  final Widget _notFoundPicture = SvgPicture.asset(
    'assets/score/not-found.svg',
    width: 260,
    height: 260,
  );

  Widget _buildHeader(List<Score> scoreList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return Column(children: [
      Container(
        child: _notFoundPicture,
      ),
      const Text('暂时还没有成绩', style: TextStyle(color: Colors.grey)),
      Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: const Text('过会儿再来吧！', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      )
    ]);
  }

  Widget _buildBody() {
    final future = ScoreService(SessionPool.eduSession).getScoreList(SchoolYear(selectedYear), selectedSemester);

    return FutureBuilder<List<Score>>(
      future: future,
      builder: (context, snapshot) {
        Log.info('查询成绩:${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString().split('\n')[0]));
          }
          final scoreList = snapshot.data!;

          Log.info(scoreList);
          return Column(children: [
            _buildHeader(scoreList),
            Expanded(child: scoreList.isNotEmpty ? _buildListView(scoreList) : _buildNoResult()),
          ]);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成绩查询'),
      ),
      body: _buildBody(),
    );
  }
}
