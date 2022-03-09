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
import 'package:flutter/material.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:universal_platform/universal_platform.dart';

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
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white70))),
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
          UniversalPlatform.isAndroid
              ? ListTile(
                  title: const Text('校园卡工具'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/campusCard');
                  },
                )
              : const SizedBox(height: 0),
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
