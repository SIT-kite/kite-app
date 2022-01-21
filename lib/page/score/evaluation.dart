import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
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

  List<WebViewCookie> _loadCookieFromCookieJar() {
    final cookieJar = SessionPool.cookieJar;
    final cookies = cookieJar.hostCookies['jwxt.sit.edu.cn']!['/jwglxt/'];
    if (cookies != null) {
      List<WebViewCookie> cookieList = [];
      cookies.forEach((key, value) =>
          cookieList.add(WebViewCookie(name: key, value: value.cookie.value, domain: 'jwxt.sit.edu.cn')));
      return cookieList;
    }
    return [];
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
      body: WebView(
        initialCookies: _loadCookieFromCookieJar(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          String js = _generateJs(_evaluationPageUrl, _getForm(coursesToEvaluate[index]));

          controller.runJavascript(js);
        },
      ),
    );
  }
}
