/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
    return MyFutureBuilder<FreshmanInfo>(
      future: freshmanDao.getInfo(),
      builder: (context, data) {
        return _buildBody(context, data);
      },
    );
  }

  Widget _buildBody(BuildContext context, FreshmanInfo data) {
    return BasicInfoPageWidget(
      name: data.name,
      college: data.college,
      infoItems: [
        InfoItem(Icons.account_circle, "姓名", data.name),
        InfoItem(Icons.badge, "学号", data.studentId),
        InfoItem(Icons.school, "学院", data.college),
        InfoItem(Icons.emoji_objects, "专业", data.major),
        InfoItem(Icons.corporate_fare, "校区", data.campus),
        InfoItem(Icons.night_shelter, "宿舍楼", data.building),
        InfoItem(Icons.room, "寝室", '${data.room}室${data.bed}床'),
        InfoItem(Icons.face, "辅导员姓名", data.counselorName),
        InfoItem(Icons.phone_in_talk, "辅导员联系方式", data.counselorTel),
        if (![null, ''].contains(data.contact?.wechat)) InfoItem(Icons.wechat, '微信', data.contact!.wechat!),
        if (![null, ''].contains(data.contact?.qq)) InfoItem(Icons.person, 'QQ', data.contact!.qq!),
        if (![null, ''].contains(data.contact?.tel)) InfoItem(Icons.phone, '电话号码', data.contact!.tel!),
      ],
    );
  }
}
