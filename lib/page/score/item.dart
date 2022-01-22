import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/score/evaluation.dart';
import 'package:kite/service/edu.dart';
import 'package:kite/service/edu/evaluation.dart';
import 'package:kite/util/edu/icon.dart';

class ScoreItem extends StatefulWidget {
  final Score _score;

  const ScoreItem(this._score, {Key? key}) : super(key: key);

  @override
  _ScoreItemState createState() => _ScoreItemState(_score);
}

class _ScoreItemState extends State<ScoreItem> {
  final Score _score;
  bool _isExpanded = false;

  @override
  _ScoreItemState(this._score);

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
    final future =
        ScoreService(SessionPool.eduSession).getScoreDetail(_score.innerClassId, _score.schoolYear, _score.semester);

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

  Widget _buildScoreValueView() {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue);

    if (!_score.value.isNaN) {
      return Text(_score.value.toString(), style: style);
    } else {
      // 获取评教列表. 然后找到与当前课程有关的, 将评教页面呈现给用户.
      final future = CourseEvaluationService(SessionPool.eduSession).getEvaluationList();

      return FutureBuilder<List<CourseToEvaluate>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final coursesToEvaluate =
                  (snapshot.data!).where((element) => element.dynClassId.startsWith(_score.dynClassId)).toList();

              if (coursesToEvaluate.isNotEmpty) {
                return GestureDetector(
                  child: const Text('去评教', style: style),
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
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.orange.shade300, width: 2)),
      ),
      child: Column(children: [
        ListTile(
          leading: Image.asset('assets/course/${CourseCategory.query(_score.course)}.png'),
          title: Text(_score.course, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${_score.courseId[0] != 'G' ? '必修' : '选修'} | 学分: ${_score.credit}'),
          trailing: _buildScoreValueView(),
          onTap: () => setState(() {
            _isExpanded = !_isExpanded;
          }),
        ),
        _isExpanded ? _buildScoreDetail() : Container()
      ]),
    );
  }
}
