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

import '../../common/entity/index.dart';
import '../entity/score.dart';
import '../util/gpa.dart';

class GpaBanner extends StatefulWidget {
  final Semester _semester; // 学期 or 学年
  final List<Score> _scoreList;

  const GpaBanner(this._semester, this._scoreList, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GpaBannerState();
}

class _GpaBannerState extends State<GpaBanner> {
  // 当前绩点计算支持用户自己选择课程. selectedList 即为用户选择课程, 当其不为空时, 表示进入自定义选择模式.
  final Set<Score> _selectedSet = {};

  @override
  void initState() {
    Global.eventBus.on<Score>(EventNameConstants.onSelectCourse, _onSelectCourse);
    Global.eventBus.on<Score>(EventNameConstants.onRemoveCourse, _onRemoveCourse);
    super.initState();
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onSelectCourse);
    Global.eventBus.off(EventNameConstants.onRemoveCourse);
    super.dispose();
  }

  String _getType() {
    return (widget._semester == Semester.all) ? "学年" : "学期";
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
        child: Text('已选 ${_selectedSet.length} 门 绩点 ${gpa.toStringAsPrecision(2)}', softWrap: true),
      );
    } else {
      final type = _getType();
      final gpa = calcGPA(widget._scoreList);

      return Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFffe599),
        child: Text('$type绩点 ${gpa.isNaN ? 0.00 : gpa.toStringAsPrecision(2)}', softWrap: true),
      );
    }
  }
}
