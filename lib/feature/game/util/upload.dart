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
import 'package:kite/feature/game/entity/game.dart';
import 'package:kite/feature/game/service/ranking.dart';
import 'package:kite/feature/kite/init.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/kite_authorization.dart';

Future<void> _innerUploadGameRecord(BuildContext context, GameRecord record) async {
  // 如果用户未同意过, 请求用户确认
  signUpIfNecessary(context, '使用学号或工号区分不同用户的游戏记录');

  // 上传记录
  await RankingService(KiteInitializer.kiteSession).postScore(record);
}

Future<void> uploadGameRecord(BuildContext context, GameRecord record) async {
  try {
    await _innerUploadGameRecord(context, record);
  } catch (e) {
    showBasicFlash(context, Text('上传出错\n' + e.toString()));
    rethrow;
  }
  showBasicFlash(context, const Text('上传成功'));
}
