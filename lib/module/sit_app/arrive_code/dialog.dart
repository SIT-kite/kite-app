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

import 'package:flutter/cupertino.dart';
import 'package:kite/module/sit_app/init.dart';
import '../using.dart';

class ArriveCodeDialog {
  static Future<void> scan(BuildContext context, String code) async {
    String msg = '';
    try {
      final response = await SitAppInit.arriveCodeService.arrive(code);
      msg = response;
    } on SitAppApiError catch (e, _) {
      if (e.code == 301) {
        msg = '您刚刚已经扫过了';
      } else {
        msg = '${e.msg}';
      }
    }
    await showAlertDialog(context, title: '场所码登记', content: [Text(msg)], actionTextList: ['我知道了']);
  }
}
