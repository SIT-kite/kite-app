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
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/dsl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../launch.dart';
import '../../../util/flash.dart';
import '../entity/info.dart';
import '../init.dart';
import '../user_widget/common.dart';
import '../user_widget/profile.dart';

class FreshmanPage extends StatelessWidget {
  FreshmanPage({Key? key}) : super(key: key);

  final freshmanDao = FreshmanInit.freshmanDao;
  final freshmanCacheManager = FreshmanInit.freshmanCacheManager;
  final refreshController = RefreshController();
  final myFutureBuilderController = MyFutureBuilderController();
  final freshmanCacheDao = FreshmanInit.freshmanCacheDao;

  void showFirstDialog(BuildContext context) {
    if (!(freshmanCacheDao.disableFirstEnterDialogState ?? false)) {
      showAlertDialog(context, title: i18n.addInfoTitle, content: [
        i18n.addInfoRequest.txt
      ], actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: i18n.yes.txt),
        TextButton(onPressed: () {}, child: i18n.dontShowThisAgainBtn.txt),
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
      futureGetter: () async {
        return await freshmanDao.getInfo();
      },
      enablePullRefresh: true,
      onPreRefresh: () async {
        // 刷新前执行的逻辑
        freshmanCacheManager.clearBasicInfo(); // 先清空本地数据
      },
      builder: (context, data) {
        return _buildBody(context, data);
      },
    );
  }

  Widget _buildBody(BuildContext ctx, FreshmanInfo data) {
    return BasicInfoPageWidget(
      name: data.name,
      college: data.college,
      infoItems: [
        InfoItem(Icons.badge, i18n.studentID, data.studentId),
        InfoItem(Icons.emoji_objects, i18n.major, data.major),
        InfoItem(Icons.corporate_fare, i18n.dormitory,
            i18n.dormitoryDetailed_bbcr(data.room, data.bed, data.building, data.campus)),
        InfoItem(Icons.face, i18n.counselor, data.counselorName),
        ...buildContactInfoItems(ctx, data.contact, counselorTel: data.counselorTel),
      ],
      appBarActions: buildAppBarMenuButton(ctx),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person),
        onPressed: () => Navigator.of(ctx).pushNamed(RouteTable.freshmanFriend),
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
