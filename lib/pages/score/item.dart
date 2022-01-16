import 'package:flutter/material.dart';
import 'package:kite/entity/edu/score.dart';
import 'package:kite/entity/edu/score_detail.dart';

class ScoreItem extends StatefulWidget {
  final Score _score;

  const ScoreItem(this._score, {Key? key}) : super(key: key);

  @override
  _ScoreItemState createState() => _ScoreItemState(_score);
}

class _ScoreItemState extends State<ScoreItem> {
  final Score _score;
  late List<ScoreDetail>? _scoreDetails;
  bool _isExpanded = false; // TODO: support score detail.

  @override
  _ScoreItemState(this._score);

  Widget _buildScoreDetail() {
    // TODO: Use FutureBuilder.
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _scoreDetails!
            .map((e) => Text('${e.scoreType} (${e.percentage}): ${e.value}'))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.blue, width: 1))),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.orange.shade300, width: 3),
              ),
            ),
            child: Text(_score.course,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            // TODO: 修改必修、选修判断方式.
            child: Text(
                '${_score.courseId[0] != 'G' ? '必修' : '选修'} | 学分: ${_score.credit}'),
          ),
        ]),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text(
            '${(_score.value - (-1)) < 0.1 ? _score.value : '待评教'}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
          ),
        ),
      ]),
    );
  }
}
