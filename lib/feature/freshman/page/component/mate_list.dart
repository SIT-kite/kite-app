import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/util/alert_dialog.dart';

import '../../entity.dart';

class MateListWidget extends StatefulWidget {
  final List<Mate> mateList;
  const MateListWidget(this.mateList, {Key? key}) : super(key: key);

  @override
  State<MateListWidget> createState() => _MateListWidgetState();
}

class _MateListWidgetState extends State<MateListWidget> {
  Widget buildListItem(Mate mate) {
    final TextStyle avatarStyle = Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 20,
        child: Container(
            child: (mate.name ?? '').isEmpty
                ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                : Text(mate.name![0], style: avatarStyle)),
      ),
      title: Text(mate.name),
      subtitle: Text(mate.lastSeen != null ? DateFormat("上次登陆时间：yyyy-MM-dd hh:mm").format(mate.lastSeen!) : "从未登录"),
      onTap: () {
        // 展示对话框显示更多信息
        showAlertDialog(context, title: mate.name, content: [
          Text(mate.toString()),
        ], actionWidgetList: [
          TextButton(onPressed: () {}, child: const Text('关闭对话框')),
        ]);
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
