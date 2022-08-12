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
    final wechatRow = buildInfoItemRow(
      iconData: Icons.wechat,
      text: ' 微信号:  ${wechat != null && wechat != '' ? wechat : '未填写'}',
      context: context,
    );
    final qqRow = buildInfoItemRow(
      iconData: Icons.person,
      text: 'QQ:  ${qq != null && qq != '' ? qq : '未填写'}',
      context: context,
    );
    final telRow = buildInfoItemRow(
      iconData: Icons.phone,
      text: '手机号:  ${tel != null && tel != '' ? tel : '未填写'}',
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
        buildInfoItemRow(
          iconData: Icons.school,
          text: "学院:  ${mate.college}",
          context: context,
        ),
        buildInfoItemRow(
          iconData: Icons.emoji_objects,
          text: "专业:  ${mate.major}",
          context: context,
        ),
        buildInfoItemRow(
          iconData: Icons.home,
          text: "寝室:  ${mate.building}${mate.bed}号床",
          context: context,
        ),
        wechatRow,
        qqRow,
        telRow,
      ],
    );
  }

  Widget buildListView(List<Mate> list) {
    return ListView(
      children: list.map((e) {
        return PersonItemCardWidget(
          basicInfoWidget: buildBasicInfoWidget(e),
          name: e.name,
          isMale: e.gender == 'M',
          lastSeenText: calcLastSeen(e.lastSeen),
          locationText: e.province,
          onLoadMore: () => loadMoreInfo(e),
          height: 270,
        );
      }).toList(),
    );
  }

  Widget buildBody(List<Mate> mateList) {
    return Column(
      children: [
        buildInfoItemRow(
          iconData: Icons.info,
          text: '总计人数(不包含自己): ${mateList.length}',
          context: context,
        ).withTitleBarStyle(context),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: buildListView(mateList),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(widget.mateList);
  }
}
