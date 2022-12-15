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
import 'package:kite/credential/symbol.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';

import '../user_widget/brick.dart';

class FreshmanItem extends StatelessWidget {
  const FreshmanItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Hide this in personalization system.
    // 老师根本不会显示这个列表项
    // 所以只考虑正式学生的情况

    /*// 正式学生，获取学号
      final username = Kv.auth.currentUsername!;
      // 取今年的后两位，若今年的后两位大于学号前两位
      // 说明已经不是新生了
      final now = DateTime.now();
      // 到了 12 月，也把迎新入口隐藏掉
      if (now.year % 100 > (int.tryParse(username.substring(0, 2)) ?? 0) || now.month > 11) {
        return const SizedBox();
      }*/
    // No matter whether the user is a freshman, display this for them.
    return Brick(
      onPressed: () {
        if (Auth.freshmanCredential == null) {
          Navigator.of(context).pushNamed(RouteTable.freshmanLogin);
        } else {
          Navigator.of(context).pushNamed(RouteTable.freshman);
        }
      },
      icon: SysIcon(Icons.people),
      title: i18n.ftype_freshman,
      subtitle: i18n.ftype_freshman_desc,
    );
  }
}
