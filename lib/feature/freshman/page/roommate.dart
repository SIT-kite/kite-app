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
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/freshman/cache.dart';
import 'package:kite/feature/freshman/page/component/common.dart';

import '../dao.dart';
import '../entity.dart';
import '../init.dart';
import 'component/mate_list.dart';

class RoommateWidget extends StatefulWidget {
  const RoommateWidget({Key? key}) : super(key: key);

  @override
  State<RoommateWidget> createState() => _RoommateWidgetState();
}

class _RoommateWidgetState extends State<RoommateWidget> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;

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
          text: '当前宿舍：${myInfo.campus}-${myInfo.building}-${myInfo.room}',
          context: context,
        ).withTitleBarStyle(context),
        Expanded(child: MateListWidget(mateList, callBack: onRefresh)),
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
