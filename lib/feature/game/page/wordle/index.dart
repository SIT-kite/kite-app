/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../entity/game.dart';
import '../../init.dart';
import '../action.dart';
import 'models/board_model.dart';
import 'widgets/alert_dialog.dart';
import 'widgets/board.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key}) : super(key: key);

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  Future<String> getRandomWord() async {
    final words = jsonDecode(
      await rootBundle.loadString('assets/game/words.json'),
    )['5'];
    return words[Random().nextInt(words.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        actions: [helpButton(context)],
      ),
      body: FutureBuilder(
          future: getRandomWord().then((word) => BoardModel(word, rows: word.length + 1)),
          builder: (context, AsyncSnapshot<BoardModel> snapshot) {
            if (snapshot.data == null) return const Text('Cannot load game');

            final board = snapshot.data!;
            final startTime = DateTime.now();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: GameBoard(
                    board: board,
                    onWin: () => showAlertDialog(
                      context,
                      title: 'You Guessed The Word!',
                      actionText: 'Start New Game?',
                      onAction: () {
                        final costTime = DateTime.now().difference(startTime).inSeconds;
                        final score = costTime > 10 * 60 ? 0 : -costTime + 600;

                        // 存储游戏记录
                        final currentTime = DateTime.now();
                        final record =
                            GameRecord(GameType.wordle, score, startTime, currentTime.difference(startTime).inSeconds);
                        GameInitializer.gameRecord.append(record);

                        setState(board.reset);
                      },
                      content: [
                        Text(
                          board.targetWord.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('in ${board.currentRow + 1}/${board.rows} guesses'),
                      ],
                    ),
                    onLose: () => showAlertDialog(
                      context,
                      title: 'The Secret Word was',
                      actionText: 'Try Another Word?',
                      onAction: () => setState(board.reset),
                      content: [
                        Text(
                          board.targetWord.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => setState(board.reset),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(board.targetWord),
                ),
              ],
            );
          }),
    );
  }
}
