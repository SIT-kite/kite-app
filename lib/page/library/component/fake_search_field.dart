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

/// 构造了一个假的文本输入框组件
class FakeSearchField extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String suggestion;

  const FakeSearchField({
    Key? key,
    this.onTap,
    this.suggestion = '',
  }) : super(key: key);

  @override
  _FakeSearchFieldState createState() => _FakeSearchFieldState();
}

class _FakeSearchFieldState extends State<FakeSearchField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
