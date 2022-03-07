/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import 'package:flutter/material.dart';

class BoardModel {
  List<List<String>> state;
  final String targetWord;
  final int rows, columns;
  var currentRow = 0;

  BoardModel(String targetWord, {int? rows})
      : targetWord = targetWord.toUpperCase(),
        columns = targetWord.length,
        rows = rows ?? targetWord.length,
        state = List.generate(
          rows ?? targetWord.length,
          (i) => List.generate(targetWord.length, (j) => ""),
        );

  add(String value, {int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow][colIdx] = value.toUpperCase();
  }

  remove({int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow][colIdx] = "";
  }

  moveToNextRow() => currentRow++;

  reset() {
    state = List.generate(
      rows,
      (i) => List.generate(columns, (j) => ""),
    );
    currentRow = 0;
  }

  bool isRowComplete({int? rowIdx}) {
    return state[rowIdx ?? currentRow].join("").length == columns;
  }

  bool isRowTargetWord({int? rowIdx}) {
    return state[rowIdx ?? currentRow].join("") == targetWord;
  }

  Color getColor({required int rowIdx, required int colIdx}) {
    final char = state[rowIdx][colIdx];

    if (rowIdx == currentRow) {
      return Colors.grey.shade600;
    } else if (char == targetWord[colIdx]) {
      return Colors.green;
    } else if (char != "" && targetWord.contains(char)) {
      return Colors.orange;
    }
    return Colors.grey.shade700;
  }
}
