import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:kite/global/init_util.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/storage/setting/constants.dart';
import 'package:kite/util/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        content: const Text('您将要退出当前账号，是否继续？'),
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
        content: const Text('此操作将清除您本地的登录信息，但不包括网页缓存。如果你想清除所有数据， 请在手机的应用管理中找到 "上应小风筝" 并重置。'),
        negativeActionBuilder: _negativeActionBuilder,
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                (await SharedPreferences.getInstance()).clear();
                await StoragePool.clear();
                // 重启应用
                Phoenix.rebirth(context);
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
            settingKey: SettingKeyConstants.themeColorKey,
            defaultValue: StoragePool.themeSetting.color,
            title: '主题色',
          )
        ],
      ),
      SettingsGroup(
        title: '首页',
        children: <Widget>[
          RadioSettingsTile<int>(
            title: '首页背景模式',
            settingKey: SettingKeyConstants.homeBackgroundModeKey,
            values: const <int, String>{
              1: '实时天气',
              2: '静态图片',
            },
            selected: 1,
            onChange: (value) {},
          ),
          DropDownSettingsTile<int>(
            title: '校区',
            subtitle: '用于显示对应校区的天气',
            settingKey: SettingKeyConstants.homeCampusKey,
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
          subtitle: '当代理服务器正确配置后, 您无需 EasyConnect 便可连接校园网',
          leading: const Icon(Icons.vpn_key),
          onChange: (value) {
            if (value) {
              StoragePool.network.useProxy = value;
              SessionPool.initProxySettings();
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
                  SessionPool.initProxySettings();
                }
              },
            ),
            SimpleSettingsTile(title: '测试连接', subtitle: '检查校园网或网络代理的连接', onTap: () => {}),
          ],
        ),
      ]),
      SettingsGroup(title: '账户', children: <Widget>[
        TextInputSettingsTile(
          title: '学号',
          settingKey: SettingKeyConstants.authCurrentUsername,
          initialValue: StoragePool.authSetting.currentUsername ?? '',
          validator: studentIdValidator,
        ),
        SimpleSettingsTile(title: '测试连接', subtitle: '检查用户名密码是否正确', onTap: () => {}),
      ]),
      SimpleSettingsTile(title: '退出登录', subtitle: '退出当前账号', onTap: () => _onLogout(context)),
      SimpleSettingsTile(title: '清除数据', subtitle: '清除应用程序保存的账号和设置，但不包括缓存', onTap: () => _onClearStorage(context)),
    ]);
  }
}
