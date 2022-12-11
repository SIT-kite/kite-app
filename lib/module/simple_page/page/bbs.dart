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
    String? openid;
    String? nickname;
    final oa = Auth.oaCredential;
    final freshman = Auth.freshmanCredential;
    // TODO: Port the name.
    if (oa != null) {
      openid = oa.account;
      nickname = Kv.auth.personName;
    } else if (freshman != null) {
      openid = freshman.account;
      nickname = Kv.freshman.freshmanName;
    } else {
      return SimpleWebViewPage(
        initialUrl: R.kiteBbsUrl,
        fixedTitle: i18n.ftype_bbs,
        showLaunchButtonIfUnsupported: false,
      );
    }
    if (nickname != null) {
      if (Auth.lastUserType == UserType.teacher) {
        /// No i18n, the name will be shown outside
        nickname = '${nickname[0]}老师';
      } else {
        nickname = '${nickname[0]}同学';
      }
    } else {
      return SimpleWebViewPage(
        initialUrl: R.kiteBbsUrl,
        fixedTitle: i18n.ftype_bbs,
        showLaunchButtonIfUnsupported: false,
      );
    }
    var bbsSecret = Kv.admin.bbsSecret;
    if (bbsSecret != null && bbsSecret.isNotEmpty) {
      openid = bbsSecret;
    }
    Log.info('BBS身份：{openid: $openid, nickname: $nickname}');
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
  }
}
