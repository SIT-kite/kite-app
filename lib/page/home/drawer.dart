import 'package:flutter/material.dart';

class KiteDrawer extends Drawer {
  const KiteDrawer({Key? key}) : super(key: key);

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
        ],
      ),
    );
  }
}
