import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/flash.dart';

import '../../entity.dart';
import 'basic_info.dart';

class MateListWidget extends StatefulWidget {
  final List<Mate> mateList;
  const MateListWidget(this.mateList, {Key? key}) : super(key: key);

  @override
  State<MateListWidget> createState() => _MateListWidgetState();
}

class _MateListWidgetState extends State<MateListWidget> {
  List<InfoItem> buildInfoItems(Mate mate) {
    return [
      if (![null, ''].contains(mate.contact?.wechat))
        InfoItem(
          Icons.wechat,
          '微信',
          mate.contact!.wechat!,
          onTap: () {
            Clipboard.setData(ClipboardData(text: mate.contact!.wechat!));
            showBasicFlash(context, const Text('已复制到剪切板'));
          },
        ),
      if (![null, ''].contains(mate.contact?.qq))
        InfoItem(
          Icons.person,
          'QQ',
          mate.contact!.qq!,
          onTap: () async {
            if (!await GlobalLauncher.launchQqContact(mate.contact!.qq!)) {
              Clipboard.setData(ClipboardData(text: mate.contact!.wechat!));
              showBasicFlash(context, const Text('已复制到剪切板'));
            }
          },
        ),
      if (![null, ''].contains(mate.contact?.tel))
        InfoItem(
          Icons.phone,
          '电话号码',
          mate.contact!.tel!,
          onTap: () async {
            if (!await GlobalLauncher.launchTel(mate.contact!.tel!)) {
              Clipboard.setData(ClipboardData(text: mate.contact!.wechat!));
              showBasicFlash(context, const Text('已复制到剪切板'));
            }
          },
        ),
    ];
  }

  Widget buildDefaultAvatar(String name) {
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

  Widget buildListItem(Mate mate) {
    final lastSeenText = mate.lastSeen != null ? DateFormat("yyyy-MM-dd hh:mm").format(mate.lastSeen!) : "从未登录";
    return ListTile(
      // 网络图片加载有些问题
      // leading: mate.avatar == null
      //     ? buildDefaultAvatar(mate.name)
      //     : Image.network(
      //         mate.avatar!,
      //         height: 40,
      //         width: 40,
      //         errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      //           return buildDefaultAvatar(mate.name);
      //         },
      //       ),
      leading: buildDefaultAvatar(mate.name),
      title: Text(mate.name),
      subtitle: Text('上次登陆时间: $lastSeenText'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return BasicInfoPageWidget(
            name: mate.name,
            college: mate.college,
            infoItems: [
              InfoItem(Icons.account_circle, "姓名", mate.name),
              InfoItem(Icons.school, "学院", mate.college),
              InfoItem(Icons.emoji_objects, "专业", mate.major),
              InfoItem(Icons.night_shelter, "宿舍楼", mate.building),
              InfoItem(Icons.room, "寝室", '${mate.room}-${mate.bed}'),
              InfoItem(Icons.person, "性别", mate.gender == 'M' ? '男' : '女'),
              if (mate.province != null) InfoItem(Icons.location_city, '省份', mate.province!),
              if (mate.lastSeen != null) InfoItem(Icons.location_city, '上次登录时间', lastSeenText),
              ...buildInfoItems(mate), // unpack
            ],
          );
        }));
      },
    );
  }

  Widget buildListView(List<Mate> list) {
    return ListView(
      children: list.map((e) {
        return Column(
          children: [
            buildListItem(e),
            const Divider(height: 1.0),
          ],
        );
      }).toList(),
    );
  }

  Widget buildBody(List<Mate> mateList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('总计人数：${mateList.length}'),
        Expanded(child: buildListView(mateList)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(widget.mateList);
  }
}
