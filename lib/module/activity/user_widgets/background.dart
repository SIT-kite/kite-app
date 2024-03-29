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
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/overlapping_circles.dart';
import 'package:rettulf/buildcontext/theme.dart';

import '../using.dart';

/// 矩形高斯模糊效果
class Blur extends StatelessWidget {
  final Widget? child;

  // 模糊值
  final double? sigmaX;
  final double? sigmaY;

  /// 透明度
  final double? opacity;

  const Blur(
    this.child, {
    Key? key,
    this.sigmaX,
    this.sigmaY,
    this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX ?? 10,
          sigmaY: sigmaY ?? 10,
        ),
        child: Container(
            color: Colors.white10,
            child: Opacity(
              opacity: opacity ?? 1.0,
              child: child,
            )),
      ),
    );
  }
}

class ColorfulCircleBackground extends StatefulWidget {
  final int? seed;

  const ColorfulCircleBackground({super.key, this.seed});

  @override
  State<StatefulWidget> createState() => _ColorfulCircleBackgroundState();
}

class _ColorfulCircleBackgroundState extends State<ColorfulCircleBackground> {
  late int? seed = widget.seed ?? hashCode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gen = Random(seed);
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

Widget buildGlassmorphismBg(BuildContext ctx) {
  if (ctx.isLightMode) {
    return GlassmorphismBackground(sigmaX: 4, sigmaY: 8, colors: [
      const Color(0xFFf0f0f0).withOpacity(0.1),
      const Color((0xFF5a5a5a)).withOpacity(0.1),
    ]);
  } else {
    return GlassmorphismBackground(sigmaX: 8, sigmaY: 16, colors: [
      const Color(0xFFafafaf).withOpacity(0.3),
      const Color((0xFF0a0a0a)).withOpacity(0.4),
    ]);
  }
}
