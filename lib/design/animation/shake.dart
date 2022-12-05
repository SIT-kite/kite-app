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

import 'dart:ui';

import 'package:flutter_shake_animated/flutter_shake_animated.dart';

final allLittleShaking = [
  LittleShaking1(),
  LittleShaking2(),
  ShakeLittleConstant1(),
  ShakeLittleConstant2(),
];

class LittleShaking1 implements ShakeConstant {
  @override
  List<int> get interval => [3, 4, 5];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate => const [
        0,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0
      ];

  @override
  List<Offset> get translate => const [
        Offset(0, 0),
        Offset(1, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0),
        Offset(0, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0)
      ];

  @override
  Duration get duration => const Duration(milliseconds: 100);
}

class LittleShaking2 implements ShakeConstant {
  @override
  List<int> get interval => [5, 5, 4, 3];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate => const [
        0,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0.5,
        0
      ];

  @override
  List<Offset> get translate => const [
        Offset(0, 0),
        Offset(1, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0),
        Offset(0, 0),
        Offset(0, 0),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(0, 1),
        Offset(0, 1),
        Offset(0, 1),
        Offset(1, 0),
        Offset(1, 1),
        Offset(1, 1),
        Offset(0, 0)
      ];

  @override
  Duration get duration => const Duration(milliseconds: 120);
}
