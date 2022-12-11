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
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/widgets.dart';

extension LiveListAnimationEx on Widget {
  Widget aliveWith(
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: CurveTween(
          curve: Curves.fastLinearToSlowEaseIn,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: CurveOffset(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
            curve: Curves.fastLinearToSlowEaseIn,
          ).animate(animation),
          // Paste you Widget
          child: this,
        ),
      );
}

const kiteLiveOptions = LiveOptions(
  showItemInterval: Duration(milliseconds: 40), // the interval between two items
  showItemDuration: Duration(milliseconds: 250), // How long it animated to appear
);

class CurveOffset extends Animatable<Offset> {
  final Offset begin;
  final Offset end;

  /// Creates a curve tween.
  ///
  /// The [curve] argument must not be null.
  CurveOffset({required this.begin, required this.end, required this.curve});

  /// The curve to use when transforming the value of the animation.
  final Curve curve;

  @override
  Offset transform(double t) {
    return Offset(
      curve.transform(t) * (end.dx - begin.dx) + begin.dx,
      curve.transform(t) * (end.dy - begin.dy) + begin.dy,
    );
  }

  @override
  String toString() => 'CurveTweenOffset(curve: $curve)';
}
