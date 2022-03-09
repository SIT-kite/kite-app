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
import 'package:intl/intl.dart';
import 'package:kite/domain/kite/entity/classroom.dart';
import 'package:kite/domain/kite/init.dart';

import 'item.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({Key? key}) : super(key: key);

  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  static const defaultDayCount = 9;
  static const List<String> campusList = ['奉贤校区', '徐汇校区'];
  static const List<String> fengxianArea = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
  static const List<String> xuhuiArea = ['教学楼', '南图'];
  final List<String> days = _generateDateList(defaultDayCount);

  static final dateFormat = DateFormat('yyyy-MM-dd');

  // 用户查询的参数
  int _dayIndex = 0;
  int _campusIndex = 0;
  int _buildingIndex = 0;

  /// 查询缓存. 避免用户切换日期后重新请求
  /// 第一维为校区的 index, 第二维为日期的 index.
  final List<List<List<AvailableClassroom>>> _cachedQueryResult =
      List.filled(2, List.filled(defaultDayCount, <AvailableClassroom>[]));

  static List<String> _generateDateList(int dayCount) {
    final List<String> result = [];

    DateTime day = DateTime.now();
    for (int i = 0; i < dayCount; ++i) {
      result.add(dateFormat.format(day));
      day = day.add(const Duration(days: 1));
    }
    return result;
  }

  Widget _buildHeaderLine() {
    final primaryColor = Theme.of(context).primaryColor;
    final textStyle = Theme.of(context).textTheme.headline6?.copyWith(color: primaryColor);

    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      color: primaryColor.withOpacity(0.1),
      height: 45,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Row(
            children: [
              ClassroomItem.buildStatusGrid(Colors.green),
              Text('空闲', style: textStyle),
              ClassroomItem.buildStatusGrid(Colors.red),
              Text('有课', style: textStyle)
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ['|上午', '|下午', '|晚上'].map((e) => Expanded(child: Text(e, style: textStyle))).toList()),
        ),
      ]),
    );
  }

  /// 构造用户参数选择部分. 选择日期、校区和楼.
  Widget _buildOptionSection() {
    final primaryColor = Theme.of(context).primaryColor;
    buttonStyle(bool selected) => ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
          backgroundColor: MaterialStateProperty.all(selected ? Colors.white.withOpacity(0.65) : primaryColor),
        );
    textStyle(bool selected) => TextStyle(color: selected ? primaryColor : Colors.white);

    /// 构造列表行
    Widget buildOptionRow(List<String> options, int currentIndex, Function(int) onSelected) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 40),
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              onPressed: () => setState(() => onSelected(index)),
              style: buttonStyle(currentIndex == index),
              child: Center(child: Text(options[index], style: textStyle(currentIndex == index))),
            );
          },
        ),
      );
    }

    final List<String> building = _campusIndex == 0 ? fengxianArea : xuhuiArea;

    return Container(
      color: primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildOptionRow(days, _dayIndex, (i) => _dayIndex = i),
          buildOptionRow(campusList, _campusIndex, (i) {
            _campusIndex = i;
            if (_buildingIndex >= (_campusIndex == 0 ? fengxianArea : xuhuiArea).length) {
              _buildingIndex = 0;
            }
          }),
          buildOptionRow(building, _buildingIndex, (i) => _buildingIndex = i),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildResult(List<AvailableClassroom> data) {
    Widget buildEmptyResult() {
      final textStyle = Theme.of(context).textTheme.headline3;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/timetable/free.png',
            width: 100,
            height: 100,
          ),
          Text('今天休息o(*≧▽≦)ツ', style: textStyle),
        ],
      );
    }

    Widget buildResult() {
      final items = data.map((room) => ClassroomItem(room)).toList();
      return ListView.separated(
        controller: ScrollController(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1.0, color: Theme.of(context).primaryColor.withOpacity(0.4)),
        itemBuilder: (_, index) => items[index],
      );
    }

    if (data.isEmpty) {
      return buildEmptyResult();
    } else {
      return buildResult();
    }
  }

  Future<List<AvailableClassroom>> _getAvailRoomList(int campusIndex, int dayIndex) async {
    final cache = _cachedQueryResult[campusIndex][dayIndex];
    if (cache.isNotEmpty) {
      return cache;
    }
    // 注意：本地数组索引执行的是 奉贤 0, 徐汇 1；服务端执行的是：奉贤 1, 徐汇 2.
    final date = days[dayIndex];
    final result = await KiteInitializer.classroomService.queryAvailableClassroom(_campusIndex + 1, date);
    _cachedQueryResult[campusIndex][dayIndex] = result;
    return result;
  }

  Widget _buildBody() {
    final String selectedBuilding = (_campusIndex == 0 ? fengxianArea : xuhuiArea)[_buildingIndex];

    return FutureBuilder<List<AvailableClassroom>>(
      future: _getAvailRoomList(_campusIndex, _dayIndex),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final rawResult = snapshot.data!;
            List<AvailableClassroom> data = rawResult.where((e) => e.room.startsWith(selectedBuilding)).toList();

            return _buildResult(data);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.runtimeType.toString()));
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('空教室')),
      body: Column(children: [
        _buildOptionSection(),
        _buildHeaderLine(),
        Expanded(child: _buildBody()),
      ]),
    );
  }
}
