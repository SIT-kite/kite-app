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

abstract class Drawable {
  /// 绘制
  void draw(Canvas canvas);
}

/// 定义一个世界的基本法则
class WorldRule {
  /// 时间片(单位s)
  double tickTime;

  /// 世界的边界
  Size bound;

  WorldRule(this.bound, {
    this.tickTime = 16,
  });
}

abstract class ITickHandler {
  void tick();
}

mixin Movable on IObject implements ITickHandler {
  WorldRule getWorldRule();

  /// 一个相当无脑的碰撞检测默认实现，
  /// 该方法在下一次世界迭代前调用，
  /// 子类可重写该方法实现更复杂的碰撞检测
  void collisionTest() {
    final size = getWorldRule().bound;
    // 撞到左右墙壁了,应当删除
    if (position.dx < 0 || position.dx > size.width) {
      outOfDate = true;
    }
    // 撞到上下墙壁了
    if (position.dy < 0 || position.dy > size.height) {
      // x方向速度不变，y方向速度变为原来的0.7倍，并且反向
      velocity = velocity.scale(1, -0.5);
      // if ((position.dx ~/ (size.width ~/ 10)) % 2 == 0) {
      //   velocity = velocity.scale(1, -0.5);
      // } else {
      //   outOfDate = true;
      // }
    }
  }

  /// 时间片推进一次之后，各物理量的改变
  @override
  void tick() {
    // 时间片长度，单位s
    final dt = getWorldRule().tickTime;
    collisionTest();
    final tickNumPerSecond = 1 / dt;
    position = position.translate(
      velocity.dx / tickNumPerSecond,
      velocity.dy / tickNumPerSecond,
    );
    velocity = velocity.translate(
      acceleration.dx / tickNumPerSecond,
      acceleration.dy / tickNumPerSecond,
    );
  }
}

abstract class IObject implements Drawable {
  /// 以下物理量的单位时间定义均为1s

  /// 当前位置
  Offset position = const Offset(0, 0);

  /// 当前速度
  Offset velocity = const Offset(0, 0);

  /// 当前加速度
  Offset acceleration = const Offset(0, 0);

  /// 画笔
  Paint paint = Paint()..color = Colors.black;

  /// 是否作废，下一轮应当回收？
  bool outOfDate = false;
}

abstract class MovableObject extends IObject with Movable {
  WorldRule worldRule;

  MovableObject(this.worldRule);

  @override
  WorldRule getWorldRule() {
    return worldRule;
  }
}

class World implements Drawable, ITickHandler {
  WorldRule worldRule;

  World(this.worldRule);

  /// 可运动的对象集合
  List<MovableObject> _objects = [];

  int size() => _objects.length;

  void pushMovableObject(MovableObject object) {
    _objects.add(object);
  }

  @override
  void draw(Canvas canvas) {
    for (final object in _objects) {
      object.draw(canvas);
    }
  }

  @override
  void tick() {
    // 删除所有过期的对象
    _objects = _objects.where((o) => !o.outOfDate).toList();
    // 对每个对象演化一个时间片
    for (final object in _objects) {
      object.tick();
    }
  }
}

typedef FunctionalDrawableCallback = void Function(Canvas canvas);

class FunctionalDrawable implements Drawable {
  final FunctionalDrawableCallback callback;

  const FunctionalDrawable(this.callback);

  @override
  void draw(Canvas canvas) {
    callback(canvas);
  }
}

class MultiDrawable implements Drawable {
  final Iterable<Drawable?> drawables;

  const MultiDrawable(this.drawables);

  @override
  void draw(Canvas canvas) {
    for (final drawable in drawables) {
      if (drawable != null) {
        drawable.draw(canvas);
      }
    }
  }
}

typedef OnPaintCallback = void Function(Canvas canvas, Size size);

class DrawablePainter extends CustomPainter {
  Drawable drawable;
  OnPaintCallback? beforePaint;
  OnPaintCallback? afterPaint;

  DrawablePainter(this.drawable, {
    this.beforePaint,
    this.afterPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 白色清屏
    canvas.drawRect(Rect.largest, Paint()..color = Colors.white);

    if (beforePaint != null) {
      beforePaint!(canvas, size);
    }

    drawable.draw(canvas);
    if (afterPaint != null) {
      afterPaint!(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
