import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/edu.dart';

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
        ScoreService(SessionPool.eduSession).getScoreDetail(_score.classId, _score.schoolYear, _score.semester);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.orange.shade300, width: 2)),
      ),
      child: Column(children: [
        ListTile(
          title: Text(_score.course, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${_score.courseId[0] != 'G' ? '必修' : '选修'} | 学分: ${_score.credit}'),
          trailing: Text(
            '${(!_score.value.isNaN) ? _score.value : '去评教'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
          ),
          onTap: () => setState(() {
            _isExpanded = !_isExpanded;
          }),
        ),
        _isExpanded ? _buildScoreDetail() : Container()
      ]),
    );
  }
}
