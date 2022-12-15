/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class QuickButtons extends StatefulWidget {
  const QuickButtons({super.key});

  @override
  State<StatefulWidget> createState() => _QuickButtonsState();
}

class _QuickButtonsState extends State<QuickButtons> {
  @override
  Widget build(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: AppSettings.openWIFISettings,
        child: i18n.openWlanSettingsBtn.text(),
      ),
      ElevatedButton(
          child: i18n.launchEasyConnectBtn.text(),
          onPressed: () async {
            final launched = await GlobalLauncher.launch('sangfor://easyconnect');
            if (!launched) {
              if (!mounted) return;
              final confirm = await context.showRequest(
                  title: i18n.easyconnectLaunchFailed,
                  desc: i18n.easyconnectLaunchFailedDesc,
                  yes: i18n.download,
                  no: i18n.notNow,
                  highlight: true);
              if (confirm == true) {
                await GlobalLauncher.launch(R.easyConnectDownloadUrl);
              }
            }
          }),
    ].row(
      maa: MainAxisAlignment.spaceEvenly,
    );
  }
}
