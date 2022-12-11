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
import 'package:kite/design/colors.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

class KiteDrawer extends StatelessWidget {
  const KiteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final installTime = Kv.home.installTime?? DateTime.now();
    final inDays = DateTime.now().difference(installTime).inDays;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: context.themeColor),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(inDays <= 0 ? i18n.daysKiteWithYouLabel0 : i18n.daysKiteWithYouLabel(inDays),
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white70))),
          ),
          ListTile(
            title: Text(i18n.settings),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.settings);
            },
          ),
          ListTile(
            title: i18n.networkTool.text(),
            leading: const Icon(Icons.lan),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.networkTool);
            },
          ),
          if (UniversalPlatform.isAndroid)
            ListTile(
              title: i18n.campusCardTool.text(),
              leading: const Icon(Icons.credit_card),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(RouteTable.campusCard);
              },
            ),
          // Feedback
          ListTile(
            title: i18n.feedback.text(),
            leading: const Icon(Icons.feedback_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.feedback);
            },
          ),
          // Service status
          ListTile(
            title: i18n.serviceStatus.text(),
            leading: const Icon(Icons.monitor_heart),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.serviceStatus);
            },
          ),
          // About
          ListTile(
            title: i18n.about.text(),
            leading: const Icon(Icons.info_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteTable.about);
            },
          ),
        ],
      ),
    );
  }
}
