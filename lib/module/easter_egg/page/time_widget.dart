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

import 'digit_model.dart';
import 'simple_world.dart';

class MultiProtuberance extends MovableObject {
  late double primaryRadius;
  double radius;
  late double rotate;
  double count;

  MultiProtuberance(WorldRule worldRule, this.radius, this.count) : super(worldRule) {
    primaryRadius = radius;
    rotate = Random.secure().nextDouble();
  }

  @override
  void tick() {
    super.tick();
    radius = primaryRadius + primaryRadius * 3 * (position.dy / worldRule.bound.height);
  }

  @override
  void draw(Canvas canvas) {
    for (int i = 0; i < count; i++) {
      canvas.drawLine(
        position,
        position.translate(
          radius * cos(2 * pi * (i / count) + rotate),
          radius * sin(2 * pi * (i / count) + rotate),
        ),
        paint,
      );
    }
  }

  MultiProtuberance clone() {
    return MultiProtuberance(worldRule, radius, count)
      ..position = Offset(
        position.dx,
        position.dy,
      )
      ..paint = paint;
  }
}

class Circle extends MovableObject {
  late double primaryRadius;
  double radius;

  Circle(WorldRule worldRule, this.radius) : super(worldRule) {
    primaryRadius = radius;
  }

  @override
  void tick() {
    super.tick();
    radius = primaryRadius + primaryRadius * 2 * (position.dy / worldRule.bound.height);
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(position, radius, paint);
  }

  Circle clone() {
    return Circle(worldRule, radius)
      ..position = Offset(
        position.dx,
        position.dy,
      )
      ..paint = paint;
  }

  @override
  void collisionTest() {
    final size = getWorldRule().bound;
    // 撞到左右上墙壁了,应当删除
    if (position.dx < 0 || position.dx > size.width || position.dy < 0) {
      outOfDate = true;
    }
    // 撞到下墙壁了
    if (position.dy + radius > size.height) {
      position = position.translate(0, -1);
      velocity = velocity.scale(1, -0.9);
    }
  }
}

class TimeWidget extends StatefulWidget {
  final World world = World(WorldRule(
    Size.zero,
    tickTime: 0.016,
  ));

  TimeWidget({Key? key}) : super(key: key);

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  /// 1000 / 60 = 16.666666
  static const frameDelay = 16;
  static const summonDelay = 5;

  /// A timer for summoning limitation
  int frameCounter = 0;
  late World world;
  Drawable? back;
  bool hasDispose = false;
  int currentTimeMs = 0;

  double get width => world.worldRule.bound.width;

  double get height => world.worldRule.bound.height;

  /// 每个小球的盒半径
  double get circleBoundWidth => width / (2 * (showDigitIndexes.length + 2) * 10) * 1.2;
  List<int> showDigitIndexes = [];

  Circle generateCircle(Offset position) {
    double hue = ((currentTimeMs / 10000 * 360 + position.dx / width * 360) % 360).toDouble();

    // android端刚启动时hue值可能为NaN导致程序异常（暂时未知原因）
    if (!(hue <= 360 && hue >= 0)) {
      hue = 0;
    }

    // 水平初速度置为+-100
    final vx = Random.secure().nextDouble() * 200 - 100;
    const vy = 0.0;
    final ax = (vy < 0 ? -1 : 1) * Random.secure().nextDouble() * 50;
    const ay = 2000.0;
    // 该行常数控制了小球真实半径与小球包围盒之间的内边距padding
    return Circle(world.worldRule, circleBoundWidth - 0.6)
      ..position = position
      ..velocity = Offset(vx, vy)
      ..acceleration = Offset(ax, ay)
      ..paint = (Paint()
        ..color = HSVColor.fromAHSV(
          Random.secure().nextDouble() * 0.4 + 0.6,
          hue,
          Random.secure().nextDouble() * 0.2 + 0.8,
          Random.secure().nextDouble() * 0.2 + 0.8,
        ).toColor());
  }

  List<Circle> generateCircles() {
    final now = DateTime.now();
    showDigitIndexes = [
      // now.hour ~/ 10,
      now.hour ~/ 10,
      now.hour % 10,
      10,
      now.minute ~/ 10,
      now.minute % 10,
      10,
      now.second ~/ 10,
      now.second % 10,
      14,
      11, 12, 13,
    ];

    final balls = <Circle>[];
    for (int i = 0; i < showDigitIndexes.length; i++) {
      final List<List<int>> define = digitDefine[showDigitIndexes[i]];
      // print('as');
      for (int r = 0; r < define.length; r++) {
        for (int c = 0; c < define[r].length; c++) {
          if (define[r][c] == 1) {
            /// 设所有字符均占7列
            /// 屏幕宽度为w
            /// 时钟要显示8个字
            /// 为了美观，左右两边空缺两个字
            /// 即假设有10个字站满
            /// 即需要小球半径为w/(10*7)-某个值作为间隙

            // 控制这一行的参数2可改变字体宽度比例
            double x = 2 * circleBoundWidth * c +
                // 控制这一行的常数可改变字体间距
                1.5 * circleBoundWidth * showDigitIndexes.length * i +
                circleBoundWidth * showDigitIndexes.length;
            double y = circleBoundWidth * r * 2 + height / 2 - circleBoundWidth * 8 * 2;

            balls.add(generateCircle(Offset(x, y)));
          }
        }
      }
    }
    return balls;
  }

  List<Circle> circles = [];

  @override
  void initState() {
    super.initState();
    world = widget.world;
    final firstTime = DateTime.now();
    Future.delayed(Duration.zero, () async {
      while (!hasDispose) {
        circles = generateCircles();
        back = MultiDrawable(circles.map((e) {
          final cl = e.clone();
          // 设置时钟不透明
          final hue = HSVColor.fromColor(cl.paint.color).hue;
          cl.paint.color = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
          return cl;
        }).toList());

        currentTimeMs = DateTime.now().millisecondsSinceEpoch - firstTime.millisecondsSinceEpoch;
        await Future.delayed(const Duration(milliseconds: frameDelay));
        update();
      }
    });

    Future.delayed(Duration.zero, () async {
      while (!hasDispose) {
        circles.where((_) => Random.secure().nextDouble() < 0.001).forEach(world.pushMovableObject);
        await Future.delayed(const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    hasDispose = true;
    super.dispose();
  }

  void update() {
    world.tick();
    if (!hasDispose) {
      setState(() {});
    }
  }

  Drawable buildRect() {
    return FunctionalDrawable((canvas) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          // width,
          // 2 * circleBoundWidth * 11 + 2 * height / 20,
          width, height,
        ),
        Paint()
          ..color = (HSVColor.fromAHSV(
            0.2,
            // 矩形背景求一个对比色
            ((DateTime.now().second * 6 + 180) % 360).toDouble(),
            1,
            1,
          ).toColor()),
      );
    });
  }

  Widget buildMainWidget() {
    return GestureDetector(
      child: CustomPaint(
        painter: DrawablePainter(
          MultiDrawable([
            world,
            buildRect(),
            back,
          ]),
          beforePaint: (_, size) {
            world.worldRule.bound = size;
          },
        ),
      ),
      onPanUpdate: (DragUpdateDetails details) {
        frameCounter++;
        if (frameCounter > summonDelay) {
          world.pushMovableObject(generateCircle(details.localPosition));
          frameCounter -= summonDelay;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMainWidget();
  }
}
