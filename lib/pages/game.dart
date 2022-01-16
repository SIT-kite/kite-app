import 'package:flutter/material.dart';
import 'package:kite/pages/game/old_game/game_list.dart';

import 'game/game_2048/index.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('小游戏')),
      body: ListView(
        children: [
          ListTile(
              title: const Text('2048'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const Game2048Page(),
                ));
              }),
          ListTile(
              title: const Text('模拟器游戏'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const WebGameListPage(),
                ));
              }),
        ],
      ),
    );
  }
}
