import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:kite/storage/storage_pool.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: '设置', children: [
      SettingsGroup(
        title: '个性化',
        children: <Widget>[
          ColorPickerSettingsTile(
            settingKey: '/theme/color',
            title: '主题色',
            defaultValue: Colors.blue,
            onChange: (value) {
              debugPrint('key-color-picker: $value');
            },
          ),
        ],
      ),
      SettingsGroup(
        title: '首页',
        children: <Widget>[
          RadioSettingsTile<int>(
            title: '首页背景模式',
            settingKey: '/home/backgroundMode',
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
            settingKey: '/home/campus',
            values: const <int, String>{
              1: '奉贤',
              2: '徐汇',
            },
            selected: 1,
            onChange: (value) {
              StoragePool.home.campus = value;
            },
          ),
          SimpleSettingsTile(title: '背景图片', subtitle: '设置首页的背景图片', onTap: () => {}),
        ],
      ),
      SettingsGroup(title: '账户', children: <Widget>[
        TextInputSettingsTile(
          title: '学号',
          settingKey: '/auth/username',
          initialValue: StoragePool.auth.username,
        ),
        TextInputSettingsTile(
          title: '密码',
          settingKey: '/auth/password',
          initialValue: '********',
        ),
        SimpleSettingsTile(title: '测试连接', subtitle: '检查用户名密码是否正确', onTap: () => {}),
      ]),
      SimpleSettingsTile(title: '退出登录', subtitle: '退出当前账号', onTap: () => {}),
      SimpleSettingsTile(title: '清除数据', subtitle: '清除应用程序保存的账号和设置，但不包括缓存', onTap: () => {}),
    ]);
  }
}
