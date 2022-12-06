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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/bulletin.dart';
import '../using.dart';

class BulletinCard extends StatelessWidget {
  final KiteBulletin bulletin;

  const BulletinCard(this.bulletin, {super.key});

  @override
  Widget build(BuildContext context) {
    return [
      _buildTitle(context, bulletin),
      Text(context.dateNum(bulletin.publishTime), style: const TextStyle(color: Colors.grey))
          .align(at: Alignment.bottomRight),
      [
        // 标题, 注意遇到长标题时要折断
        // 日期
        const SizedBox(height: 10),
        // 正文
        MyMarkdownWidget(bulletin.content ?? '').expanded(),
      ].row(maa: MainAxisAlignment.spaceBetween)
    ]
        .column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min)
        .padAll(10)
        .inCard(elevation: 5)
        .padSymmetric(h: 10.h, v: 2.h);
  }
}

class BulletinPreview extends StatelessWidget {
  final KiteBulletin bulletin;
  final bool isSelected;

  const BulletinPreview(this.bulletin, {super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? context.theme.secondaryHeaderColor : null;
    return [
      _buildTitle(context, bulletin, overflow: TextOverflow.ellipsis),
      context
          .dateNum(bulletin.publishTime)
          .text(style: const TextStyle(color: Colors.grey))
          .align(at: Alignment.bottomRight),
    ].column().padAll(10).inCard(elevation: 8, color: color);
  }
}

Widget _buildTitle(BuildContext ctx, KiteBulletin bulletin, {TextOverflow? overflow}) {
  final title = bulletin.title.text(overflow: overflow, style: Theme.of(ctx).textTheme.headline3);
  if (bulletin.top) {
    return [const Icon(Icons.push_pin_rounded), title].row();
  } else {
    return title;
  }
}
