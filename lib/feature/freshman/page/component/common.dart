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
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/flash.dart';

import '../../entity.dart';
import 'profile.dart';

List<InfoItem> buildContactInfoItems(BuildContext context, Contact? contact) {
  final wechat = contact?.wechat;
  final qq = contact?.qq;
  final tel = contact?.tel;
  return [
    if (wechat != null && wechat.isNotEmpty)
      InfoItem(
        Icons.wechat,
        '微信',
        wechat,
        onTap: () {
          Clipboard.setData(ClipboardData(text: wechat));
          showBasicFlash(context, const Text('不支持启动微信, 已复制到剪切板'));
        },
        trailIconData: Icons.copy,
      ),
    if (qq != null && qq.isNotEmpty)
      InfoItem(
        Icons.person,
        'QQ',
        qq,
        onTap: () async {
          if (!await GlobalLauncher.launchQqContact(qq)) {
            Clipboard.setData(ClipboardData(text: qq));
            showBasicFlash(context, const Text('未安装QQ, 已复制到剪切板'));
          }
        },
        trailIconData: Icons.open_in_browser,
      ),
    if (tel != null && tel.isNotEmpty)
      InfoItem(
        Icons.phone,
        '电话号码',
        tel,
        onTap: () async {
          if (!await GlobalLauncher.launchTel(tel)) {
            Clipboard.setData(ClipboardData(text: tel));
            showBasicFlash(context, const Text('无法启动电话, 已复制到剪切板'));
          }
        },
        trailIconData: Icons.phone,
      ),
  ];
}

Widget buildListItemDefaultAvatar(BuildContext context, String name) {
  final TextStyle avatarStyle = Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]);

  return CircleAvatar(
    backgroundColor: Colors.white,
    radius: 20,
    child: Container(
      child: name.isEmpty
          ? const Center(child: Icon(Icons.account_circle, size: 40, color: Colors.black))
          : Text(name[0], style: avatarStyle),
    ),
  );
}

/// 构造默认头像
Widget buildDefaultAvatar(String name, {required Color defaultColor}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: defaultColor,
      boxShadow: const [BoxShadow(color: Colors.black54, offset: Offset(1.0, 1.0), blurRadius: 2.0)],
    ),
    child: Container(
      alignment: const Alignment(0, 0),
      child: name.isEmpty
          ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
          : Text(
              name[0],
              style: const TextStyle(
                  fontFamily: 'calligraphy',
                  fontSize: 45,
                  color: Colors.white,
                  shadows: [BoxShadow(color: Colors.black54, offset: Offset(2.0, 4.0), blurRadius: 10.0)],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
    ),
  );
}

/// 构造头像
Widget buildAvatar({Widget? avatar, required String name, Color color = Colors.blueAccent}) {
  return Container(
    width: 70,
    height: 70,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: avatar ?? buildDefaultAvatar(name, defaultColor: color),
  );
}

String calcLastSeen(DateTime? lastSeen) {
  var lastSeenText = '从未登录';
  if (lastSeen != null) {
    lastSeenText = '';
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inDays != 0) {
      lastSeenText += '${diff.inDays}天前';
    } else if (diff.inHours != 0) {
      lastSeenText += '${diff.inHours}小时前';
    } else if (diff.inMinutes != 0) {
      lastSeenText += '${diff.inDays}分钟前';
    } else {
      lastSeenText += '${diff.inSeconds}秒前';
    }
  }
  return lastSeenText;
}

/// 构建常用icon+文字样式
Widget buildInfoItemRow({
  required BuildContext context,
  required IconData iconData,
  required String text,
  double? fontSize,
  double? iconSize,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.5),
    child: Row(
      children: [
        Icon(
          iconData,
          color: Theme.of(context).primaryColor,
          size: iconSize ?? IconTheme.of(context).size,
        ),
        Expanded(
          child: Text(
            ' $text',
            style: TextStyle(
              color: Colors.black87,
              fontSize: fontSize ?? 14,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

extension Styles on Widget {
  Widget withTitleBarStyle(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1.0))]),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      child: this,
    );
  }

  Widget withOrangeBarStyle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
      alignment: const Alignment(-1, 0),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
      width: 200.w,
      child: this,
    );
  }
}
