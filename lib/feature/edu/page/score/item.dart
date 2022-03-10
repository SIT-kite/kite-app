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
import 'package:kite/global/global.dart';

import '../../entity/index.dart';
import '../../init.dart';
import '../../util/icon.dart';
import 'evaluation.dart';

class ScoreItem extends StatefulWidget {
  final Score _score;

  const ScoreItem(this._score, {Key? key}) : super(key: key);

  @override
  _ScoreItemState createState() => _ScoreItemState();
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
    final future = EduInitializer.score.getScoreDetail(_score.innerClassId, _score.schoolYear, _score.semester);

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _buildScoreDetailView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.runtimeType}');
        }
        return const Center(child: CircularProgressIndicator());
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

  Widget _buildTrailing() {
    final style = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.blue);

    if (!_score.value.isNaN) {
      return Text(_score.value.toString(), style: style);
    } else {
      // 获取评教列表. 然后找到与当前课程有关的, 将评教页面呈现给用户.
      return FutureBuilder<List<CourseToEvaluate>>(
          future: EduInitializer.courseEvaluation.getEvaluationList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final coursesToEvaluate =
                  (snapshot.data!).where((element) => element.dynClassId.startsWith(_score.dynClassId)).toList();

              if (coursesToEvaluate.isNotEmpty) {
                return GestureDetector(
                  child: Text('去评教', style: style),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EvaluationPage(coursesToEvaluate)));
                  },
                );
              } else {
                return const Text('评教不可用');
              }
            } else if (snapshot.hasError) {
              return Text(snapshot.error.runtimeType.toString());
            }
            return const CircularProgressIndicator();
          });
    }
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
