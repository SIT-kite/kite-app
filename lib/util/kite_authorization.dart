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
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/storage/init.dart';

class AuthorizationDialog extends StatelessWidget {
  final String msg;

  const AuthorizationDialog(this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('授权'),
      content: Text(
        '“上应小风筝”将使用您的登录信息，在小风筝服务中为您分配一个账户，以：\n'
        '\n'
        '- $msg\n'
        '\n'
        '开发团队会遵循《用户协议》与《隐私政策》，不会存储您的密码。',
      ),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(), //关闭对话框
        ),
        ElevatedButton(
          child: const Text('继续'),
          onPressed: () => Navigator.of(context).pop(true), //关闭对话框
        ),
      ],
    );
  }
}

Future<bool> signUpIfNecessary(BuildContext context, String description) async {
  // 如果用户未同意过, 请求用户确认
  if (KvStorageInitializer.jwt.jwtToken == null) {
    final bool? check = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AuthorizationDialog(description),
    );
    if (check == null || !check) {
      // 取消上传
      return false;
    }

    // 注册用户
    final username = KvStorageInitializer.auth.currentUsername!;
    final password = KvStorageInitializer.auth.ssoPassword!;
    await KiteInitializer.kiteSession.login(username, password);
  }
  return true;
}
