import 'package:flutter/material.dart';
import 'package:kite/pages/game/game_2048/index.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('小游戏')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Game2048Page()));
          },
          child: const Text('2048'),
        ),
      ),
    );
  }
}
