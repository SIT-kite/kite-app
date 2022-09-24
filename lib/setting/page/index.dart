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
import 'dart:io';

import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kite/global/global.dart';
import 'package:kite/global/hive_initializer.dart';
import 'package:kite/global/init.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/dao/pref.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/storage/storage/admin.dart';
import 'package:kite/storage/storage/develop.dart';
import 'package:kite/util/file.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/user.dart';
import 'package:kite/util/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';

import 'home.dart';
import 'storage.dart';

class SettingPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final bool isFreshman = AccountUtils.getUserType() == UserType.freshman;

  SettingPage({Key? key}) : super(key: key);

  Widget _negativeActionBuilder(context, controller, _) {
    return TextButton(
      onPressed: () {
        controller.dismiss();
      },
      child: const Text('取消'),
    );
  }

  Future<void> _onChangeBgImage() async {
    final saveToPath = '${(await getApplicationDocumentsDirectory()).path}/kite1/background';

    if (UniversalPlatform.isDesktop) {
      String? srcPath = await FileUtils.pickImageByFilePicker();
      if (srcPath == null) return;
      await File(srcPath).copy(saveToPath);
    } else {
      XFile? image = await FileUtils.pickImageByImagePicker();
      await image?.saveTo(saveToPath);
    }
    KvStorageInitializer.home.background = saveToPath;
    Global.eventBus.emit(EventNameConstants.onBackgroundChange);
  }

  void _testPassword(BuildContext context) async {
    final user = KvStorageInitializer.auth.currentUsername;
    final password = KvStorageInitializer.auth.ssoPassword;
    try {
      EasyLoading.instance.userInteractions = false;
      EasyLoading.show(status: '正在登录');
      await Global.ssoSession.login(user!, password!);
      EasyLoading.showSuccess('用户名和密码正确');
    } catch (e) {
      showBasicFlash(context, Text('登录异常: ${e.toString().split('\n')[0]}'), duration: const Duration(seconds: 3));
    } finally {
      EasyLoading.dismiss();
      EasyLoading.instance.userInteractions = true;
    }
  }

  void _gotoWelcome(BuildContext context) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(RouteTable.welcome);

    Log.info('重启成功');
  }

  void _onLogout(BuildContext context) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        title: const Text('退出登录'),
        content: const Text('您将会退出当前账号，是否继续？'),
        negativeActionBuilder: _negativeActionBuilder,
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                Log.info('退出登录');

                if (isFreshman) {
                  KvStorageInitializer.freshman
                    ..freshmanAccount = null
                    ..freshmanName = null
                    ..freshmanSecret = null;
                } else {
                  KvStorageInitializer.auth
                    ..currentUsername = null
                    ..ssoPassword = null;
                }

                await Initializer.init();

                controller.dismiss();
                _gotoWelcome(context);
              },
              child: const Text('继续'));
        });
  }

  void _onClearStorage(BuildContext context) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        title: const Text('清除数据'),
        content: const Text('此操作将清除您本地的登录信息（不包括网页缓存），并重启本应用。如果你想清除所有数据，请在手机设置的应用管理界面中找到 "上应小风筝" 并重置。'),
        negativeActionBuilder: _negativeActionBuilder,
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                await HiveBoxInitializer.clear(); // 清除存储
                await Initializer.init();
                await controller.dismiss();
                _gotoWelcome(context);
              },
              child: const Text('继续'));
        });
  }

  _buildLanguagePrefSelector(BuildContext ctx) {
    final cur = KvStorageInitializer.pref.locale;
    return DropDownSettingsTile<String>(
      title: i18n.language,
      subtitle: i18n.languagePrefDropDownSubtitle,
      settingKey: PrefKeys.locale,
      values: {
        "en": i18n.language_en,
        "zh": i18n.language_zh,
      },
      selected: cur.languageCode,
      onChange: (value) {
        KvStorageInitializer.pref.locale = Locale(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.text = KvStorageInitializer.auth.ssoPassword ?? '';
    return SettingsScreen(title: i18n.settingsTitle, children: [
      SettingsGroup(
        title: i18n.personalizeTitle,
        children: <Widget>[
          ColorPickerSettingsTile(
            settingKey: ThemeKeys.themeColor,
            defaultValue: KvStorageInitializer.theme.color,
            title: i18n.themeColorSettings,
            onChange: (newColor) => DynamicColorTheme.of(context).setColor(
              color: newColor,
              shouldSave: true, // saves it to shared preferences
            ),
          ),
          _buildLanguagePrefSelector(context),
          SwitchSettingsTile(
            settingKey: ThemeKeys.isDarkMode,
            defaultValue: KvStorageInitializer.theme.isDarkMode,
            title: i18n.darkModeSettings,
            subtitle: i18n.darkModeSettingsSubtitle,
            leading: const Icon(Icons.dark_mode),
            onChange: (value) => DynamicColorTheme.of(context).setIsDark(isDark: value, shouldSave: false),
          ),
        ],
      ),
      SettingsGroup(
        title: i18n.mainPage,
        children: <Widget>[
          RadioSettingsTile<int>(
            title: i18n.mainPageBgModeSettings,
            settingKey: HomeKeyKeys.backgroundMode,
            values: <int, String>{
              1: i18n.realtimeWeather,
              2: i18n.staticPicture,
            },
            selected: KvStorageInitializer.home.backgroundMode,
            onChange: (value) {
              KvStorageInitializer.home.backgroundMode = value;
              Global.eventBus.emit(EventNameConstants.onBackgroundChange);
            },
          ),
          DropDownSettingsTile<int>(
            title: i18n.campus,
            subtitle: i18n.campusDropDownSettingsSubtitle,
            settingKey: HomeKeyKeys.campus,
            values: <int, String>{
              1: i18n.fengxianDistrict,
              2: i18n.xuhuiDistrict,
            },
            selected: KvStorageInitializer.home.campus,
            onChange: (value) {
              KvStorageInitializer.home.campus = value;
              Global.eventBus.emit(EventNameConstants.onCampusChange);
            },
          ),
          SimpleSettingsTile(
              title: i18n.backgroundPictureSettings,
              subtitle: i18n.backgroundPictureSettingsSubtitle,
              onTap: _onChangeBgImage),
          if (!isFreshman)
            SimpleSettingsTile(
              title: i18n.functionOrderSettings,
              subtitle: i18n.functionOrderSettingsSubtitle,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeSettingPage())),
            ),
        ],
      ),
      SettingsGroup(title: i18n.networking, children: <Widget>[
        SwitchSettingsTile(
          settingKey: '/network/useProxy',
          defaultValue: KvStorageInitializer.network.useProxy,
          title: i18n.enableHttpProxySwitch,
          subtitle: i18n.enableHttpProxySwitchSubtitle,
          leading: const Icon(Icons.vpn_key),
          onChange: (value) async {
            KvStorageInitializer.network.useProxy = value;
            await Initializer.init();
          },
          childrenIfEnabled: [
            TextInputSettingsTile(
              title: i18n.proxyAddressSettings,
              settingKey: '/network/proxy',
              initialValue: KvStorageInitializer.network.proxy,
              validator: proxyValidator,
              onChange: (value) async {
                KvStorageInitializer.network.proxy = value;
                if (KvStorageInitializer.network.useProxy) {
                  await Initializer.init();
                }
              },
            ),
            SimpleSettingsTile(
                title: i18n.testConnectivity2School,
                subtitle: i18n.testConnectivity2SchoolSubtitle,
                onTap: () {
                  Navigator.pushNamed(context, '/connectivity');
                }),
          ],
        ),
      ]),
      SettingsGroup(
        title: '账户',
        children: <Widget>[
          if (!isFreshman)
            TextInputSettingsTile(
              title: '学号',
              settingKey: AuthKeys.currentUsername,
              initialValue: KvStorageInitializer.auth.currentUsername ?? '',
              validator: studentIdValidator,
            ),
          if (!isFreshman)
            ModalSettingsTile(
              title: '密码',
              subtitle: '修改小风筝使用的 OA 密码',
              showConfirmation: true,
              onConfirm: () {
                KvStorageInitializer.auth.ssoPassword = _passwordController.text;
                return true;
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(controller: _passwordController, obscureText: true),
                ),
              ],
            ),
          if (!isFreshman)
            SimpleSettingsTile(title: '登录测试', subtitle: '检查用户名密码是否正确', onTap: () => _testPassword(context)),
          SimpleSettingsTile(title: '退出登录', subtitle: '退出当前账号', onTap: () => _onLogout(context)),
        ],
      ),
      SettingsGroup(title: '数据管理', children: [
        SimpleSettingsTile(
            title: '清除数据',
            leading: const Icon(Icons.remove_circle),
            subtitle: '清除应用程序保存的账号和设置，但不包括缓存',
            onTap: () => _onClearStorage(context)),
      ]),
      if (kDebugMode)
        SettingsGroup(
          title: '管理员选项',
          children: <Widget>[
            TextInputSettingsTile(
              title: '"问答" 密钥',
              settingKey: AdminKeys.bbsSecret,
              initialValue: KvStorageInitializer.admin.bbsSecret ?? '',
            ),
          ],
        ),
      SettingsGroup(
        title: '开发者选项',
        children: <Widget>[
          SwitchSettingsTile(
              settingKey: DevelopOptionsKeys.showErrorInfoDialog,
              defaultValue: KvStorageInitializer.developOptions.showErrorInfoDialog ?? false,
              title: '启动详细错误对话框',
              subtitle: '将展示详细的异常栈追踪信息',
              leading: const Icon(Icons.info),
              onChange: (value) {
                KvStorageInitializer.developOptions.showErrorInfoDialog = value;
              }),
          SimpleSettingsTile(
            title: '显示本机存储内容',
            subtitle: '含首页及各模块存储的数据',
            leading: const Icon(Icons.storage),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DebugStoragePage())),
          )
        ],
      ),
    ]);
  }
}
