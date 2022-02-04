/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/event_bus.dart';
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
    eventBus.on<Score>(EventNameConstants.onSelectCourse, _onSelectCourse);
    eventBus.on<Score>(EventNameConstants.onRemoveCourse, _onRemoveCourse);
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onSelectCourse);
    eventBus.off(EventNameConstants.onRemoveCourse);
    super.dispose();
  }

  String _getType() {
    return (_semester == Semester.all) ? "学年" : "学期";
  }

  void _onSelectCourse(Score? score) {
    setState(() {
      _selectedSet.add(score!);
    });
  }

  void _onRemoveCourse(Score? score) {
    setState(() {
      _selectedSet.remove(score!);
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
