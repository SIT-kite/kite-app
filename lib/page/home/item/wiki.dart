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
import 'package:kite/page/home/item/index.dart';

class WikiItem extends StatelessWidget {
  const WikiItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeFunctionButton(
      route: '/wiki',
      icon: 'assets/home/icon_wiki.svg',
      title: 'Wiki',
      subtitle: '上应大生存指南',
    );
  }
}
