import 'package:flutter/material.dart';
import 'package:kite/services/sso/encrypt_util.dart';
import 'package:kite/services/sso/login.dart';
import 'package:dio/dio.dart';
import 'package:kite/services/sso/nonpersistentCookieJar.dart';
import 'package:kite/services/ocr.dart';
import 'package:kite/services/sso/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var dio = Dio();
              var jar = NonpersistentCookieJar();
              var username = '';
              var password = '';
              var loginTool = Auth(
                dio,
                'https://myportal.sit.edu.cn/',
                jar,
                username,
                password,
              );

              await loginTool.login();

              // 打开OA首页
              var res = await dio.get('https://myportal.sit.edu.cn/',
                  options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE);

              // 处理重定向
              var result = await DioUtils.processRedirect(dio, res);

              // 显示数据
              print(result);
            },
            child: Text('Button'),
          )
        ],
      ),
    );
  }
}
