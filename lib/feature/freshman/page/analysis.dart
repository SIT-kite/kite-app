import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/freshman/entity.dart';

import '../dao.dart';
import '../init.dart';
import 'component/basic_info.dart';

class FreshmanAnalysisPage extends StatefulWidget {
  const FreshmanAnalysisPage({Key? key}) : super(key: key);

  @override
  State<FreshmanAnalysisPage> createState() => _FreshmanAnalysisPageState();
}

class _FreshmanAnalysisPageState extends State<FreshmanAnalysisPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyFutureBuilder<List<dynamic>>(
        future: Future.wait([freshmanDao.getAnalysis(), freshmanDao.getInfo()]),
        builder: (context, data) {
          return _buildBody(context, data[0], data[1]);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Analysis data, FreshmanInfo info) {
    return BasicInfoPageWidget(
      name: info.name,
      college: info.college,
      infoItems: [
        InfoItem(Icons.person, "同名人数", '${data.sameName} 人'),
        if (data.sameCity != -1) InfoItem(Icons.location_city, "来自同一个城市的人数", '${data.sameCity} 人'),
        if (data.sameHighSchool != -1) InfoItem(Icons.school, "来自同一个高中的人数", '${data.sameHighSchool} 人'),
        InfoItem(Icons.school, "学院总人数", '${data.collegeCount} 人'),
        InfoItem(Icons.school, "专业总人数", '${data.major.total} 人'),
        InfoItem(Icons.male, "专业男生人数", '${data.major.boys} 人'),
        InfoItem(Icons.female, "专业女生人数", '${data.major.girls} 人'),
      ],
    );
  }
}
