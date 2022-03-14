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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/kite/init.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../entity/game.dart';
import '../service/ranking.dart';

class GameRanking extends StatefulWidget {
  static const _colorMapping = [Colors.red, Colors.deepOrange, Colors.orange];

  final GameType gameType;

  GameRanking(this.gameType, {Key? key}) : super(key: key);

  @override
  State<GameRanking> createState() => _GameRankingState();
}

class _GameRankingState extends State<GameRanking> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  /// 构建排行榜行, 下标从 1 开始
  Widget _buildItem(BuildContext context, int index, GameRankingItem item) {
    final color = index > 3 ? Colors.yellow : GameRanking._colorMapping[index - 1];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(index.toString()),
        radius: 20,
      ),
      minLeadingWidth: 40,
      title: Text(item.studentId),
      trailing: Text(item.score.toString()),
      onTap: () {},
    );
  }

  Widget emptyRanking(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/game/no_content.svg'),
          Text(
            '今日还没有人上榜\n快来一局吧！',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = RankingService(KiteInitializer.kiteSession);
    final future = service.getGameRanking(widget.gameType.index);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onRefresh: () {
        if (mounted) {
          setState(() {});
          Future.delayed(
            const Duration(milliseconds: 500),
            () => _refreshController.refreshCompleted(resetFooterState: true),
          );
        }
      },
      child: MyFutureBuilder<List<GameRankingItem>>(
        future: future,
        builder: (context, list) {
          if (list.isEmpty) {
            return emptyRanking(context);
          }
          final widgets = <Widget>[];
          list.sort((a, b) => b.score - a.score);
          for (int i = 0; i < list.length; ++i) {
            widgets.add(_buildItem(context, i + 1, list[i]));
          }
          return Column(mainAxisSize: MainAxisSize.min, children: widgets);
        },
      ),
    );
  }
}
