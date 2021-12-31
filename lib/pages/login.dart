import 'package:flutter/material.dart';
import 'package:kite/services/myportal.dart';
import 'package:kite/services/sso/sso.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String? _usernameValidator(String? username) {
    if (username == null || username.isEmpty) {
      return '你还没有输入学号呢';
    }
    return null;
  }

  String? _passwordValidator(String? username) {
    if (username == null || username.isEmpty) {
      return '你还没有输入学号呢';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
            child: Container(
      width: screenWidth,
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text('欢迎登录',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.only(top: 40.0)),
          TextFormField(
            controller: _usernameController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: '学号', hintText: '输入你的学号', icon: Icon(Icons.person)),
            validator: _usernameValidator,
          ),
          TextFormField(
            controller: _passwordController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: '密码', hintText: '输入你的密码', icon: Icon(Icons.lock)),
            validator: _passwordValidator,
            obscureText: true,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                '进入风筝元宇宙',
                semanticsLabel: '登录',
              ))
        ],
      ),
    )));
  }
}
