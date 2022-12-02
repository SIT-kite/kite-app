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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/overlapping_circles.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../page/detail.dart';
import 'blur.dart';

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
            const BlurRectWidget(
              CardCoverBackground(),
              sigmaX: 10,
              sigmaY: 10,
              opacity: 0.75,
            ),
            buildGlassmorphismBg(ctx),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  activity.realTitle,
                  style: titleStyle,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ).hero(activity.id),
              ),
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
    ).on(tap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(activity, hero: activity.id)));
    });
  }
}

class CardCoverBackground extends StatelessWidget {
  const CardCoverBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gen = Random();
        final pattern = OverlappingCircles(
          radius: 60,
          nx: 6,
          ny: 6,
          fillColors: List.generate(
              36,
              (_) => Color.fromARGB(10 + (gen.nextDouble() * 100).round(), 50 + gen.nextInt(2) * 150,
                  50 + gen.nextInt(2) * 150, 50 + gen.nextInt(2) * 150)),
        );
        return ClipRect(
          child: CustomPaint(
            willChange: true,
            painter: FullPainter(pattern: pattern, background: Colors.yellow),
            child: SizedBox(width: constraints.maxWidth, height: constraints.maxHeight),
          ),
        );
      },
    );
  }
}
