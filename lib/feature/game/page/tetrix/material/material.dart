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

// Source from https://github.com/boyan01/flutter-tetris
// All rights kept for original author.
//
// Imported and commented on 2022.8.28

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameMaterial extends StatefulWidget {
  final Widget child;

  const GameMaterial({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _GameMaterialState createState() => _GameMaterialState();

  static ui.Image getMaterial(BuildContext context) {
    final state = context.findAncestorStateOfType<_GameMaterialState>();
    assert(state != null, "can not find GameMaterial widget");
    return state!.material!;
  }
}

class _GameMaterialState extends State<GameMaterial> {
  ///the image data of /assets/material.png
  ui.Image? material;

  @override
  void initState() {
    super.initState();
    _doLoadMaterial();
  }

  void _doLoadMaterial() async {
    if (material != null) {
      return;
    }
    final bytes = await rootBundle.load("assets/game/tetrix/material.png");
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      material = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return material == null ? Container() : widget.child;
  }
}
