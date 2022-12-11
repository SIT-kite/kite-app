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
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../page/detail.dart';
import 'background.dart';

import '../using.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard(this.activity, {Key? key}) : super(key: key);

  Widget _buildBasicInfo(BuildContext ctx) {
    final titleStyle = ctx.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500);
    final tagsStyle = ctx.textTheme.titleSmall;
    final subtitleStyle = ctx.textTheme.bodySmall?.copyWith(color: Colors.grey);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Blur(
              ColorfulCircleBackground(seed: activity.id),
              sigmaX: 10,
              sigmaY: 10,
              opacity: 0.75,
            ),
            buildGlassmorphismBg(ctx),
            Center(
              child: Text(
                activity.realTitle,
                style: titleStyle,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ).padSymmetric(h: 12),
            ),
          ],
        ).expanded(),
        Container(
          decoration: BoxDecoration(color: ctx.bgColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                activity.tags.join(" ").text(style: tagsStyle, maxLines: 2, overflow: TextOverflow.clip),
                ctx
                    .dateNum(activity.ts)
                    .text(style: subtitleStyle, overflow: TextOverflow.clip)
                    .align(at: Alignment.centerRight)
                    .padOnly(r: 8),
              ],
            ).align(at: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: _buildBasicInfo(context)),
    ).hero(activity.id).on(tap: () {
      final route = AdaptiveUI.of(context).makeRoute((_) => DetailPage(activity, hero: activity.id));
      context.navigator.push(route);
    });
  }
}
