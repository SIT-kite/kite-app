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

import '../entity/score.dart';
import '../init.dart';
import '../using.dart';
import 'evaluation.dart';
import 'index.dart';

class ScoreItem extends StatefulWidget {
  final Score _score;

  const ScoreItem(this._score, {Key? key}) : super(key: key);

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  late Score _score;
  bool _isExpanded = false;
  bool _isSelected = false;

  Widget _buildScoreDetailView(List<ScoreDetail> scoreDetails) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
      child: Column(
        children: scoreDetails.map((e) => Text('${e.scoreType} (${e.percentage}): ${e.value}')).toList(),
      ),
    );
  }

  Widget _buildScoreDetail() {
    final future = ExamResultInit.scoreService.getScoreDetail(_score.innerClassId, _score.schoolYear, _score.semester);

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _buildScoreDetailView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${i18n.failed}: ${snapshot.error.runtimeType}');
        }
        return Placeholders.loading();
      },
    );
  }

  Widget _buildLeading() {
    if (_isSelected) {
      return SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Global.eventBus.emit(EventNameConstants.onRemoveCourse, _score);
              setState(() => _isSelected = false);
            },
          ),
        ),
      );
    } else {
      return Image.asset('assets/course/${CourseCategory.query(_score.course)}.png');
    }
  }

  // TODO: I18n
  Widget _buildTrailing() {
    final style = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.blue);

    if (!_score.value.isNaN) return Text(_score.value.toString(), style: style);

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EvaluationPage()));
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ScorePage()));
      },
      child: Text('待评教', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    _score = widget._score;
    final titleStyle = Theme.of(context).textTheme.headline4;
    final subtitleStyle = Theme.of(context).textTheme.bodyText1;

    return Column(children: [
      ListTile(
        minLeadingWidth: 60,
        leading: _buildLeading(),
        title: Text(_score.course, style: titleStyle),
        subtitle: Text('${_score.courseId[0] != 'G' ? '必修' : '选修'} | 学分: ${_score.credit}', style: subtitleStyle),
        trailing: _buildTrailing(),
        onTap: () => setState(() {
          _isExpanded = !_isExpanded;
        }),
        onLongPress: () {
          if (_isSelected) {
            Global.eventBus.emit(EventNameConstants.onRemoveCourse, _score);
          } else {
            Global.eventBus.emit(EventNameConstants.onSelectCourse, _score);
          }
          setState(() => _isSelected = !_isSelected);
        },
      ),
      _isExpanded ? _buildScoreDetail() : Container()
    ]);
  }
}
