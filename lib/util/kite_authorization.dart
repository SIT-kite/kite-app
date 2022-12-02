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
import 'package:kite/module/expense2/using.dart';
import 'package:kite/module/shared/init.dart';
import 'package:kite/storage/init.dart';

bool hasSignedKite() {
  return Kv.jwt.jwtToken != null;
}

Future<bool> signUpIfNecessary(BuildContext context, String description) async {
  // 如果用户未同意过, 请求用户确认
  if (Kv.jwt.jwtToken == null) {
    final confirm = await context.showRequest(
        title: '授权',
        desc: '“上应小风筝”将使用您的登录信息，在小风筝服务中为您分配一个账户，以：\n'
            '\n'
            '- $description\n'
            '\n'
            '开发团队会遵循《用户协议》与《隐私政策》，不会存储您的密码。',
        yes: '取消',
        no: '继续');
    if (confirm == true) {
      // 注册用户
      final username = Kv.auth.currentUsername!;
      final password = Kv.auth.ssoPassword!;
      await SharedInit.kiteSession.login(username, password);
    }
  }
  return true;
}
