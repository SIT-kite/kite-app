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
import '../using.dart';
import '../entity/list.dart';
import '../page/detail.dart';
import 'blur.dart';
import '../page/util.dart';

import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/overlapping_circles.dart';

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

class EventCard extends StatelessWidget {
  final Activity activity;

  const EventCard(this.activity, {Key? key}) : super(key: key);

  Widget _buildTagRow(BuildContext ctx, List<String> tags) {
    return Wrap(
      spacing: 10,
      children: tags
          .sublist(0, min(2, tags.length))
          .map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                e,
                style: ctx.textTheme.bodySmall,
              )))
          .toList(),
    );
  }

  Widget buildGlassmorphicBg(BuildContext ctx) {
    if (ctx.isLightMode) {
      return GlassmorphicBackground(sigmaX: 4, sigmaY: 8, colors: [
        const Color(0xFFf0f0f0).withOpacity(0.1),
        const Color((0xFF5a5a5a)).withOpacity(0.1),
      ]);
    } else {
      return GlassmorphicBackground(sigmaX: 8, sigmaY: 16, colors: [
        const Color(0xFFafafaf).withOpacity(0.3),
        const Color((0xFF0a0a0a)).withOpacity(0.4),
      ]);
    }
  }

  Widget _buildBasicInfo(BuildContext ctx) {
    final titleStyle = ctx.textTheme.headline2?.copyWith(fontWeight: FontWeight.w500);
    final subtitleStyle = ctx.textTheme.headline6?.copyWith(color: Colors.grey);

    final titleList = extractTitle(activity.title);
    final title = titleList.last;

    titleList.removeLast();
    final tags = cleanDuplicate(titleList);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 2.2,
          child: Stack(
            children: [
              const BlurRectWidget(
                CardCoverBackground(),
                sigmaX: 10,
                sigmaY: 10,
                opacity: 0.75,
              ),
              buildGlassmorphicBg(ctx),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    title,
                    style: titleStyle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(color: ctx.bgColor),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTagRow(ctx, tags),
                Text(ctx.dateNum(activity.ts), style: subtitleStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(activity.id)));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(borderRadius: BorderRadius.circular(16), child: _buildBasicInfo(context)),
      ),
    );
  }
}
