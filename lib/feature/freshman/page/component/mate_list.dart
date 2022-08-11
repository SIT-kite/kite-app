import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          //卡片
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark]), //背景渐变
                  borderRadius: BorderRadius.circular(15.0), //像素圆角
                  boxShadow: const [
                    //阴影
                    BoxShadow(color: Colors.black54, offset: Offset(7.0, 7.0), blurRadius: 4.0)
                  ]),
              child: SizedBox(
                  height: 270,
                  width: MediaQuery.of(context).size.width - 20.w,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 22,
                        child: Stack(children: [
                          Align(
                            alignment: const Alignment(0, -0.7),
                            child: buildAvatar(name: mate.name),
                          ),
                          Positioned(
                            top: 120,
                            left: 0,
                            child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                alignment: const Alignment(-1, 0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
                                ),
                                child: buildMateItemRow(
                                    iconData: Icons.timelapse,
                                    title: ' ',
                                    text: "$lastSeenText在线",
                                    fonSize: 14,
                                    iconSize: 20,
                                    context: context)),
                          ),
                          Positioned(
                            top: 165,
                            left: 0,
                            child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                                alignment: const Alignment(-1, 0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
                                ),
                                child: mate.province != null
                                    ? buildMateItemRow(
                                        iconData: Icons.room,
                                        title: '',
                                        text: mate.province!,
                                        fonSize: 14,
                                        iconSize: 20,
                                        context: context)
                                    : buildMateItemRow(
                                        iconData: Icons.room,
                                        title: ' ',
                                        text: '在宇宙漫游哦',
                                        fonSize: 13,
                                        iconSize: 17,
                                        context: context)),
                          )
                        ]),
                      ),
                      Expanded(
                        flex: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
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
                                  iconData: Icons.school, title: "学院:  ", text: mate.college, context: context),
                              buildMateItemRow(
                                  iconData: Icons.emoji_objects, title: "专业:  ", text: mate.major, context: context),
                              buildMateItemRow(
                                  iconData: Icons.home,
                                  title: "寝室:  ",
                                  text: '${mate.building}${mate.bed}号床',
                                  context: context),
                              ![null, ''].contains(mate.contact?.wechat)
                                  ? buildMateItemRow(
                                      iconData: Icons.wechat,
                                      title: '微信号:  ',
                                      text: mate.contact!.wechat!.toString()!,
                                      context: context)
                                  : buildMateItemRow(
                                      iconData: Icons.wechat, title: '微信号:  ', text: '未填写', context: context),
                              ![null, ''].contains(mate.contact?.wechat)
                                  ? buildMateItemRow(
                                      iconData: Icons.person,
                                      title: 'QQ:  ',
                                      text: mate.contact!.qq!.toString()!,
                                      context: context)
                                  : buildMateItemRow(
                                      iconData: Icons.person, title: 'QQ:  ', text: '未填写', context: context),
                              ![null, ''].contains(mate.contact?.tel)
                                  ? buildMateItemRow(
                                      iconData: Icons.phone,
                                      title: '手机号码:  ',
                                      text: mate.contact!.tel!.toString()!,
                                      context: context)
                                  : buildMateItemRow(
                                      iconData: Icons.phone, title: '手机号码:  ', text: '未填写', context: context),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))),
        ),
        Positioned(
            top: 5.h,
            right: 0,
            width: 110.w,
            child: GestureDetector(
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
                      InfoItem(Icons.bed, "寝室", '${mate.room}-${mate.bed}'),
                      InfoItem(mate.gender == 'M' ? Icons.male : Icons.female, "性别", mate.gender == 'M' ? '男' : '女'),
                      if (mate.province != null) InfoItem(Icons.location_city, '省份', mate.province!),
                      if (mate.lastSeen != null) InfoItem(Icons.location_city, '上次登录时间', lastSeenText),
                      ...buildContactInfoItems(context, mate.contact), // unpack
                    ],
                  );
                }));
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(5.0)), //像素圆角
                    boxShadow: const [
                      //阴影
                      BoxShadow(color: Colors.black54, offset: Offset(7.0, 7.0), blurRadius: 4.0)
                    ]),
                child:
                    (buildMateItemRow(iconData: Icons.send, title: ' ', text: '更多信息', fonSize: 20, context: context)),
              ),
            ))
      ],
    );
  }

  Widget buildListView(List<Mate> list) {
    return ListView(
      children: list.map((e) {
        return Column(
          children: [
            buildListItem(e),
            // const Divider(height: 1.0),
          ],
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
