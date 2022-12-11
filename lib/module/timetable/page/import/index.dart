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
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../init.dart';
import '../../using.dart';
import '../../../../design/page/connectivity.dart';
import 'import.dart';

class ImportTimetableIndexPage extends StatefulWidget {
  const ImportTimetableIndexPage({super.key});

  @override
  State<ImportTimetableIndexPage> createState() => _ImportTimetableIndexPageState();
}

class _ImportTimetableIndexPageState extends State<ImportTimetableIndexPage> {
  bool canImport = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.timetableImportTitle.text(),
      ),
      body: buildBody(context).animatedSwitched(),
    );
  }

  Widget buildBody(BuildContext ctx) {
    if (Auth.oaCredential != null) {
      if (canImport) {
        return const ImportTimetablePage(
          key: ValueKey("Import Timetable"),
        );
      } else {
        return buildConnectivityChecker(context, const ValueKey("Connectivity Checker"));
      }
    } else {
      return UnauthorizedTip(
        key: const ValueKey("Unauthorized"),
        onLogin: () {
          setState(() {});
        },
      );
    }
  }

  Widget buildConnectivityChecker(BuildContext ctx, Key? key) {
    return ConnectivityChecker(
      key: key,
      initialDesc: i18n.timetableImportConnectivityCheckerDesc,
      check: () {
        return TimetableInit.network.checkConnectivity();
      },
      onConnected: () {
        if (!mounted) return;
        setState(() {
          canImport = true;
        });
      },
      iconSize: ctx.isPortrait ? 180 : 120,
    );
  }
}
