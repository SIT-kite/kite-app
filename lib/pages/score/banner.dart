import 'package:flutter/material.dart';
import 'package:kite/entity/edu/score.dart';
import 'package:kite/entity/edu/year_semester.dart';
import 'package:kite/utils/edu/gpa.dart';

class GpaBanner extends StatelessWidget {
  final Semester _semester; // 学期 or 学年
  final List<Score> _scoreList;

  const GpaBanner(this._semester, this._scoreList, {Key? key})
      : super(key: key);

  String _getType() {
    return (_semester == Semester.all) ? "学年" : "学期";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFffe599),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '该$_getType()绩点为 ${calcGPA(_scoreList)}, 努力总会有回报哒!',
          )
        ],
      ),
    );
  }
}
