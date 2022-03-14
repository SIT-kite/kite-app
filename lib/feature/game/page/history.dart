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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kite/feature/game/entity/game.dart';
import 'package:kite/feature/game/init.dart';

class HistoryPage extends StatelessWidget {
  static final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  const HistoryPage({Key? key}) : super(key: key);

  Widget _buildEmptyResult(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline3;

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/game/empty.svg'),
        Text('快去完成一局游戏放松一下吧~', style: textStyle),
      ],
    ));
  }

  Widget _getGameIcon(GameType type) {
    String path;
    switch (type) {
      case GameType.game2048:
        path = 'assets/game/icon_2048.png';
        break;
      case GameType.wordle:
        path = 'assets/game/icon_wordle.png';
        break;
      case GameType.composeSit:
        path = 'assets/game/icon_sit.png';
        break;
    }
    return Image(image: AssetImage(path));
  }

  Widget _buildHistoryItem(BuildContext context, GameRecord record) {
    final titleStyle = Theme.of(context).textTheme.headline3?.copyWith(color: Colors.redAccent);
    final subtitleStyle = Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.orangeAccent);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: _getGameIcon(record.type),
        title: Text(record.score.toString(), style: titleStyle),
        subtitle: Text('${dateFormat.format(record.ts)}  用时 ${record.timeCost} 秒', style: subtitleStyle),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    final history = GameInitializer.gameRecord.getAllRecords().reversed.toList();
    final items = history.map((e) => _buildHistoryItem(context, e)).toList();

    if (items.isNotEmpty) {
      return ListView(children: items);
    } else {
      return _buildEmptyResult(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的记录'),
        actions: [
          IconButton(
            onPressed: () {
              GameInitializer.gameRecord.deleteAll();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: _buildHistory(context),
    );
  }
}
