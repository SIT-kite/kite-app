import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KiteDrawer extends Drawer {
  const KiteDrawer({Key? key}) : super(key: key);

  void onClearStorage(BuildContext context) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        title: const Text('退出登录'),
        content: const Text('退出登录将清除您本地的登录信息，但不包括一些模块内网页的缓存。 如果你想清除所有数据， 请在手机的应用管理中找到 "上应小风筝" 并重置。'),
        negativeActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss();
            },
            child: const Text('取消'),
          );
        },
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                // dismiss 函数会异步地执行动画, 但动画在应用重启时会被打断从而产生报错. 因此此处不需要 dismiss.
                // controller.dismiss();

                // 清除本地 SharedPreference 数据
                // TODO: 添加对 sqlite 的处理.
                (await SharedPreferences.getInstance()).clear();
                await Hive.close();
                await Hive.deleteFromDisk();
                // 重启应用
                Phoenix.rebirth(context);
              },
              child: const Text('继续'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('用户信息区域'),
          ),
          ListTile(
            title: const Text('设置'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/setting');
            },
          ),
          ListTile(
            title: const Text('网络工具'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/connectivity');
            },
          ),
          ListTile(
            title: const Text('校园卡工具'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/campusCard');
            },
          ),
          ListTile(
            title: const Text('关于'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            title: const Text('退出登录'),
            onTap: () {
              Navigator.pop(context);
              onClearStorage(context);
            },
          ),
        ],
      ),
    );
  }
}
