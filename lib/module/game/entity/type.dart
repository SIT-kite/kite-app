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
import '../using.dart';

part 'type.g.dart';

@HiveType(typeId: HiveTypeId.gameType)
enum GameType {
  /// 2048 游戏
  @HiveField(0)
  game2048,

  /// Wordle 游戏
  @HiveField(1)
  wordle,

  /// 合成上应大游戏
  @HiveField(2)
  composeSit,

  /// 俄罗斯方块
  @HiveField(3)
  tetris;

  static int toIndex(GameType type) => type.index;

  static GameType fromIndex(int index) => GameType.values[index];
}
