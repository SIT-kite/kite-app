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
import 'package:kite/design/user_widgets/dialog.dart';
import 'package:kite/module/game/using.dart';

/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import '../models/board_model.dart';
import 'character_box.dart';

class GameBoard extends StatefulWidget {
  final BoardModel board;
  final Function() onWin, onLose;

  const GameBoard({
    Key? key,
    required this.board,
    required this.onWin,
    required this.onLose,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  handleCharInput(String value, int colIdx) {
    if (value == '') {
      // on backspace jump to previous box & clear the char
      if (colIdx != 0) FocusScope.of(context).previousFocus();
      setState(() => widget.board.remove(colIdx: colIdx));
      return;
    }
    setState(() => widget.board.add(value, colIdx: colIdx));

    // jump to next box
    if (colIdx < widget.board.columns - 1) {
      FocusScope.of(context).nextFocus();
    }
    const Vibration(milliseconds: 100).emit();
  }

  Future<bool> validateWord(String word) {
    return Future(() => widget.board.allWords.contains(word));
  }

  Future<void> handleRowSubmit() async {
    if (widget.board.isRowComplete()) {
      if (widget.board.isRowTargetWord()) {
        widget.onWin();
      } else if (widget.board.currentRow >= widget.board.rows - 1) {
        widget.onLose();
      } else {
        final word = widget.board.composeWord();
        if (await validateWord(word)) {
          setState(() => widget.board.moveToNextRow());
        } else {
          await const Vibration(milliseconds: 400, amplitude: 120).emit();
          if (mounted) {
            await context.showTip(title: i18n.error, desc: i18n.gameWordleNoSuchWord(word), ok: i18n.ok);
          }
        }
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateBoard(),
    );
  }

  List<Widget> generateBoard() {
    List<Widget> result = [];
    for (var i = 0; i < widget.board.rows; i++) {
      List<Widget> newRow = [];

      for (var j = 0; j < widget.board.columns; j++) {
        newRow.add(CharacterBox(
          color: widget.board.getColor(rowIdx: i, colIdx: j),
          child: i == widget.board.currentRow
              ? CharacterInput(
                  value: widget.board.state[i][j],
                  onChange: (val) => handleCharInput(val, j),
                  onSubmit: handleRowSubmit,
                )
              : Text(
                  widget.board.state[i][j],
                  style: const TextStyle(fontSize: 32),
                ),
        ));
      }
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: newRow,
      ));
    }
    return result;
  }
}
