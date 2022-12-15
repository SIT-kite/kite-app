/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';

import '../entity/message.dart';
import '../page/browser.dart';
import '../using.dart';

class Mail extends StatelessWidget {
  final ApplicationMsg msg;

  const Mail({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(msg.name),
      subtitle: Text('${i18n.applicationMailboxRecent}: ${msg.recentStep}'),
      trailing: Text(msg.status),
      onTap: () {
        // 跳转到详情页面
        final String resultUrl =
            'https://xgfy.sit.edu.cn/unifri-flow/WF/mobile/index.html?ismobile=1&FK_Flow=${msg.functionId}&WorkID=${msg.flowId}&IsReadonly=1&IsView=1';
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => InAppViewPage(title: msg.name, url: resultUrl)));
      },
    );
  }
}
