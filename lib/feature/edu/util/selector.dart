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
import 'package:kite/storage/init.dart';

import '../common/entity/index.dart';

class SemesterSelector extends StatefulWidget {
  final int? initialYear;
  final Semester? initialSemester;

  /// 是否显示整个学年
  final bool? showEntireYear;
  final bool? showNextYear;
  final Function(int) yearSelectCallback;
  final Function(Semester) semesterSelectCallback;

  const SemesterSelector(this.yearSelectCallback, this.semesterSelectCallback,
      {this.initialYear, this.initialSemester, this.showEntireYear, this.showNextYear, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SemesterSelectorState();
}

class _SemesterSelectorState extends State<SemesterSelector> {
  late final DateTime now;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  @override
  void initState() {
    now = DateTime.now();
    selectedYear = widget.initialYear ?? (now.month >= 9 ? now.year : now.year - 1);
    if (widget.showEntireYear ?? true) {
      selectedSemester = widget.initialSemester ?? Semester.all;
    } else {
      selectedSemester =
          widget.initialSemester ?? ((now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm);
    }
    super.initState();
  }

  List<int> _generateYearList(int entranceYear) {
    var endYear = now.month >= 9 ? now.year : now.year - 1;

    endYear += (widget.showNextYear ?? false) ? 1 : 0;
    List<int> yearItems = [];
    for (int year = entranceYear; year <= endYear; ++year) {
      yearItems.add(year);
    }
    return yearItems;
  }

  String buildYearString(int startYear) {
    return '$startYear - ${startYear + 1}';
  }

  /// 构建选择下拉框.
  /// alternatives 是一个字典, key 为实际值, value 为显示值.
  Widget buildSelector<T>(Map<T, String> alternatives, T initialValue, void Function(T?) callback) {
    final items = alternatives.keys
        .map(
          (k) => DropdownMenuItem<T>(
            value: k,
            child: Text(alternatives[k]!),
          ),
        )
        .toList();

    return DropdownButton<T>(
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
    final grade = KvStorageInitializer.auth.currentUsername!.substring(0, 2);
    // 生成经历过的学期并逆序（方便用户选择）
    final List<int> yearList = _generateYearList(int.parse(grade) + 2000).reversed.toList();
    final mapping = yearList.map((e) => MapEntry(e, buildYearString(e)));

    // 保证显示上初始选择年份、实际加载的年份、selectedYear 变量一致.
    return buildSelector<int>(Map.fromEntries(mapping), selectedYear, (int? selected) {
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
    List<Semester> semesters;
    // 不显示学年
    if (!(widget.showEntireYear ?? true)) {
      semesters = [Semester.firstTerm, Semester.secondTerm];
    } else {
      semesters = [Semester.all, Semester.firstTerm, Semester.secondTerm];
    }
    final semesterItems = Map.fromEntries(semesters.map((e) => MapEntry(e, semesterDescription[e]!)));
    // 保证显示上初始选择学期、实际加载的学期、selectedSemester 变量一致.
    return buildSelector<Semester>(semesterItems, selectedSemester, (Semester? selected) {
      if (selected != null && selected != selectedSemester) {
        setState(() => selectedSemester = selected);
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
