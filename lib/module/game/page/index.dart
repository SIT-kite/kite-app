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
import 'package:kite/module/game/page/entry.dart';
import 'package:kite/module/initializer_index.dart';

import 'common.dart';
import 'history.dart';
import 'ranking.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GameManager gameManager = GameInitializer.gameManager;

  @override
  void initState() {
    _tabController = TabController(length: gameManager.size, vsync: this);
    super.initState();
  }

  TabBar _buildBarHeader() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: gameManager.gameList.map((e) => Text(e.title)).toList(),
    );
  }

  Widget _gameButtonLine(AGame game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: ListTile(
        leading: SizedBox(width: 64, height: 64, child: game.icon),
        trailing: const Icon(Icons.chevron_right),
        title: Text(game.title),
        onTap: () => game.enter(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AGame game) {
    return Column(
      children: [
        Expanded(child: GameRanking(game.gameId)),
        _gameButtonLine(game),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: gameManager.size,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('小游戏'),
          bottom: _buildBarHeader(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
                },
                icon: const Icon(Icons.history)),
            helpButton(context),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: gameManager.gameList.map((e) => _buildContent(context, e)).toList(),
        ),
      ),
    );
  }
}
