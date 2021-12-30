import 'package:flutter/material.dart';
import 'package:kite/services/myportal.dart';
import 'package:kite/services/sso/sso.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String id = '';
  String yx = '';
  String lastLogin = '';
  String lastIp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var username = '学号';
              var password = '密码';
              var session = Session(username, password);

              await session.login();
              var userInfo = await MyPortal(session).getUserInfo();
              print(userInfo);
            },
            child: const Text('Button'),
          ),
        ],
      ),
    );
  }
}
