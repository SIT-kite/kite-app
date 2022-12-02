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
import '../using.dart';

class BbsPage extends StatelessWidget {
  const BbsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userType = AccountUtils.getUserType();
    final isFreshman = userType == UserType.freshman;

    String? openid;
    String? nickname;
    if (isFreshman) {
      openid = Kv.freshman.freshmanAccount;
      nickname = Kv.freshman.freshmanName;
    } else {
      openid = Kv.auth.currentUsername;
      nickname = Kv.auth.personName;
    }
    if (nickname != null) {
      if (userType == UserType.teacher) {
        // TODO: Change this behavior?
        /// No i18n, the name will be shown outside
        nickname = '${nickname[0]}老师';
      } else {
        nickname = '${nickname[0]}同学';
      }
    }
    var bbsSecret = Kv.admin.bbsSecret;
    if (bbsSecret != null && bbsSecret.isNotEmpty) {
      openid = bbsSecret;
    }
    Log.info('BBS身份：{openid: $openid, nickname: $nickname}');
    if (openid != null && nickname != null) {
      return SimpleWebViewPage(
        initialUrl: R.kiteBbsUrl,
        postData: {
          'openid': openid,
          'nickname': nickname,
          'avatar': 'https://txc.qq.com/static/desktop/img/products/def-product-logo.png',
        },
        fixedTitle: i18n.ftype_bbs,
        showLaunchButtonIfUnsupported: false,
      );
    } else {
      return SimpleWebViewPage(
        initialUrl: R.kiteBbsUrl,
        fixedTitle: i18n.ftype_bbs,
        showLaunchButtonIfUnsupported: false,
      );
    }
  }
}
