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

typedef SwitchCallback = void Function(int index);

class MultiButtonSwitch extends StatefulWidget {
  final List<Widget> children;
  final SwitchCallback onSwitch;
  final int defaultOptionIndex;

  const MultiButtonSwitch({
    Key? key,
    required this.children,
    required this.onSwitch,
    this.defaultOptionIndex = 0,
  }) : super(key: key);

  @override
  State<MultiButtonSwitch> createState() => _MultiButtonSwitchState();
}

class _MultiButtonSwitchState extends State<MultiButtonSwitch> {
  late int currentOptionIndex;

  @override
  void initState() {
    currentOptionIndex = widget.defaultOptionIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.children.asMap().entries.map((MapEntry<int, Widget> entry) {
        final e = Expanded(
          child: TextButton(
            onPressed: () {
              widget.onSwitch(entry.key);
              setState(() {
                currentOptionIndex = entry.key;
              });
            },
            child: entry.value,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (currentOptionIndex == entry.key) {
                  return Colors.blueAccent;
                }
                return Colors.black;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                //设置按下时的背景颜色
                if (currentOptionIndex == entry.key) {
                  return Colors.blue[100];
                }
                //默认不使用背景颜色
                return null;
              }),
            ),
          ),
        );
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [e],
          ),
        );
      }).toList(),
    );
  }
}
