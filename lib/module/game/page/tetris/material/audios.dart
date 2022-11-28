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

import 'package:kite/module/game/using.dart';

class Sound {
  bool mute = false;

  void _play(String name) {
    if (!mute) {
      // AudioPlayer player = AudioPlayer();
      // player.play(AssetSource('game/tetris/$name'));
    }
  }

  void start() {
    const Vibration(milliseconds: 100, amplitude: 100).emit();
    _play('start.mp3');
  }

  void clear() {
    const Vibration(milliseconds: 100, amplitude: 100).emit();
    _play('clean.mp3');
  }

  void fall() {
    const Vibration(milliseconds: 200, amplitude: 255).emit();
    _play('drop.mp3');
  }

  void rotate() {
    const Vibration(milliseconds: 80, amplitude: 125).emit();
    _play('rotate.mp3');
  }

  void move() {
    const Vibration(milliseconds: 120, amplitude: 80).emit();
    _play('move.mp3');
  }
}
