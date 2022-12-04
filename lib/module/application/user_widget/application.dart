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
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import '../entity/function.dart';
import '../page/detail.dart';
import 'dart:math';

class ApplicationTile extends StatelessWidget {
  final ApplicationMeta meta;
  final bool isHot;

  const ApplicationTile({super.key, required this.meta, required this.isHot});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random(meta.id.hashCode).nextInt(applicationColors.length);
    final color = applicationColors[colorIndex];
    final Widget views;
    if (isHot) {
      views = [
        Text(meta.count.toString()),
        SvgPicture.asset('assets/common/icon_flame.svg', width: 20, height: 20, color: Colors.orange),
      ].row(mas: MainAxisSize.min);
    } else {
      views = Text(meta.count.toString());
    }

    return ListTile(
      leading: Icon(meta.icon, size: 35, color: color).center().sized(width: 40, height: 40),
      title: Text(
        meta.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        meta.summary,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: views,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(meta: meta)),
        );
      },
    );
  }
}
