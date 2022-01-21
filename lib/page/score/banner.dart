import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/util/edu/gpa.dart';

class GpaBanner extends StatelessWidget {
  final Semester _semester; // 学期 or 学年
  final List<Score> _scoreList;

  const GpaBanner(this._semester, this._scoreList, {Key? key}) : super(key: key);

  String _getType() {
    return (_semester == Semester.all) ? "学年" : "学期";
  }

  @override
  Widget build(BuildContext context) {
    final type = _getType();
    final gpa = calcGPA(_scoreList);

    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFffe599),
      child: Text('$type绩点 ${gpa.isNaN ? 0.00 : gpa.toStringAsPrecision(2)}', softWrap: true),
    );
  }
}
