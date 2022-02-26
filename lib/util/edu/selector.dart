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
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/storage_pool.dart';

class SemesterSelector extends StatefulWidget {
  final int? initialYear;
  final Semester? initialSemester;

  final Function(int) yearSelectCallback;
  final Function(Semester) semesterSelectCallback;

  const SemesterSelector(this.yearSelectCallback, this.semesterSelectCallback,
      {this.initialYear, this.initialSemester, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SemesterSelectorState();
}

class _SemesterSelectorState extends State<SemesterSelector> {
  late final DateTime now;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  Semester selectedSemester = Semester.all;

  @override
  void initState() {
    now = DateTime.now();
    selectedYear = now.month >= 9 ? now.year : now.year - 1;
    super.initState();
  }

  List<int> _generateYearList(int entranceYear) {
    final endYear = now.month >= 9 ? now.year : now.year - 1;

    List<int> yearItems = [];
    for (int year = entranceYear; year <= endYear; ++year) {
      yearItems.add(year);
    }
    return yearItems;
  }

  Semester indexToSemester(int index) {
    return [Semester.all, Semester.firstTerm, Semester.secondTerm][index];
  }

  String buildYearString(int startYear) {
    return '$startYear - ${startYear + 1}';
  }

  /// 构建选择下拉框.
  /// alternatives 是一个字典, key 为实际值, value 为显示值.
  Widget buildSelector(Map<int, String> alternatives, int initialValue, void Function(int?) callback) {
    final items = alternatives.keys
        .map(
          (k) => DropdownMenuItem<int>(
            value: k,
            child: Text(alternatives[k]!),
          ),
        )
        .toList();

    return DropdownButton<int>(
      value: initialValue,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      style: const TextStyle(
        color: Color(0xFF002766),
      ),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: callback,
      items: items,
    );
  }

  Widget buildYearSelector() {
    // 得到入学年份
    final grade = StoragePool.authSetting.currentUsername!.substring(0, 2);
    // 生成经历过的学期并逆序（方便用户选择）
    final List<int> yearList = _generateYearList(int.parse(grade) + 2000).reversed.toList();
    final mapping = yearList.map((e) => MapEntry(e, buildYearString(e)));

    // 保证显示上初始选择年份、实际加载的年份、selectedYear 变量一致.
    return buildSelector(Map.fromEntries(mapping), selectedYear, (int? selected) {
      if (selected != null && selected != selectedYear) {
        setState(() => selectedYear = selected);
        widget.yearSelectCallback(selectedYear);
      }
    });
  }

  Widget buildSemesterSelector() {
    const semesterDescription = {
      Semester.all: '全学年',
      Semester.firstTerm: '第一学期',
      Semester.secondTerm: '第二学期',
    };
    final semesters = Semester.values.map((e) => MapEntry(e.index, semesterDescription[e]!));
    // 保证显示上初始选择学期、实际加载的学期、selectedSemester 变量一致.
    return buildSelector(Map.fromEntries(semesters), selectedSemester.index, (int? selected) {
      if (selected != null && selected != (selectedSemester.index)) {
        setState(() => selectedSemester = indexToSemester(selected));
        widget.semesterSelectCallback(selectedSemester);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        child: buildYearSelector(),
      ),
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: buildSemesterSelector(),
      ),
    ]);
  }
}
