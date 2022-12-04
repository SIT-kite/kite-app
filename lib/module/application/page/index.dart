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
import 'package:rettulf/rettulf.dart';
import '../user_widget/application.dart';
import '../using.dart';

import '../entity/function.dart';
import '../init.dart';
import 'message.dart';

// 本科生常用功能列表
const Set<String> _commonUse = <String>{
  '121',
  '011',
  '047',
  '123',
  '124',
  '024',
  '125',
  '165',
  '075',
  '202',
  '023',
  '067',
  '059'
};

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  bool enableFilter = true;
  List<ApplicationMeta> _allApplications = [];
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _fetchApplicationMetaList().then((value) {
      if (!mounted) return;
      setState(() {
        _allApplications = value;
        _lastError = null;
      });
    }).onError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _lastError = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_application.txt,
        actions: [_buildMenuButton(context)],
      ),
      body: Column(
        children: [
          i18n.applicationDesc.text(overflow: TextOverflow.visible).padAll(15).center(),
          buildBodyPortrait().expanded(),
        ],
      ),
      floatingActionButton: ApplicationInit.session.isLogin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagePage()));
              },
              tooltip: i18n.applicationMyMailBox,
              child: const Icon(Icons.mail_outline),
            )
          : null,
    );
  }

  Widget buildLandscape(BuildContext context) {
    return buildPortrait(context);
  }

  Widget buildListPortrait(List<ApplicationMeta> applicationList) {
    int count = 0;
    return ListView(
      children: applicationList.where((element) => _commonUse.contains(element.id) || !enableFilter).map((e) {
        count++;
        return ApplicationTile(item: e, isHot: count <= 3);
      }).toList(),
    );
  }

  Widget buildBodyPortrait() {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allApplications.isNotEmpty) {
      return buildListPortrait(_allApplications);
    } else {
      return Placeholders.loading();
    }
  }

  PopupMenuButton _buildMenuButton(BuildContext context) {
    final menuButton = PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              setState(() {
                enableFilter = !enableFilter;
              });
            },
            child: Row(
              children: [
                // 禁用checkbox自身的点击效果，点击由外部接管
                AbsorbPointer(
                  child: Checkbox(value: enableFilter, onChanged: (bool? value) {}),
                ),
                i18n.applicationFilerInfrequentlyUsed.txt,
              ],
            ),
          ),
        ];
      },
    );
    return menuButton;
  }
}

Future<List<ApplicationMeta>> _fetchApplicationMetaList() async {
  if (!ApplicationInit.session.isLogin) {
    final username = Kv.auth.currentUsername!;
    final password = Kv.auth.ssoPassword!;
    await ApplicationInit.session.login(
      username: username,
      password: password,
    );
  }
  return await ApplicationInit.applicationService.selectApplicationByCountDesc();
}
