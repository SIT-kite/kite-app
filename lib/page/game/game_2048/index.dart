/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
// 来源于 https://github.com/linuxsong/game2048
// 作者是 linuxsong, 版权归原作者所有.
// 在迁移到 kite-app (github.com/SIT-kite/kite-app) 时, 做了一些 null-safety 的适配
// 并更新了 dart 中列表相关的写法.
//
// sunnysab (sunnysab.cn)
// 2022.1.14

import 'package:flutter/material.dart';
import 'package:kite/entity/game.dart';
import 'package:kite/global/storage_pool.dart';

import 'logic.dart';

final boxColors = <int, Color>{
  2: Colors.orange[50]!,
  4: Colors.orange[100]!,
  8: Colors.orange[200]!,
  16: Colors.orange[300]!,
  32: Colors.orange[400]!,
  64: Colors.orange[500]!,
  128: Colors.orange[600]!,
  256: Colors.orange[700]!,
  512: Colors.orange[800]!,
  1024: Colors.orange[900]!,
};

class Game2048Page extends StatelessWidget {
  const Game2048Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
      ),
      body: const GameWidget(),
    );
  }
}

class BoardGridWidget extends StatelessWidget {
  final _GameWidgetState _state;

  const BoardGridWidget(this._state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardSize = _state.boardSize();
    double width = (boardSize.width - (_GameWidgetState.column + 1) * _state.cellPadding) / _GameWidgetState.column;
    List<CellBox> _backgroundBox = <CellBox>[];
    for (int r = 0; r < _GameWidgetState.row; ++r) {
      for (int c = 0; c < _GameWidgetState.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.cellPadding * (c + 1),
          top: r * width + _state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[300]!,
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
        left: 0.0,
        top: 0.0,
        child: Container(
          width: _state.boardSize().width,
          height: _state.boardSize().height,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Stack(
            children: _backgroundBox,
          ),
        ));
  }
}

class GameWidget extends StatefulWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameWidgetState();
  }
}

class _GameWidgetState extends State<GameWidget> {
  static const int row = 4;
  static const int column = 4;

  bool _isDragging = false;
  bool _isGameOver = false;
  final Game _game = Game(row, column);

  late MediaQueryData _queryData;
  final double cellPadding = 5.0;
  final EdgeInsets _gameMargin = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0);

  final startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    _game.init();
    _isGameOver = false;
    setState(() {});
  }

  void moveLeft() {
    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  void checkGameOver() {
    if (_game.isGameOver()) {
      _isGameOver = true;

      // 存储游戏记录
      final currentTime = DateTime.now();
      final record =
          GameRecord(GameType.game2048, _game.score, currentTime, currentTime.difference(startTime).inSeconds);
      StoragePool.gameRecord.append(record);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CellWidget> _cellWidgets = <CellWidget>[];
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _cellWidgets.add(CellWidget(_game.get(r, c), this));
      }
    }

    _queryData = MediaQuery.of(context);

    List<Widget> children = <Widget>[];
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidgets);

    return Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  // 把这个组件拉出来吧，缩进要炸了
                  color: Colors.orange[100],
                  child: SizedBox(
                    width: 130.0,
                    height: 60.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("得分", style: TextStyle(color: Colors.grey[700])),
                          Text(
                            _game.score.toString(),
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  // 还有这个
                  child: Container(
                      width: 130.0,
                      height: 60.0,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!)),
                      child: const Center(child: Text("新游戏"))),
                  onPressed: () {
                    newGame();
                  },
                ),
              ],
            )),
        SizedBox(
          height: 50.0,
          child: Opacity(
            opacity: _isGameOver ? 1.0 : 0.0,
            child: const Center(
              child: Text("Game Over!", style: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
        Container(
            margin: _gameMargin,
            width: _queryData.size.width,
            height: _queryData.size.width,
            child: GestureDetector(
              onVerticalDragUpdate: (detail) {
                // 把这几个函数提出来？
                if (detail.delta.distance == 0 || _isDragging) {
                  return;
                }
                _isDragging = true;
                if (detail.delta.direction > 0) {
                  moveDown();
                } else {
                  moveUp();
                }
              },
              onHorizontalDragUpdate: (detail) {
                if (detail.delta.distance == 0 || _isDragging) {
                  return;
                }
                _isDragging = true;
                if (detail.delta.direction > 0) {
                  moveLeft();
                } else {
                  moveRight();
                }
              },
              onVerticalDragEnd: (_) {
                _isDragging = false;
              },
              onVerticalDragCancel: () {
                _isDragging = false;
              },
              onHorizontalDragDown: (_) {
                _isDragging = false;
              },
              onHorizontalDragCancel: () {
                _isDragging = false;
              },
              child: Stack(children: children),
            )),
      ],
    );
  }

  Size boardSize() {
    Size size = _queryData.size;
    double width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }
}

class AnimatedCellWidget extends AnimatedWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  final Animation<double> animation;

  const AnimatedCellWidget(this.cell, this.state, this.animation, {Key? key}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (_GameWidgetState.column + 1) * state.cellPadding) / _GameWidgetState.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) + width / 2 * (1 - animationValue),
        top: cell.row * width + state.cellPadding * (cell.row + 1) + width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: boxColors.containsKey(cell.number) ? boxColors[cell.number]! : boxColors[boxColors.keys.last]!,
        text: Text(
          cell.number.toString(),
          maxLines: 1,
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[600] : Colors.grey[50],
          ),
        ),
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _GameWidgetState state;

  const CellWidget(this.cell, this.state, {Key? key}) : super(key: key);

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      widget.cell,
      widget.state,
      animation,
    );
  }
}

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text? text;

  const CellBox({required this.left, required this.top, required this.size, required this.color, this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Center(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.center, child: text))),
    );
  }
}
