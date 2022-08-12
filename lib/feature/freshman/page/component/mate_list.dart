import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/feature/freshman/page/component/card.dart';

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
  // 打开更多页
  void loadMoreInfo(Mate mate) {
    final lastSeenText = calcLastSeen(mate.lastSeen);
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return BasicInfoPageWidget(
        name: mate.name,
        college: mate.college,
        infoItems: [
          InfoItem(Icons.account_circle, "姓名", mate.name),
          InfoItem(Icons.school, "学院", mate.college),
          InfoItem(Icons.emoji_objects, "专业", mate.major),
          InfoItem(Icons.night_shelter, "宿舍楼", mate.building),
          InfoItem(Icons.bed, "寝室", '${mate.room}-${mate.bed}'),
          InfoItem(mate.gender == 'M' ? Icons.male : Icons.female, "性别", mate.gender == 'M' ? '男' : '女'),
          if (mate.province != null) InfoItem(Icons.location_city, '省份', mate.province!),
          if (mate.lastSeen != null) InfoItem(Icons.location_city, '上次登录时间', lastSeenText),
          ...buildContactInfoItems(context, mate.contact), // unpack
        ],
      );
    }));
  }

  Widget buildBasicInfoWidget(Mate mate) {
    final wechat = mate.contact?.wechat;
    final qq = mate.contact?.qq;
    final tel = mate.contact?.tel;
    final wechatRow = buildMateItemRow(
      iconData: Icons.wechat,
      title: '微信号:  ',
      text: wechat != null && wechat != '' ? wechat : '未填写',
      context: context,
    );
    final qqRow = buildMateItemRow(
      iconData: Icons.person,
      title: 'QQ:  ',
      text: qq != null && qq != '' ? qq : '未填写',
      context: context,
    );
    final telRow = buildMateItemRow(
      iconData: Icons.phone,
      title: '手机号:  ',
      text: tel != null && tel != '' ? tel : '未填写',
      context: context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mate.name,
          style: const TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8.h,
        ),
        buildMateItemRow(
          iconData: Icons.school,
          title: "学院:  ",
          text: mate.college,
          context: context,
        ),
        buildMateItemRow(
          iconData: Icons.emoji_objects,
          title: "专业:  ",
          text: mate.major,
          context: context,
        ),
        buildMateItemRow(
          iconData: Icons.home,
          title: "寝室:  ",
          text: '${mate.building}${mate.bed}号床',
          context: context,
        ),
        wechatRow,
        qqRow,
        telRow,
      ],
    );
  }

  Widget buildLastSeenWidget(DateTime? lastSeen) {
    final lastSeenText = calcLastSeen(lastSeen);

    return buildMateItemRow(
      iconData: Icons.timelapse,
      title: ' ',
      text: "$lastSeenText在线",
      fontSize: 14,
      iconSize: 20,
      context: context,
    );
  }

  // 构造城市显示组件
  Widget buildLocationWidget(Mate mate) {
    if (mate.province != null) {
      return buildMateItemRow(
        iconData: Icons.room,
        title: '',
        text: mate.province!,
        fontSize: 14,
        iconSize: 20,
        context: context,
      );
    } else {
      return buildMateItemRow(
        iconData: Icons.room,
        title: ' ',
        text: '在宇宙漫游哦',
        fontSize: 13,
        iconSize: 17,
        context: context,
      );
    }
  }

  Widget buildListView(List<Mate> list) {
    return ListView(
      children: list.map((e) {
        return PersonItemCardWidget(
          basicInfoWidget: buildBasicInfoWidget(e),
          name: e.name,
          isMale: e.gender == 'M',
          lastSeenWidget: buildLastSeenWidget(e.lastSeen),
          locationWidget: buildLocationWidget(e),
          onLoadMore: () => loadMoreInfo(e),
        );
      }).toList(),
    );
  }

  Widget buildBody(List<Mate> mateList) {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.blueAccent,
                boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 2.0), blurRadius: 4.0)]),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            child: buildMateItemRow(
                iconData: Icons.info, title: '总计人数(不包含自己): ${mateList.length}', text: '', context: context)),
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8), child: buildListView(mateList))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(widget.mateList);
  }
}
