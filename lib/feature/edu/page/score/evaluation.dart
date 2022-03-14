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
import 'package:kite/feature/web_page/webview/page/index.dart';
import 'package:kite/util/cookie_util.dart';

import '../../entity/index.dart';
import '../../init.dart';

const _evaluationPageUrl = 'http://jwxt.sit.edu.cn/jwglxt/xspjgl/xspj_cxXspjDisplay.html?gnmkdm=N401605';

class EvaluationPage extends StatefulWidget {
  final List<CourseToEvaluate> coursesToEvaluate;

  const EvaluationPage(this.coursesToEvaluate, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  int index = 0;

  Map<String, String> _getForm(CourseToEvaluate coursesToEvaluate) {
    return {
      'jxb_id': coursesToEvaluate.innerClassId,
      'kch_id': coursesToEvaluate.courseId,
      'xsdm': coursesToEvaluate.subTypeId,
      'jgh_id': coursesToEvaluate.teacherId,
      'tjzt': coursesToEvaluate.submittingStatus,
      'pjmbmcb_id': coursesToEvaluate.evaluationId,
      'sfcjlrjs': '1',
    };
  }

  @override
  Widget build(BuildContext context) {
    final coursesToEvaluate = widget.coursesToEvaluate;
    return SimpleWebViewPage(
      initialUrl: _evaluationPageUrl,
      fixedTitle: '评教',
      initialAsyncCookies: EduInitializer.cookieJar.loadAsWebViewCookie(
        Uri.parse('http://jwxt.sit.edu.cn/jwglxt/'),
      ),
      floatingActionButton: FloatingActionButton(
        child: index == coursesToEvaluate.length - 1 ? const Icon(Icons.check) : const Icon(Icons.east),
        onPressed: () {
          // 评教完成
          if (index == coursesToEvaluate.length - 1) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              index++;
            });
          }
        },
      ),
      postData: _getForm(coursesToEvaluate[index]),
    );
  }
}
