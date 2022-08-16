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
import 'package:flutter/painting.dart';
import 'package:kite/util/range.dart';

int randomInt(int start, int end) {
  return start + Random.secure().nextInt(end - start);
}

double randomDouble(double start, double end) {
  return start + (end - start) * Random.secure().nextDouble();
}

extension RandomChooseRange<T extends num> on Range<T> {
  int randomChooseInt() {
    if (start is int && end is int && step == 1) {
      return randomInt(start.toInt(), end!.toInt());
    }
    // TODO
    throw UnsupportedError('随机数工具暂不支持非整数Range的情况');
  }

  double randomChooseDouble() {
    return randomDouble(start.toDouble(), (end ?? double.maxFinite).toDouble());
  }
}

extension RandomChoose<T> on List<T> {
  T randomChooseOne([int? start, int? end]) {
    start ??= 0;
    end ??= length;
    return this[randomInt(start, end)];
  }
}

extension RandomColor on Color {
  static Color randomARGB({
    Range<int>? rangeA,
    required Range<int> rangeR,
    required Range<int> rangeG,
    required Range<int> rangeB,
  }) {
    return Color.fromARGB(
      rangeA?.randomChooseInt() ?? 255,
      rangeR.randomChooseInt(),
      rangeG.randomChooseInt(),
      rangeB.randomChooseInt(),
    );
  }

  static Color randomAHSV({
    Range<double>? rangeA,
    required Range<double> rangeH,
    Range<double>? rangeS,
    Range<double>? rangeV,
  }) {
    final one = range(1, 1);
    return HSVColor.fromAHSV(
      (rangeA ?? one).randomChooseDouble(),
      rangeH.randomChooseDouble(),
      (rangeS ?? one).randomChooseDouble(),
      (rangeV ?? one).randomChooseDouble(),
    ).toColor();
  }
}
