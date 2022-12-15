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
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../entity/record.dart';
import '../init.dart';
import '../using.dart';

IconButton helpButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WikiPage(customWikiUrl: '${Backend.kite}/wiki/kite-app/game/'),
        ),
      );
    },
    icon: const Icon(Icons.help_outline),
  );
}

Future<void> uploadGameRecord(
  BuildContext context,
  OACredential oa,
  GameRecord record,
) async {
  try {
    // 如果用户未同意过, 请求用户确认
    if (!await signUpIfNecessary(context, oa, '使用学号或工号区分不同用户的游戏记录')) return;
    // 上传记录
    await GameInit.rankingService.postScore(record);
    EasyLoading.showInfo('正在上传');
  } catch (e) {
    EasyLoading.showError('上传出错: $e');
    rethrow;
  }
}
