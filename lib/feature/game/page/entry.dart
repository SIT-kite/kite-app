import 'package:flutter/material.dart';
import 'package:kite/route.dart';

import '../entity.dart';

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

class GameManager {
  final Map<int, AGame> _games = {};

  void registerGame(AGame game) => _games[game.gameId] = game;

  AGame? findGameById(int id) => _games[id];

  List<int> get gameIdList => _games.keys.toList();

  List<AGame> get gameList => _games.values.toList();

  int get size => _games.length;
}
