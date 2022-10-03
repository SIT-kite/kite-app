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
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/module/freshman/cache.dart';
import 'package:kite/l10n/extension.dart';

import '../../dao/Freshman.dart';
import '../../entity/info.dart';
import '../../entity/relationship.dart';
import '../../init.dart';
import '../../user_widget/common.dart';
import '../../user_widget/mate_list.dart';

class RoommateWidget extends StatefulWidget {
  const RoommateWidget({Key? key}) : super(key: key);

  @override
  State<RoommateWidget> createState() => _RoommateWidgetState();
}

class _RoommateWidgetState extends State<RoommateWidget> {
  final FreshmanDao freshmanDao = FreshmanInit.freshmanDao;
  final FreshmanCacheManager freshmanCacheManager = FreshmanInit.freshmanCacheManager;

  void onRefresh() {
    freshmanCacheManager.clearRoommates();
    setState(() {});
  }

  Widget buildBody(List<Mate> mateList, FreshmanInfo myInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInfoItemRow(
          iconData: Icons.home,
          text:
              '${i18n.currentDormitoryLabel}:  ${i18n.dormitoryDetailed_bcr(myInfo.room, myInfo.building, myInfo.campus)}',
          context: context,
        ).withTitleBarStyle(context),
        Expanded(child: MateListWidget(mateList, callBack: onRefresh, showDormitory: false)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<List<dynamic>>(
      future: Future.wait([freshmanDao.getRoommates(), freshmanDao.getInfo()]),
      builder: (context, data) {
        return buildBody(data[0], data[1]);
      },
    );
  }
}
