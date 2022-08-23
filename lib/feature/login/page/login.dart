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
import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/exception/session.dart';
import 'package:kite/launch.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/validation.dart';

import '../init.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _proxyInputController = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  final TapGestureRecognizer _recognizer = TapGestureRecognizer()..onTap = onOpenUserLicense;

  // State
  bool isPasswordClear = false;
  bool isLicenseAccepted = false;
  bool isProxySettingShown = false;
  bool disableLoginButton = false;

  /// 用户点击登录按钮后
  Future<void> onLogin() async {
    bool formValid = (_formKey.currentState as FormState).validate();
    if (!formValid) {
      return;
    }
    if (!isLicenseAccepted) {
      showBasicFlash(context, const Text('请阅读并同意用户协议'));
      return;
    }

    setState(() {
      disableLoginButton = true;
    });
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      await LoginInitializer.ssoSession.login(username, password);
      final personName = await LoginInitializer.authServerService.getPersonName();
      KvStorageInitializer.auth
        ..currentUsername = username
        ..ssoPassword = password
        ..personName = personName;

      if (!mounted) return;
      // 后退到就剩一个栈内元素
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.pushReplacementNamed(context, RouteTable.home);
      GlobalLauncher.launch('https://kite.sunnysab.cn/wiki/kite-app/features/');
    } on CredentialsInvalidException catch (e) {
      showBasicFlash(context, Text(e.msg));
      return;
    } catch (e) {
      showBasicFlash(context, Text('未知错误: $e'), duration: const Duration(seconds: 3));
      return;
    } finally {
      setState(() {
        disableLoginButton = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    String? username = KvStorageInitializer.auth.currentUsername;
    String? password = KvStorageInitializer.auth.ssoPassword;
    if (username != null) {
      _usernameController.text = username;
      _passwordController.text = password ?? '';
    }
  }

  static void onOpenUserLicense() {
    const url = 'https://kite.sunnysab.cn/license/';
    GlobalLauncher.launch(url);
  }

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: const Text('欢迎登录', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)));
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
            validator: studentIdValidator,
            decoration: const InputDecoration(labelText: '账号', hintText: '学号/工号', icon: Icon(Icons.person)),
          ),
          TextFormField(
            controller: _passwordController,
            autofocus: true,
            obscureText: !isPasswordClear,
            decoration: InputDecoration(
              labelText: '密码',
              hintText: '输入你的密码',
              icon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                // 切换密码明文显示状态的图标按钮
                icon: Icon(isPasswordClear ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isPasswordClear = !isPasswordClear;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserLicenseCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isLicenseAccepted,
          onChanged: (_isLicenseAccepted) {
            setState(() => isLicenseAccepted = _isLicenseAccepted!);
          },
        ),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '我已阅读并同意', style: Theme.of(context).textTheme.bodyText1),
                TextSpan(text: '《上应小风筝用户协议》', style: Theme.of(context).textTheme.bodyText2, recognizer: _recognizer),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.h,
          child: ElevatedButton(
            onPressed: disableLoginButton ? null : onLogin,
            child: const Text('进入风筝元宇宙'),
          ),
        ),
      ],
    );
  }

  Widget _buildProxySetButton(BuildContext context, FlashController<dynamic> controller, _) {
    return IconButton(
      onPressed: () {
        final String inputText = _proxyInputController.text;

        if (proxyValidator(inputText) != null) {
          return;
        }
        controller.dismiss();
        isProxySettingShown = false;

        KvStorageInitializer.network
          ..useProxy = true
          ..proxy = inputText;
        // TODO
        // SessionPool.init();
      },
      icon: const Icon(Icons.send),
    );
  }

  void _showProxyInput() {
    if (isProxySettingShown) {
      return;
    }
    isProxySettingShown = true;
    _proxyInputController.text = KvStorageInitializer.network.proxy;

    context.showFlashBar(
      persistent: true,
      borderWidth: 3.sm,
      behavior: FlashBehavior.fixed,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: const Text('设置代理服务'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('格式如 192.168.1.1:8000'),
          Form(
            child: TextFormField(
              controller: _proxyInputController,
              validator: proxyValidator,
              autofocus: true,
            ),
          ),
        ],
      ),
      primaryActionBuilder: _buildProxySetButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40.h,
            left: 10.w,
            child: IconButton(
              icon: Icon(Icons.arrow_back_outlined, size: 35.sm),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Proxy setting
          Positioned(
            top: 40.h,
            right: 10.w,
            child: IconButton(
              icon: Icon(Icons.settings, size: 35.sm),
              onPressed: _showProxyInput,
            ),
          ),
          Center(
            child:
                // Create new container and make it center in vertical direction.
                Container(
              width: 1.sw,
              padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title field.
                  buildTitleLine(),
                  Padding(padding: EdgeInsets.only(top: 40.h)),
                  // Form field: username and password.
                  buildLoginForm(),
                  SizedBox(height: 10.h),
                  // User license check box.
                  buildUserLicenseCheckbox(),
                  SizedBox(height: 25.h),
                  // Login button.
                  buildLoginButton(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: const Text(
                      '忘记密码',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      const String forgetPassword =
                          'https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F';
                      GlobalLauncher.launch(forgetPassword);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      '遇到问题',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/feedback');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
