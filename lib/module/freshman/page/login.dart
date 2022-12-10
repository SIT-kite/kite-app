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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../dao/Freshman.dart';
import '../init.dart';
import '../using.dart';

class FreshmanLoginPage extends StatefulWidget {
  const FreshmanLoginPage({Key? key}) : super(key: key);

  @override
  State<FreshmanLoginPage> createState() => _FreshmanLoginPageState();
}

class _FreshmanLoginPageState extends State<FreshmanLoginPage> {
  FreshmanDao freshmanDao = FreshmanInit.freshmanDao;

  // Text field controllers.
  final _accountController = TextEditingController();
  final _secretController = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  final TapGestureRecognizer _recognizer = TapGestureRecognizer()..onTap = onOpenUserLicense;

  // State
  bool isPasswordClear = false;
  bool isLicenseAccepted = false;
  bool enableLoginButton = true;

  @override
  void initState() {
    super.initState();

    final freshmanCredential = Auth.freshmanCredential;
    if (freshmanCredential != null) {
      _accountController.text = freshmanCredential.account;
      _secretController.text = freshmanCredential.password;
    }
  }

  /// 用户点击登录按钮后
  Future<void> onLogin(BuildContext ctx) async {
    Log.info('新生登录');
    bool formValid = (_formKey.currentState as FormState).validate();
    if (!formValid) {
      await ctx.showTip(
        title: i18n.error,
        desc: i18n.validateInputAccountPwdRequest,
        ok: i18n.close,
        error: true,
      );
      return;
    }
    if (!isLicenseAccepted) {
      await ctx.showTip(
        title: i18n.fromKite,
        desc: i18n.readAndAcceptRequest(R.kiteUserAgreementName),
        ok: i18n.close,
        error: true,
      );
      return;
    }

    if (!mounted) return;
    setState(() => enableLoginButton = false);

    final account = _accountController.text;
    final secret = _secretController.text;
    try {
      // 先保存登录信息
      Auth.freshmanCredential = FreshmanCredential(account, secret);
      // 清空本地缓存
      FreshmanInit.freshmanCacheManager.clearAll();

      final info = await freshmanDao.getMyInfo();

      // 登录成功后赋值名字
      Kv.freshman.freshmanName = info.name;

      // Reset the home
      Kv.home.homeItems = null;
      // Flutter 官方推荐的在异步函数中使用context需要先检查是否mounted
      if (!mounted) return;
      // 后退到就剩一个栈内元素
      final navigator = context.navigator;
      while (navigator.canPop()) {
        navigator.pop();
      }
      navigator.pushReplacementNamed(RouteTable.home);

      // 预计需要写一份新生的使用说明
      // GlobalLauncher.launch('${Backend.kite}/wiki/kite-app/features/');
    } catch (e) {
      // 登录失败
      Auth.freshmanCredential = null;
      final connectionType = await Connectivity().checkConnectivity();
      if (!mounted) return;
      if (connectionType == ConnectivityResult.none) {
        await ctx.showTip(
          title: i18n.networkError,
          desc: i18n.networkNoAccessTip,
          ok: i18n.close,
          error: true,
        );
      } else {
        await ctx.showTip(
          title: i18n.loginFailedWarn,
          desc: i18n.accountOrPwdIncorrectTip,
          ok: i18n.close,
          error: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => enableLoginButton = true);
      }
    }
  }

  static void onOpenUserLicense() {
    GlobalLauncher.launch(R.kiteUserAgreementUrl);
  }

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(i18n.freshmanTitle, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)));
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
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: i18n.account,
              hintText: i18n.freshmanLoginAccountHint,
              icon: const Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: _secretController,
            autofocus: true,
            textInputAction: TextInputAction.go,
            toolbarOptions: const ToolbarOptions(
              copy: false,
              cut: false,
              paste: false,
              selectAll: false,
            ),
            autocorrect: false,
            enableSuggestions: false,
            obscureText: !isPasswordClear,
            onFieldSubmitted: (inputted) {
              if (enableLoginButton && isLicenseAccepted) {
                onLogin(context);
              }
            },
            decoration: InputDecoration(
              labelText: i18n.pwd,
              hintText: i18n.freshmanLoginPwdHint,
              icon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                // 切换密码明文显示状态的图标按钮
                icon: Icon(isPasswordClear ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => isPasswordClear = !isPasswordClear);
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
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                isLicenseAccepted = newValue;
              });
            }
          },
        ),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: i18n.acceptedAgreementCheckbox, style: Theme.of(context).textTheme.bodyText1),
                const TextSpan(text: " "),
                TextSpan(
                    text: R.kiteUserAgreementName,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(decoration: TextDecoration.underline),
                    recognizer: _recognizer),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext ctx) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.h,
          child: ElevatedButton(
            onPressed: enableLoginButton && isLicenseAccepted
                ? () {
                    // un-focus the text field.
                    FocusScope.of(context).requestFocus(FocusNode());
                    onLogin(ctx);
                  }
                : null,
            child: i18n.freshmanLoginBtn.text().padAll(5),
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                    buildLoginButton(context),
                    const SizedBox(width: 10),
                  ],
                ),
              ]).scrolled(physics: const NeverScrollableScrollPhysics()),
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
                    child: Text(
                      i18n.feedbackBtn,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteTable.feedback);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ).safeArea(), //to avoid overflow when keyboard is up.
    );
  }

  @override
  void dispose() {
    super.dispose();
    _accountController.dispose();
    _secretController.dispose();
  }
}
