import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/util/edu/gpa.dart';

class GpaBanner extends StatefulWidget {
  final Semester _semester; // 学期 or 学年
  final List<Score> _scoreList;

  const GpaBanner(this._semester, this._scoreList);

  @override
  State<StatefulWidget> createState() => _GpaBannerState(_semester, _scoreList);
}

class _GpaBannerState extends State<GpaBanner> {
  final Semester _semester; // 学期 or 学年
  final List<Score> _scoreList;

  // 当前绩点计算支持用户自己选择课程. selectedList 即为用户选择课程, 当其不为空时, 表示进入自定义选择模式.
  Set<Score> _selectedSet = {};

  _GpaBannerState(this._semester, this._scoreList, {Key? key});

  @override
  void initState() {
    eventBus.on('onSelectCourse', _onSelectCourse);
    eventBus.on('onRemoveCourse', _onRemoveCourse);
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off('onSelectCourse');
    eventBus.off('onRemoveCourse');
    super.dispose();
  }

  String _getType() {
    return (_semester == Semester.all) ? "学年" : "学期";
  }

  void _onSelectCourse(dynamic score) {
    setState(() {
      _selectedSet.add(score as Score);
    });
  }

  void _onRemoveCourse(dynamic score) {
    setState(() {
      _selectedSet.remove(score as Score);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSet.isNotEmpty) {
      final gpa = calcGPA(_selectedSet.toList());

      return Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFffe599),
        child: Text('已选 ${_selectedSet.length} 门课程 绩点 ${gpa.toStringAsPrecision(2)}', softWrap: true),
      );
    } else {
      final type = _getType();
      final gpa = calcGPA(_scoreList);

      return Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFffe599),
        child: Text('$type绩点 ${gpa.isNaN ? 0.00 : gpa.toStringAsPrecision(2)}', softWrap: true),
      );
    }
  }
}
