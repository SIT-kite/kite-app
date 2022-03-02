import 'package:flutter/material.dart';

/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import '../models/board_model.dart';
import '../widgets/character_box.dart';

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
    if (value == "") {
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
  }

  handleRowSubmit() {
    if (widget.board.isRowComplete()) {
      if (widget.board.isRowTargetWord()) {
        widget.onWin();
      } else if (widget.board.currentRow >= widget.board.rows - 1) {
        widget.onLose();
      } else {
        setState(() => widget.board.moveToNextRow());
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
