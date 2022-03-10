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

import '../../entity/classroom.dart';

class ClassroomItem extends StatelessWidget {
  final AvailableClassroom _classroom;

  const ClassroomItem(this._classroom, {Key? key}) : super(key: key);

  static Widget buildStatusGrid(color) {
    return Container(
      margin: const EdgeInsets.only(left: 1.0, right: 1.0),
      width: 10.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(4.5)),
        color: color,
      ),
    );
  }

  Widget _buildGrids() {
    final busyTime = _classroom.busyTime;

    List<Widget> state = [];
    for (int i = 0; i < 12; i++) {
      final bool isAvailable = busyTime & (1 << i) == 0;
      final color = isAvailable ? Colors.green : Colors.red;
      state.add(buildStatusGrid(color));
    }
    return Row(children: [
      Expanded(child: Row(mainAxisSize: MainAxisSize.min, children: state.sublist(0, 4))),
      Expanded(child: Row(mainAxisSize: MainAxisSize.min, children: state.sublist(4, 8))),
      Expanded(child: Row(mainAxisSize: MainAxisSize.min, children: state.sublist(9, 12))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final roomStyle = Theme.of(context).textTheme.headline4;
    final capacityStyle = Theme.of(context).textTheme.bodyText2;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_classroom.room, style: roomStyle),
                _classroom.capacity != null ? Text('${_classroom.capacity} 座', style: capacityStyle) : Container(),
              ],
            ),
          ),
          Expanded(flex: 2, child: _buildGrids()),
        ],
      ),
    );
  }
}
