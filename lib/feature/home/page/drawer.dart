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
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/dsl.dart';
import 'package:universal_platform/universal_platform.dart';

class KiteDrawer extends Drawer {
  const KiteDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inDays = DateTime.now().difference(KvStorageInitializer.home.installTime!).inDays;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: KvStorageInitializer.theme.color),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(i18n.daysKiteWithYouLabel(inDays),
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white70))),
          ),
          ListTile(
            title: Text(i18n.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/setting');
            },
          ),
          ListTile(
            title: i18n.networkTool.txt,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/connectivity');
            },
          ),
          UniversalPlatform.isAndroid
              ? ListTile(
                  title: i18n.schoolCardTool.txt,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/campusCard');
                  },
                )
              : const SizedBox(height: 0),
          ListTile(
            title: i18n.feedback.txt,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/feedback');
            },
          ),
          ListTile(
            title: i18n.about.txt,
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
