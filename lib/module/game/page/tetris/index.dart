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

// Source from https://github.com/boyan01/flutter-tetris
// All rights kept for original author.
//
// Imported and commented on 2022.8.28

import 'package:flutter/material.dart';
import 'package:kite/design/user_widgets/dialog.dart';
import '../../user_widgets/dialog.dart';
import '../../using.dart';
import 'gamer/gamer.dart';
import 'gamer/keyboard.dart';
import 'panel/page_portrait.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class TetrisPage extends StatelessWidget {
  const TetrisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => await showLeaveGameRequest(context),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('俄罗斯方块'),
              actions: [
                IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () async {
                      await context.showTip(
                          title: '键位说明',
                          desc: '如果您使用键盘，键位如下：'
                              'W: 旋转\n'
                              'S: 加速下落\n'
                              'A: 左移\n'
                              'D: 右移\n'
                              '空格: 瞬间下落\n'
                              'P: 暂停\n'
                              'O: 关闭/开启音量\n'
                              'R: 重置游戏\n',
                          ok: '知道了');
                    })
              ],
            ),
            body: Game(
              child: KeyboardController(child: const PagePortrait()),
            )));
  }
}
