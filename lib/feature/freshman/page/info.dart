import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kite/route.dart';

import '../../../component/future_builder.dart';
import '../dao.dart';
import '../entity.dart';
import '../init.dart';

//todo 进一步抽离组件，添加联系方式信息修改

class FreshmanInfoPage extends StatefulWidget {
  const FreshmanInfoPage({Key? key}) : super(key: key);

  @override
  State<FreshmanInfoPage> createState() => _FreshmanInfoPageState();
}

class _FreshmanInfoPageState extends State<FreshmanInfoPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  final double bgHeight = 250;

  List<InfoItem> list = [
    InfoItem(Icons.person, "姓名", "info.name", false),
    InfoItem(Icons.person, "姓名", "info.name", false)
  ];

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return MyFutureBuilder<FreshmanInfo>(
        future: freshmanDao.getInfo(),
        builder: (context, data) {
          list = buildList(data);
          return _buildBackGround(data, list);
        });
  }

  Widget _buildBackGround(FreshmanInfo info, List<InfoItem> list) {
    return Stack(
        alignment: AlignmentDirectional.center,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
        children: [
          //上背景
          Column(
            children: [
              Container(
                height: bgHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark]),
                ),
              ),
            ],
          ),

          //下背景
          Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white,
              )),

          //列表
          Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                body: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(list[index]);
                  },
                ),
              )),

          //头像，以后可以加载用户头像，如果有的话
          Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: const Alignment(0.9, -1.2),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage("assets/library/saying.png"), fit: BoxFit.cover)),
                ),
              )),

          //背景文字
          Positioned(
            top: bgHeight - 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.white, fontSize: 30, decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${info.college}新生',
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: CupertinoColors.white, fontSize: 16, decoration: TextDecoration.none),
                )
              ],
            ),
          ),
          //返回按钮
          Positioned(
              left: 24,
              top: 54,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, RouteTable.freshman);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.keyboard_double_arrow_left_sharp,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  ))),
        ]);
  }

  Widget _buildItem(InfoItem infoItem) {
    return ListTile(
      textColor: Colors.black,
      leading: SizedBox(
          width: 45,
          height: 45,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                infoItem.iconData,
                color: Colors.white,
                size: 35,
              ),
            ),
          )),
      title: Text(infoItem.title),
      subtitle: Text(infoItem.subTitle),
      trailing: infoItem.editAble == false
          ? const Icon(Icons.edit_off)
          : const Icon(
              Icons.edit,
              color: Colors.deepOrange,
            ),
    );
  }

  List<InfoItem> buildList(FreshmanInfo info) {
    List<InfoItem> list = [
      InfoItem(Icons.account_circle, info.name, "姓名", false),
      InfoItem(Icons.badge, info.studentId, "学号", false),
      InfoItem(Icons.school, info.college, "学院", false),
      InfoItem(Icons.emoji_objects, info.major, "专业", false),
      InfoItem(Icons.corporate_fare, info.campus, "校区", false),
      InfoItem(Icons.night_shelter, info.building, "宿舍楼", false),
      InfoItem(Icons.king_bed, '${info.room}-${info.bed}', "寝室", false),
      InfoItem(Icons.face, info.counselorName, "辅导员姓名", false),
      InfoItem(Icons.phone_in_talk, info.counselorTel, "辅导员联系方式", false),
      InfoItem(Icons.wechat, "*********", "你的联系方式", true),
      InfoItem(Icons.remove_red_eye, info.visible.toString(), "同城可见", true),
    ];
    return list;
  }
}

class InfoItem {
  IconData iconData = Icons.person;
  String title = '';
  String subTitle = '';
  bool editAble = false;
  InfoItem(this.iconData, this.title, this.subTitle, this.editAble);
}
