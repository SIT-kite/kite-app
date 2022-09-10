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

import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/game/service.dart';

import 'page/entry.dart';
import 'storage.dart';

class GameInitializer {
  static late GameStorage gameRecord;
  static late RankingService rankingService;
  static GameManager gameManager = GameManager();

  static init({required Box<dynamic> gameBox, required ISession kiteSession}) async {
    gameRecord = GameStorage(gameBox);
    rankingService = RankingService(kiteSession);
    // 注册游戏
    [
      Game2048(),
      GameComposeSit(),
      GameTetris(),
      GameWordle(),
    ].forEach(gameManager.registerGame);
  }
}
