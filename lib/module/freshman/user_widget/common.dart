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
import 'package:kite/l10n/extension.dart';
import 'package:kite/launcher.dart';
import 'package:kite/module/freshman/using.dart';
import 'package:kite/route.dart';
import 'package:kite/util/dsl.dart';
import 'package:kite/util/flash.dart';

import '../entity/info.dart';
import 'profile.dart';

List<InfoItem> buildContactInfoItems(BuildContext ctx, Contact? contact, {String? counselorTel}) {
  final wechat = contact?.wechat;
  final qq = contact?.qq;
  final tel = contact?.tel;
  return [
    if (counselorTel != null && counselorTel.isNotEmpty)
      InfoItem(
        Icons.phone_in_talk,
        i18n.counselorPhoneNumber,
        counselorTel,
        onTap: () async {
          if (!await GlobalLauncher.launchTel(counselorTel)) {
            Clipboard.setData(ClipboardData(text: counselorTel));
            showBasicFlash(ctx, i18n.cantLaunchPhoneSoNumber2ClipboardTip.txt);
          }
        },
        trailIconData: Icons.phone,
      ),
    if (wechat != null && wechat.isNotEmpty)
      InfoItem(
        Icons.wechat,
        i18n.wechat,
        wechat,
        onTap: () {
          Clipboard.setData(ClipboardData(text: wechat));
          showBasicFlash(ctx, i18n.cantLaunchWechatSoNumber2ClipboardTip.txt);
        },
        trailIconData: Icons.copy,
      ),
    if (qq != null && qq.isNotEmpty)
      InfoItem(
        Icons.person,
        i18n.qq,
        qq,
        onTap: () async {
          if (!await GlobalLauncher.launchQqContact(qq)) {
            Clipboard.setData(ClipboardData(text: qq));
            showBasicFlash(ctx, i18n.cantLaunchQqSoNumber2ClipboardTip.txt);
          }
        },
        trailIconData: Icons.open_in_browser,
      ),
    if (tel != null && tel.isNotEmpty)
      InfoItem(
        Icons.phone,
        i18n.phoneNumber,
        tel,
        onTap: () async {
          if (!await GlobalLauncher.launchTel(tel)) {
            Clipboard.setData(ClipboardData(text: tel));
            showBasicFlash(ctx, i18n.cantLaunchPhoneSoNumber2ClipboardTip.txt);
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
Widget buildDefaultAvatar(BuildContext ctx, String name) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, color: ctx.themeColor),
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
Widget buildAvatar(BuildContext ctx, {Widget? avatar, required String name}) {
  return Container(
    width: 70,
    height: 70,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: avatar ?? buildDefaultAvatar(ctx, name),
  );
}

String calcLastSeen(DateTime? lastSeen) {
  // TODO: A potential time zone bug is here.
  var lastSeenText = i18n.noOnlineRecords;
  if (lastSeen != null) {
    lastSeenText = '';
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inDays > 0) {
      // handle with plural
      lastSeenText += '${diff.inDays}天前';
    } else if (diff.inHours > 0) {
      lastSeenText += '${diff.inHours}小时前';
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
          color: Theme.of(context).colorScheme.onPrimary,
          size: iconSize ?? IconTheme.of(context).size,
        ),
        Expanded(
          child: Text(
            ' $text',
            style: TextStyle(
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
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      child: this,
    );
  }

  Widget withOrangeBarStyle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
      alignment: const Alignment(-1, 0),
      width: 200.w,
      child: this,
    );
  }
}

/// 构建菜单按钮
List<Widget> buildAppBarMenuButton(BuildContext context) {
  return <Widget>[
    IconButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteTable.freshmanAnalysis),
      icon: const Icon(Icons.analytics),
      tooltip: i18n.kiteStatsBtnTooltip,
    ),
    IconButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteTable.freshmanUpdate),
      icon: const Icon(Icons.menu),
      tooltip: i18n.personalInfoSettingBtnTooltip,
    )
  ];
}
