import 'package:flutter/material.dart';
import 'package:kite/feature/freshman/page/component/basic_info.dart';

import '../../../component/future_builder.dart';
import '../dao.dart';
import '../entity.dart';
import '../init.dart';

class FreshmanInfoPage extends StatefulWidget {
  const FreshmanInfoPage({Key? key}) : super(key: key);

  @override
  State<FreshmanInfoPage> createState() => _FreshmanInfoPageState();
}

class _FreshmanInfoPageState extends State<FreshmanInfoPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return MyFutureBuilder<FreshmanInfo>(
        future: freshmanDao.getInfo(),
        builder: (context, data) {
          return BasicInfoPageWidget(
            name: data.name,
            college: data.college,
            infoItems: [
              InfoItem(Icons.account_circle, data.name, "姓名"),
              InfoItem(Icons.badge, data.studentId, "学号"),
              InfoItem(Icons.school, data.college, "学院"),
              InfoItem(Icons.emoji_objects, data.major, "专业"),
              InfoItem(Icons.corporate_fare, data.campus, "校区"),
              InfoItem(Icons.night_shelter, data.building, "宿舍楼"),
              InfoItem(Icons.room, '${data.room}-${data.bed}', "寝室"),
              InfoItem(Icons.face, data.counselorName, "辅导员姓名"),
              InfoItem(Icons.phone_in_talk, data.counselorTel, "辅导员联系方式"),
            ],
          );
        });
  }
}
