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

/// 显示对话框,对话框关闭后Future结束
Future<int?> showAlertDialog(
  BuildContext context, {
  required String title,
  dynamic content,
  List<String>? actionTextList,
  List<Widget>? actionWidgetList,
}) async {
  if (actionTextList != null && actionWidgetList != null) {
    throw Exception('actionTextList 与 actionWidgetList 参数不可同时传入');
  }

  if (actionTextList == null && actionWidgetList == null) {
    actionWidgetList = [];
  }
  Widget contentWidget = Container();

  if (content is List<Widget>) {
    contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  } else if (content is Widget) {
    contentWidget = content;
  } else {
    throw TypeError();
  }

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
      content: contentWidget,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: () {
            if (actionTextList != null) {
              return actionTextList.asMap().entries.map((e) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, e.key);
                    },
                    child: Text(e.value),
                  ),
                );
              }).toList();
            } else {
              return actionWidgetList!.asMap().entries.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, e.key);
                  },

                  /// 把外部Widget的点击吸收掉
                  child: AbsorbPointer(
                    child: e.value,
                  ),
                );
              }).toList();
            }
          }(),
        ),
      ],
    ),
  );
}
