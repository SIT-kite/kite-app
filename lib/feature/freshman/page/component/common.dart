import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/flash.dart';

import '../../entity.dart';
import 'basic_info.dart';

List<InfoItem> buildContactInfoItems(BuildContext context, Contact? contact) {
  return [
    if (![null, ''].contains(contact?.wechat))
      InfoItem(
        Icons.wechat,
        '微信',
        contact!.wechat!,
        onTap: () {
          Clipboard.setData(ClipboardData(text: contact.wechat!));
          showBasicFlash(context, const Text('已复制到剪切板'));
        },
      ),
    if (![null, ''].contains(contact?.qq))
      InfoItem(
        Icons.person,
        'QQ',
        contact!.qq!,
        onTap: () async {
          // 异步异常捕获， 已废用
          // runZonedGuarded<Future<void>>(() async {
          //   await GlobalLauncher.launchQqContact(contact.qq!);
          // }, (dynamic error, StackTrace stackTrace) {
          //   if (kDebugMode) {
          //     print(error);
          //   }
          //   Clipboard.setData(ClipboardData(text: contact.wechat!));
          //   showBasicFlash(context, const Text('已复制到剪切板'));
          // });
          if (!await GlobalLauncher.launchQqContact(contact.qq!)) {
            Clipboard.setData(ClipboardData(text: contact.qq!));
            showBasicFlash(context, const Text('已复制到剪切板'));
          }
        },
      ),
    if (![null, ''].contains(contact?.tel))
      InfoItem(
        Icons.phone,
        '电话号码',
        contact!.tel!,
        onTap: () async {
          if (!await GlobalLauncher.launchTel(contact.tel!)) {
            Clipboard.setData(ClipboardData(text: contact.tel!));
            showBasicFlash(context, const Text('已复制到剪切板'));
          }
        },
      ),
  ];
}

Widget buildListItemDefaultAvatar(BuildContext context, String name) {
  final TextStyle avatarStyle = Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]);

  return CircleAvatar(
    backgroundColor: Theme.of(context).primaryColor,
    radius: 20,
    child: Container(
        child: (name ?? '').isEmpty
            ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
            : Text(name[0], style: avatarStyle)),
  );
}

String calcLastSeen(DateTime? lastSeen) {
  var lastSeenText = '从未登录';
  if (lastSeen != null) {
    lastSeenText = '';
    final diff = DateTime.now().difference(lastSeen!);
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
