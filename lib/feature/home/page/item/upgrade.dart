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
import 'package:kite/feature/home/entity/home.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/upgrade.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';

import 'index.dart';

const String appUpgradeUrl = 'https://kite.sunnysab.cn/upgrade/';

class UpgradeItem extends StatelessWidget {
  const UpgradeItem({Key? key}) : super(key: key);

  void onTapUpdate(AppVersion version) {
    final url = '$appUpgradeUrl?type=${version.platform}&oldVersion=${version.version}';
    launchUrlInBrowser(url);
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktopOrWeb) {
      return const SizedBox(height: 0);
    }
    final future = getUpdate();

    return FutureBuilder<AppVersion?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          return HomeFunctionButton(
            title: i18n.ftype_upgrade,
            onPressed: () => onTapUpdate(snapshot.data!),
            subtitle: i18n.ftype_upgrade_desc,
            icon: 'assets/home/icon_upgrade.svg',
          );
        }
        return const SizedBox(height: 0);
      },
    );
  }
}
