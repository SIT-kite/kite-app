import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:kite/global/init_util.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/setting/storage.dart';
import 'package:kite/storage/constants.dart';
import 'package:kite/util/validation.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  Widget _negativeActionBuilder(context, controller, _) {
    return TextButton(
      onPressed: () {
        controller.dismiss();
      },
      child: const Text('取消'),
    );
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
                // dismiss 函数会异步地执行动画, 但动画在应用重启时会被打断从而产生报错. 因此此处不需要 dismiss.
                // controller.dismiss();

                StoragePool.authPool.delete(StoragePool.authSetting.currentUsername!);
                StoragePool.authSetting.currentUsername = null;

                await initBeforeRun();
                // 重启应用
                Phoenix.rebirth(context);
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
                await StoragePool.clear(); // 清除存储
                Phoenix.rebirth(context); // 重启应用
              },
              child: const Text('继续'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: '设置', children: [
      SettingsGroup(
        title: '个性化',
        children: <Widget>[
          ColorPickerSettingsTile(
            settingKey: ThemeKeys.themeColor,
            defaultValue: StoragePool.themeSetting.color,
            title: '主题色',
            onChange: (newColor) => DynamicColorTheme.of(context).setColor(
              color: newColor,
              shouldSave: true, // saves it to shared preferences
            ),
          ),
          SwitchSettingsTile(
            settingKey: '/theme/isDark',
            defaultValue: StoragePool.themeSetting.isDarkMode,
            title: '夜间模式',
            subtitle: '开启黑暗模式以保护视力',
            leading: const Icon(Icons.dark_mode),
            onChange: (value) => DynamicColorTheme.of(context).setIsDark(isDark: value, shouldSave: false),
          ),
        ],
      ),
      SettingsGroup(
        title: '首页',
        children: <Widget>[
          RadioSettingsTile<int>(
            title: '首页背景模式',
            settingKey: HomeKeyKeys.backgroundMode,
            values: const <int, String>{
              1: '实时天气',
              2: '纯色',
              3: '静态图片',
            },
            selected: 1,
            onChange: (value) {},
          ),
          DropDownSettingsTile<int>(
            title: '校区',
            subtitle: '用于显示对应校区的天气',
            settingKey: HomeKeyKeys.campus,
            values: const <int, String>{
              1: '奉贤',
              2: '徐汇',
            },
            selected: 1,
            onChange: (value) {
              StoragePool.homeSetting.campus = value;
            },
          ),
          SimpleSettingsTile(title: '背景图片', subtitle: '设置首页的背景图片', onTap: () => {}),
        ],
      ),
      SettingsGroup(title: '网络', children: <Widget>[
        SwitchSettingsTile(
          settingKey: '/network/useProxy',
          defaultValue: StoragePool.network.useProxy,
          title: '使用 HTTP 代理',
          subtitle: '通过 HTTP 代理和其他设备上的 EasyConnect 来连接校园网',
          leading: const Icon(Icons.vpn_key),
          onChange: (value) {
            if (value) {
              StoragePool.network.useProxy = value;
              SessionPool.init();
            }
          },
          childrenIfEnabled: [
            TextInputSettingsTile(
              title: '代理地址',
              settingKey: '/network/proxy',
              initialValue: StoragePool.network.proxy,
              validator: proxyValidator,
              onChange: (value) {
                StoragePool.network.proxy = value;
                if (StoragePool.network.useProxy) {
                  SessionPool.init();
                }
              },
            ),
            SimpleSettingsTile(
                title: '测试连接',
                subtitle: '检查校园网或网络代理的连接',
                onTap: () {
                  Navigator.pushNamed(context, '/connectivity');
                }),
          ],
        ),
      ]),
      SettingsGroup(title: '账户', children: <Widget>[
        TextInputSettingsTile(
          title: '学号',
          settingKey: AuthKeys.currentUsername,
          initialValue: StoragePool.authSetting.currentUsername ?? '',
          validator: studentIdValidator,
        ),
        SimpleSettingsTile(title: '测试连接', subtitle: '检查用户名密码是否正确', onTap: () => {}),
        SimpleSettingsTile(title: '退出登录', subtitle: '退出当前账号', onTap: () => _onLogout(context)),
        SimpleSettingsTile(title: '清除数据', subtitle: '清除应用程序保存的账号和设置，但不包括缓存', onTap: () => _onClearStorage(context)),
      ]),
      kDebugMode
          ? SettingsGroup(title: '开发者选项', children: <Widget>[
              SimpleSettingsTile(
                title: '显示本机存储内容',
                subtitle: '包括首页和各模块存储的数据',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DebugStoragePage())),
              )
            ])
          : const SizedBox(height: 0),
    ]);
  }
}
