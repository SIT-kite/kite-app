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
          (i) => List.generate(targetWord.length, (j) => ''),
        );

  add(String value, {int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow][colIdx] = value.toUpperCase();
  }

  remove({int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow][colIdx] = '';
  }

  moveToNextRow() => currentRow++;

  reset() {
    state = List.generate(
      rows,
      (i) => List.generate(columns, (j) => ''),
    );
    currentRow = 0;
  }

  bool isRowComplete({int? rowIdx}) {
    return state[rowIdx ?? currentRow].join('').length == columns;
  }

  bool isRowTargetWord({int? rowIdx}) {
    return state[rowIdx ?? currentRow].join('') == targetWord;
  }

  Color getColor({required int rowIdx, required int colIdx}) {
    final char = state[rowIdx][colIdx];

    if (rowIdx == currentRow) {
      return Colors.grey.shade600;
    } else if (char == targetWord[colIdx]) {
      return Colors.green;
    } else if (char != '' && targetWord.contains(char)) {
      return Colors.orange;
    }
    return Colors.grey.shade700;
  }
}
