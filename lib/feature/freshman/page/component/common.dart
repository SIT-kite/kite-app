import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/flash.dart';

import '../../entity.dart';
import 'basic_info.dart';

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
          showBasicFlash(context, const Text('已复制到剪切板'));
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
            showBasicFlash(context, const Text('已复制到剪切板'));
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
            showBasicFlash(context, const Text('已复制到剪切板'));
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
Widget buildDefaultAvatar(String name) {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color.fromARGB(255, 3, 99, 172), Color.fromARGB(255, 150, 97, 217)],
        end: Alignment.topCenter,
        begin: Alignment.bottomCenter,
      ),
      boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(5.0, 5.0), blurRadius: 4.0)],
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
Widget buildAvatar({Widget? avatar, required String name}) {
  return Container(
    width: 70,
    height: 70,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: avatar ?? buildDefaultAvatar(name),
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

/// 构建标题
Widget buildTitle(List<Mate> mateList, String title, IconData iconData, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.blueAccent,
      boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 2.0), blurRadius: 4.0)],
    ),
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(5),
    child: buildMateItemRow(iconData: iconData, title: title, text: '', context: context),
  );
}

/// 构建常用icon+文字样式
Widget buildMateItemRow({
  required BuildContext context,
  required IconData iconData,
  required String title,
  required String text,
  double? fontSize,
  double? iconSize,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: iconSize ?? IconTheme.of(context).size,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize ?? 15),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize ?? 15),
        )
      ],
    ),
  );
}
