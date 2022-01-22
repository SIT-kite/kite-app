import 'package:flutter/material.dart';
import 'package:kite/global/storage_pool.dart';

class KiteDrawer extends Drawer {
  const KiteDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: StoragePool.themeSetting.color),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('小风筝已陪伴你 ${DateTime.now().difference(StoragePool.homeSetting.installTime!).inDays} 天',
                    style: const TextStyle(color: Colors.white, fontSize: 22))),
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
            title: const Text('反馈'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/feedback');
            },
          ),
          ListTile(
            title: const Text('关于'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
    );
  }
}
