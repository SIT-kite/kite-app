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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/launch.dart';
import 'package:kite/storage/init.dart';

import '../../../route.dart';
import '../../../util/flash.dart';
import '../../../util/logger.dart';
import '../dao.dart';
import '../init.dart';

class FreshmanLoginPage extends StatefulWidget {
  const FreshmanLoginPage({Key? key}) : super(key: key);

  @override
  State<FreshmanLoginPage> createState() => _FreshmanLoginPageState();
}

class _FreshmanLoginPageState extends State<FreshmanLoginPage> {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  // Text field controllers.
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  final TapGestureRecognizer _recognizer = TapGestureRecognizer()..onTap = onOpenUserLicense;

  // State
  bool _isPasswordClear = false;
  bool _isLicenseAccepted = false;
  bool _disableLoginButton = false;

  /// 用户点击登录按钮后
  Future<void> onLogin() async {
    Log.info('新生登录');
    bool formValid = (_formKey.currentState as FormState).validate();
    if (!formValid) {
      showBasicFlash(context, const Text('请检查您的输入'));
      return;
    }
    if (!_isLicenseAccepted) {
      showBasicFlash(context, const Text('请阅读并同意用户协议'));
      return;
    }

    setState(() => _disableLoginButton = true);

    final account = _accountController.text;
    final secret = _secretController.text;

    try {
      // 先保存登录信息
      KvStorageInitializer.freshman
        ..freshmanAccount = account
        ..freshmanSecret = secret;
      // 清空本地缓存
      FreshmanInitializer.freshmanCacheManager.clearAll();

      final info = await freshmanDao.getInfo();

      // 登陆成功后赋值名字
      KvStorageInitializer.freshman.freshmanName = info.name;

      // Flutter 官方推荐的在异步函数中使用context需要先检查是否mounted
      if (!mounted) return;
      // 后退到就剩一个栈内元素
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.pushReplacementNamed(context, RouteTable.home);

      // 预计需要写一份新生的使用说明
      // GlobalLauncher.launch('https://kite.sunnysab.cn/wiki/kite-app/features/');
      return;
    } catch (e) {
      // 登陆失败
      KvStorageInitializer.freshman
        ..freshmanSecret = null
        ..freshmanAccount = null;
      showBasicFlash(context, Text('登陆失败: $e'));
    } finally {
      setState(() => _disableLoginButton = false);
    }
  }

  @override
  void initState() {
    super.initState();

    String? account = KvStorageInitializer.freshman.freshmanAccount;
    String? secret = KvStorageInitializer.freshman.freshmanSecret;
    if (account != null) {
      _accountController.text = account;
      _secretController.text = secret ?? '';
    }
  }

  static void onOpenUserLicense() {
    const url = 'https://kite.sunnysab.cn/license/';
    GlobalLauncher.launch(url);
  }

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: const Text('欢迎新同学', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)));
  }

  Widget buildLoginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _accountController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: '账号',
              hintText: '学号/姓名/准考证号',
              icon: Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: _secretController,
            autofocus: true,
            obscureText: !_isPasswordClear,
            decoration: InputDecoration(
              labelText: '密码',
              hintText: '身份证号后六位',
              icon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                // 切换密码明文显示状态的图标按钮
                icon: Icon(_isPasswordClear ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => _isPasswordClear = !_isPasswordClear);
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
          value: _isLicenseAccepted,
          onChanged: (isLicenseAccepted) {
            setState(() => _isLicenseAccepted = isLicenseAccepted!);
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
            onPressed: _disableLoginButton ? null : onLogin,
            child: const Text('进入风筝元宇宙'),
          ),
        ),
      ],
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
          Center(
            child: Container(
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
                  Row(
                    children: [
                      buildLoginButton(),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
