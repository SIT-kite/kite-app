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

import 'history.dart';

enum GameType {
  game2048,
  wordle,
}

class GameMeta {
  final String name;
  final String icon;
  final String route;
  const GameMeta(this.name, this.route, this.icon);
}

const Map<GameType, GameMeta> gameMapping = {
  GameType.game2048: GameMeta('2048', '/game/2048', 'assets/game/icon_2048.png'),
  // GameType.wordle: GameMeta(),
};

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: gameMapping.length, vsync: this);

    super.initState();
  }

  TabBar _buildBarHeader() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: gameMapping.values.map((e) => Tab(text: e.name)).toList(),
    );
  }

  Widget _gameButtonLine(BuildContext context, GameMeta game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Image.asset(game.icon, height: 64, width: 64),
        title: Text(game.name),
        onTap: () => Navigator.of(context).pushNamed(game.route),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GameType gameType) {
    return Column(
      children: [
        const Spacer(),
        _gameButtonLine(context, gameMapping[gameType]!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: gameMapping.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('小游戏'),
          bottom: _buildBarHeader(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
                },
                icon: const Icon(Icons.history))
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: gameMapping.keys.map((e) => _buildContent(context, e)).toList(),
        ),
      ),
    );
  }
}
