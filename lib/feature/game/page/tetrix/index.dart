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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'gamer/gamer.dart';
import 'gamer/keyboard.dart';
import 'panel/page_portrait.dart';

const SCREEN_BORDER_WIDTH = 3.0;

const BACKGROUND_COLOR = Colors.white24;

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class TetrixPage extends StatelessWidget {
  const TetrixPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('俄罗斯方块')),
      body: Game(
        child: KeyboardController(child: const PagePortrait()),
      ),
    );
  }
}
