import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kite/storage/auth.dart';
import 'package:kite/utils/flash_utils.dart';
import 'package:kite/utils/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Rule of student id.
RegExp reStudentId = RegExp(r'^((\d{9})|(\d{6}[YGHE\d]\d{3}))$');

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();

  final TapGestureRecognizer _recognizer = TapGestureRecognizer()..onTap = onOpenUserLicense;

  // State
  bool isPasswordClear = false;
  bool isLicenseAccepted = false;

  static String? _usernameValidator(String? username) {
    if (username != null && username.isNotEmpty) {
      // When user complete his input, check it.
      if (((username.length == 9 || username.length == 10) && !reStudentId.hasMatch(username)) ||
          username.length > 10) {
        return '学号格式不正确';
      }
    }
    return null;
  }

  /// 用户点击登录按钮后
  Future<void> onLogin() async {
    bool formValid = (_formKey.currentState as FormState).validate();
    if (!formValid) {
      return;
    }
    if (!isLicenseAccepted) {
      showBasicFlash(context, const Text('请勾选用户协议'));
      return;
    }

    var prefs = await SharedPreferences.getInstance();
    var auth = AuthStorage(prefs);
    auth.username = _usernameController.text;
    auth.password = _passwordController.text;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var auth = AuthStorage(prefs);
      _usernameController.text = auth.username;
      _passwordController.text = auth.password;
    });
  }

  static void onOpenUserLicense() {}

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: const Text('欢迎登录', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)));
  }

  Widget buildLoginForm() {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: '学号', hintText: '输入你的学号', icon: Icon(Icons.person)),
              validator: _usernameValidator,
            ),
            TextFormField(
                controller: _passwordController,
                autofocus: true,
                obscureText: !isPasswordClear,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordClear ? Icons.visibility_off : Icons.visibility),
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
        ));
  }

  Widget buildUserLicenseCheckbox() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Checkbox(
          value: isLicenseAccepted,
          onChanged: (_isLicenseAccepted) {
            setState(() {
              isLicenseAccepted = _isLicenseAccepted!;
            });
          }),
      Text.rich(TextSpan(children: [
        const TextSpan(text: '我已阅读并同意'),
        TextSpan(text: '《上应小风筝用户协议》', style: const TextStyle(color: Colors.blue), recognizer: _recognizer),
      ]))
    ]);
  }

  Widget buildLoginButton() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: onLogin,
          child: const Text('进入风筝元宇宙'),
        ),
      ),
      TextButton(
          child: const Text(
            '忘记密码?',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            launchInBrowser(
                'https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F');
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
          buildTitleLine(),
          const Padding(padding: EdgeInsets.only(top: 40.0)),
          // Form field: username and password.
          buildLoginForm(),
          const SizedBox(height: 10),
          // User licenese check box.
          buildUserLicenseCheckbox(),
          const SizedBox(height: 25),
          // Login button.
          buildLoginButton(),
        ],
      ),
    )));
  }
}
