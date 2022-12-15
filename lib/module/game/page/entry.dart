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

import '../entity/type.dart';
import '../using.dart';

abstract class AGame {
  /// 获取游戏标题
  String get title;

  /// 获取游戏图标
  Widget get icon;

  /// 游戏的唯一id
  int get gameId;

  /// 进入游戏
  void enter(BuildContext context);

  @override
  bool operator ==(Object other) => other is AGame && other.gameId == gameId;

  @override
  int get hashCode => gameId;
}

class Game2048 implements AGame {
  @override
  String get title => '2048';

  @override
  int get gameId => GameType.game2048.index;

  @override
  Widget get icon => Image.asset('assets/game/icon_2048.png');

  @override
  void enter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteTable.game2048);
  }
}

class GameComposeSit implements AGame {
  @override
  String get title => '合成上应大';

  @override
  int get gameId => GameType.composeSit.index;

  @override
  Widget get icon => Image.asset('assets/game/icon_sit.png');

  @override
  void enter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteTable.gameComposeSit);
  }
}

class GameWordle implements AGame {
  @override
  String get title => 'Wordle';

  @override
  int get gameId => GameType.wordle.index;

  @override
  Widget get icon => Image.asset('assets/game/icon_wordle.png');

  @override
  void enter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteTable.gameWordle);
  }
}

class GameTetris implements AGame {
  @override
  String get title => '俄罗斯方块';

  @override
  int get gameId => GameType.tetris.index;

  @override
  Widget get icon => Image.asset('assets/game/icon_tetris.png');

  @override
  void enter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteTable.gameTetris);
  }
}

class GameManager {
  final Map<int, AGame> _games = {};

  void registerGame(AGame game) => _games[game.gameId] = game;

  AGame? findGameById(int id) => _games[id];

  List<int> get gameIdList => _games.keys.toList();

  List<AGame> get gameList => _games.values.toList();

  int get size => _games.length;
}
