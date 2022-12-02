
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

class ColorSaturationFilteredWidget extends StatelessWidget {
  final Widget child;

  ///value [0,1]
  final double saturation;

  const ColorSaturationFilteredWidget({
    required this.child,
    this.saturation = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_saturation(saturation)),
      child: child,
    );
  }

  List<double> get _matrix => [
        1, 0, 0, 0, 0, //R
        0, 1, 0, 0, 0, //G
        0, 0, 1, 0, 0, //B
        0, 0, 0, 1, 0, //A
      ];

  List<double> _saturation(double sat) {
    final m = _matrix;
    final double invSat = 1 - sat;
    final double R = 0.213 * invSat;
    final double G = 0.715 * invSat;
    final double B = 0.072 * invSat;
    m[0] = R + sat;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + sat;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + sat;
    return m;
  }
}
