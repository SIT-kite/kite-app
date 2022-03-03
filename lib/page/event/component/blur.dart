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

import 'dart:ui';

import 'package:flutter/material.dart';

/// 矩形高斯模糊效果
class BlurRectWidget extends StatefulWidget {
  final Widget? child;

  // 模糊值
  final double? sigmaX;
  final double? sigmaY;

  /// 透明度
  final double? opacity;

  const BlurRectWidget(
    this.child, {
    Key? key,
    this.sigmaX,
    this.sigmaY,
    this.opacity,
  }) : super(key: key);

  @override
  _BlurRectWidgetState createState() => _BlurRectWidgetState();
}

class _BlurRectWidgetState extends State<BlurRectWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.sigmaX ?? 10,
          sigmaY: widget.sigmaY ?? 10,
        ),
        child: Container(
          color: Colors.white10,
          child: widget.opacity != null
              ? Opacity(
                  opacity: widget.opacity!,
                  child: widget.child,
                )
              : widget.child,
        ),
      ),
    );
  }
}
