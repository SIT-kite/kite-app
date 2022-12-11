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

import '../init.dart';
import '../using.dart';

/// REAL. THE PAYLOAD IS IN PINYIN. DONT BLAME ANYONE BUT THE SCHOOL.
/// More reading: https://github.com/sunnysab/zf-tools/blob/master/TRANSLATION.md
class EvaluationPage extends StatelessWidget {
  const EvaluationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = Uri(
      scheme: 'http',
      host: 'jwxt.sit.edu.cn',
      path: '/jwglxt/xspjgl/xspj_cxXspjIndex.html',
      queryParameters: {
        'doType': 'details',
        'gnmkdm': 'N401605',
        'layout': 'default',
        // 'su': studentId,
      },
    );
    return MyFutureBuilder<List<WebViewCookie>>(
      future: ExamResultInit.cookieJar.loadAsWebViewCookie(url),
      builder: (context, data) {
        return SimpleWebViewPage(
          initialUrl: url.toString(),
          fixedTitle: i18n.teacherEvalTitle,
          initialCookies: data,
        );
      },
    );
  }
}
