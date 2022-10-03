import 'package:kite/network/session.dart';
import 'package:kite/util/logger.dart';

import '../dao/remote.dart';
import '../entity/rank.dart';
import '../entity/record.dart';

class RankingService implements RankingServiceDao {
  static const _rankingPrefix = '/game/ranking/';
  static const _uploadScore = '/game/record';

  final ISession session;

  const RankingService(this.session);

  ///发送请求，获取游戏排名
  @override
  Future<List<GameRankingItem>> getGameRanking(int gameId) async {
    final response = await session.request(_rankingPrefix + gameId.toString(), ReqMethod.get);
    final List person = response.data;

    return person.map((e) => GameRankingItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> postScore(GameRecord record) async {
    Log.info(record.toJson());
    await session.request(_uploadScore, ReqMethod.post, data: record.toJson());
  }
}
