import 'package:flutter/material.dart';

import '../../entity.dart';
import 'basic_info.dart';
import 'common.dart';

class FamiliarListWidget extends StatefulWidget {
  final List<Familiar> familiarList;
  const FamiliarListWidget(this.familiarList, {Key? key}) : super(key: key);

  @override
  State<FamiliarListWidget> createState() => _FamiliarListWidgetState();
}

class _FamiliarListWidgetState extends State<FamiliarListWidget> {
  Widget buildListItem(Familiar familiar) {
    final lastSeenText = calcLastSeen(familiar.lastSeen);
    return ListTile(
      leading: buildListItemDefaultAvatar(context, familiar.name),
      title: Text(familiar.name),
      subtitle: Text('上次登录时间: $lastSeenText'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return BasicInfoPageWidget(
            name: familiar.name,
            college: familiar.college,
            infoItems: [
              InfoItem(Icons.account_circle, "姓名", familiar.name),
              InfoItem(Icons.school, "学院", familiar.college),
              InfoItem(Icons.person, "性别", familiar.gender == 'M' ? '男' : '女'),
              if (familiar.city != null) InfoItem(Icons.location_city, "城市", familiar.city!),
              if (familiar.lastSeen != null) InfoItem(Icons.timelapse, '上次登录时间', lastSeenText),
              ...buildContactInfoItems(context, familiar.contact), // unpack
            ],
          );
        }));
      },
    );
  }

  Widget buildListView(List<Familiar> list) {
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

  Widget buildBody(List<Familiar> familiarList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('总计人数(不包含自己): ${familiarList.length}'),
        Expanded(child: buildListView(familiarList)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(widget.familiarList);
  }
}
