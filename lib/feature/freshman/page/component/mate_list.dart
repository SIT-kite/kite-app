import 'package:flutter/material.dart';

import '../../entity.dart';
import 'basic_info.dart';
import 'common.dart';

class MateListWidget extends StatefulWidget {
  final List<Mate> mateList;
  const MateListWidget(this.mateList, {Key? key}) : super(key: key);

  @override
  State<MateListWidget> createState() => _MateListWidgetState();
}

class _MateListWidgetState extends State<MateListWidget> {
  Widget buildListItem(Mate mate) {
    final lastSeenText = calcLastSeen(mate.lastSeen);
    return ListTile(
      leading: buildListItemDefaultAvatar(context, mate.name),
      title: Text(mate.name),
      subtitle: Text('上次登录时间: $lastSeenText'),
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
              ...buildContactInfoItems(context, mate.contact), // unpack
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
        Text('总计人数(不包含自己): ${mateList.length}'),
        Expanded(child: buildListView(mateList)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(widget.mateList);
  }
}
