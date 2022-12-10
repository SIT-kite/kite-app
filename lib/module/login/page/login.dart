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
import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../using.dart';

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
  bool enableLoginButton = true;

  /// 用户点击登录按钮后
  Future<void> onLogin(BuildContext ctx) async {
    bool formValid = (_formKey.currentState as FormState).validate();
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (!formValid || username.isEmpty || password.isEmpty) {
      await ctx.showTip(
        title: i18n.formatError,
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
    final connectionType = await Connectivity().checkConnectivity();
    if (connectionType == ConnectivityResult.none) {
      if (!mounted) return;
      setState(() => enableLoginButton = true);
      await ctx.showTip(
        title: i18n.networkError,
        desc: i18n.networkNoAccessTip,
        ok: i18n.close,
        error: true,
      );
      return;
    }

    try {
      await LoginInit.ssoSession.login(username, password);
      final personName = await LoginInit.authServerService.getPersonName();
      Kv.auth
        ..currentUsername = username
        ..ssoPassword = password
        ..personName = personName;
      // Reset the home
      Kv.home.homeItems = null;
      if (!mounted) return;
      // 后退到就剩一个栈内元素
      final navigator = context.navigator;
      while (navigator.canPop()) {
        navigator.pop();
      }
      navigator.pushReplacementNamed(RouteTable.home);

      GlobalLauncher.launch(R.kiteWikiUrlFeatures);
    } on CredentialsInvalidException catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: i18n.loginFailedWarn,
        desc: e.msg,
        ok: i18n.close,
      );
      return;
    } catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: i18n.loginFailedWarn,
        desc: i18n.accountOrPwdIncorrectTip,
        ok: i18n.close,
        error: true,
      );
    } finally {
      if (mounted) {
        setState(() => enableLoginButton = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    String? username = Kv.auth.currentUsername;
    String? password = Kv.auth.ssoPassword;
    if (username != null) {
      _usernameController.text = username;
      _passwordController.text = password ?? '';
    }
  }

  static void onOpenUserLicense() {
    GlobalLauncher.launch(R.kiteUserAgreementUrl);
  }

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(i18n.kiteLoginTitle, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)));
  }

  Widget buildLoginForm(BuildContext ctx) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            validator: studentIdValidator,
            decoration: InputDecoration(
                labelText: i18n.account, hintText: i18n.kiteLoginAccountHint, icon: const Icon(Icons.person)),
          ),
          TextFormField(
            controller: _passwordController,
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
                onLogin(ctx);
              }
            },
            decoration: InputDecoration(
              labelText: i18n.oaPwd,
              hintText: i18n.kiteLoginPwdHint,
              icon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                // 切换密码明文显示状态的图标按钮
                icon: Icon(isPasswordClear ? Icons.visibility : Icons.visibility_off),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          // Online
          onPressed: enableLoginButton && isLicenseAccepted
              ? () {
                  // un-focus the text field.
                  FocusScope.of(context).requestFocus(FocusNode());
                  onLogin(ctx);
                }
              : null,
          child: i18n.kiteLoginBtn.text(),
        ).sized(height: 40.h),
        ElevatedButton(
          // Offline
          onPressed: isLicenseAccepted
              ? () {
                  Navigator.pushReplacementNamed(context, RouteTable.home);
                }
              : null,
          child: i18n.kiteLoginOfflineModeBtn.text(),
        ).sized(height: 40.h),
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

        Kv.network
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
    _proxyInputController.text = Kv.network.proxy;
    context.showFlashBar(
      persistent: true,
      borderWidth: 3.sm,
      behavior: FlashBehavior.fixed,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      // TODO: I18n
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
                  buildLoginForm(context),
                  SizedBox(height: 10.h),
                  // User license check box.
                  buildUserLicenseCheckbox(),
                  SizedBox(height: 25.h),
                  // Login button.
                  buildLoginButton(context),
                ],
              ).scrolled(physics: const NeverScrollableScrollPhysics()),
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
                      i18n.kiteForgotPwdBtn,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      GlobalLauncher.launch(R.forgotLoginPwdUrl);
                    },
                  ),
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
}
