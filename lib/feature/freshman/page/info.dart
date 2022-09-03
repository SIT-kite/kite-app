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
import 'package:flutter/services.dart';
import 'package:kite/feature/freshman/page/component/profile.dart';
import 'package:kite/route.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../component/future_builder.dart';
import '../../../launch.dart';
import '../../../util/flash.dart';
import '../entity.dart';
import '../init.dart';
import 'component/common.dart';

class FreshmanPage extends StatelessWidget {
  FreshmanPage({Key? key}) : super(key: key);

  final freshmanDao = FreshmanInitializer.freshmanDao;
  final freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;
  final refreshController = RefreshController();
  final myFutureBuilderController = MyFutureBuilderController();
  final freshmanCacheDao = FreshmanInitializer.freshmanCacheDao;

  void showFirstDialog(BuildContext context) {
    if (!(freshmanCacheDao.disableFirstEnterDialogState ?? false)) {
      showAlertDialog(context, title: '补充资料', content: [
        const Text('是否补充个人资料？')
      ], actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: const Text('补充信息')),
        TextButton(onPressed: () {}, child: const Text('不再提示')),
      ]).then((select) {
        if (select == 0) {
          Navigator.of(context).pushNamed(RouteTable.freshmanUpdate);
        } else if (select == 1) {
          freshmanCacheDao.disableFirstEnterDialogState = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showFirstDialog(context));
    return MyFutureBuilder<FreshmanInfo>(
      controller: myFutureBuilderController,
      future: freshmanDao.getInfo(),
      enablePullRefresh: true,
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
        InfoItem(Icons.badge, '学号', data.studentId),
        InfoItem(Icons.emoji_objects, '专业', data.major),
        InfoItem(Icons.corporate_fare, '宿舍', '${data.campus} ${data.building}${data.room}-${data.bed}'),
        InfoItem(Icons.face, '辅导员', data.counselorName),
        ...buildContactInfoItems(context, data.contact, counselorTel: data.counselorTel),
      ],
      appBarActions: buildAppBarMenuButton(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person),
        onPressed: () => Navigator.of(context).pushNamed(RouteTable.freshmanFriend),
      ),
    );
  }

  ///联系方式跳转
  launcherOnTap(BuildContext context, {required String contact, required String tips}) async {
    if (!await GlobalLauncher.launch(contact)) {
      Clipboard.setData(ClipboardData(text: contact));
      showBasicFlash(context, Text(tips));
    }
  }
}
