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
class EvaluationPage extends StatefulWidget {
  const EvaluationPage({Key? key}) : super(key: key);

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
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

  final _vn = ValueNotifier<int>(100);

  final _webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    _vn.addListener(() {
      _webViewController.runJavaScript(
        "for(const e of document.getElementsByClassName('input-pjf')) e.value='${_vn.value}'",
      );
    });
  }

  @override
  void dispose() {
    _vn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: MyFutureBuilder<List<WebViewCookie>>(
              future: ExamResultInit.cookieJar.loadAsWebViewCookie(url),
              builder: (context, data) {
                return SimpleWebViewPage(
                  controller: _webViewController,
                  initialUrl: url.toString(),
                  fixedTitle: i18n.teacherEvalTitle,
                  initialCookies: data,
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _vn,
            builder: (context, value, child) {
              return Row(
                children: [
                  Text('填充分数：$value'),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: value.toDouble(),
                      onChanged: (v) => _vn.value = v.toInt(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
