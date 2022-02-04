/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
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

import 'item.dart';

class NightItem extends StatelessWidget {
  final String content = '不早了，互道一句晚安早点休息吧';

  const NightItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    if (now.hour >= 21 || now.hour < 6) {
      return HomeItem(
        route: '/night',
        icon: 'assets/home/icon_night.svg',
        title: '晚安',
        subtitle: content,
      );
    }
    return const SizedBox(height: 0);
  }
}
