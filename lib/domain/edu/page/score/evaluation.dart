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
import 'package:kite/domain/edu/entity/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _evaluationPageUrl = 'http://jwxt.sit.edu.cn/jwglxt/xspjgl/xspj_cxXspjDisplay.html?gnmkdm=N401605';

class EvaluationPage extends StatefulWidget {
  final List<CourseToEvaluate> coursesToEvaluate;

  const EvaluationPage(this.coursesToEvaluate, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EvaluationPageState(coursesToEvaluate);
}

class _EvaluationPageState extends State<EvaluationPage> {
  final List<CourseToEvaluate> coursesToEvaluate;
  int index = 0;

  _EvaluationPageState(this.coursesToEvaluate);

  Map _getForm(CourseToEvaluate coursesToEvaluate) {
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

  String _generateJs(String path, Map params) {
    String formString = '{';
    for (var param in params.entries) {
      formString += '${param.key}: \'${param.value}\',';
    }
    formString += '}';

    // See: https://stackoverflow.com/questions/66396219/how-to-post-data-to-url-in-flutter-webview
    return '''
/**
 * sends a request to the specified url from a form. this will change the window location.
 * @param {string} path the path to send the post request to
 * @param {object} params the parameters to add to the url
 * @param {string} [method=post] the method to use on the form
 */
function post(path, params, method='post') {
  // The rest of this code assumes you are not using a library.
  // It can be made less verbose if you use one.
  const form = document.createElement('form');
  form.method = method;
  form.action = path;

  for (const key in params) {
    if (params.hasOwnProperty(key)) {
      const hiddenField = document.createElement('input');
      hiddenField.type = 'hidden';
      hiddenField.name = key;
      hiddenField.value = params[key];

      form.appendChild(hiddenField);
    }
  }
  document.body.appendChild(form);
  form.submit();
}
post("$path", $formString);''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('评教')),
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
      body: MyFutureBuilder<List<WebViewCookie>>(
          future: SessionPool.loadCookieAsWebViewCookie(Uri.parse('http://jwxt.sit.edu.cn/jwglxt/')),
          builder: (context, data) {
            return WebView(
              initialCookies: data,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                String js = _generateJs(_evaluationPageUrl, _getForm(coursesToEvaluate[index]));

                controller.runJavascript(js);
              },
            );
          }),
    );
  }
}
