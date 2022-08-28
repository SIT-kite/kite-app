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

import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/util/logger.dart';

import 'dao.dart';
import 'entity.dart';

class RankingService extends AService implements RankingServiceDao {
  static const _rankingPrefix = '/game/ranking/';
  static const _uploadScore = '/game/record';

  RankingService(ASession session) : super(session);

  @override
  Future<List<GameRankingItem>> getGameRanking(int gameId) async {
    final response = await session.get(_rankingPrefix + gameId.toString());
    final List person = response.data;

    return person.map((e) => GameRankingItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> postScore(GameRecord record) async {
    Log.info(record.toJson());
    await session.post(_uploadScore, data: record.toJson());
  }
}
