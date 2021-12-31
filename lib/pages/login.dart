import 'package:flutter/material.dart';
import 'package:kite/services/myportal.dart';
import 'package:kite/services/sso/sso.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Rule of student id.
  RegExp reStudentId = RegExp(r'^((\d{9})|(\d{6}[YGHE\d]\d{3}))$');
  bool isPasswordClear = false;

  String? _usernameValidator(String? username) {
    if (username != null && username.isNotEmpty) {
      // When user complete his input, check it.
      if (((username.length == 9 || username.length == 10) &&
              !reStudentId.hasMatch(username)) ||
          username.length > 10) {
        return '学号格式不正确';
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: Auto fill last username.
    _usernameController.text = 'username';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _formKey = new GlobalKey<FormState>();

    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
            child:
                // Create new container and make it center in vertical direction.
                Container(
      width: screenWidth,
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title field.
          Container(
              alignment: Alignment.centerLeft,
              child: const Text('欢迎登录',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.only(top: 40.0)),

          // Form field: username and password.
          Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: '学号',
                        hintText: '输入你的学号',
                        icon: Icon(Icons.person)),
                    validator: _usernameValidator,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      autofocus: true,
                      obscureText: !isPasswordClear,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordClear
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPasswordClear = !isPasswordClear;
                              });
                            },
                          ),
                          labelText: '密码',
                          hintText: '输入你的密码',
                          icon: const Icon(Icons.lock))),
                ],
              )),
          const SizedBox(height: 40),

          // Login button.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('进入风筝元宇宙'),
                ),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
