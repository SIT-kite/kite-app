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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

import '../entity/function.dart';
import '../init.dart';
import 'detail.dart';
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

const List<Color> _iconColors = <Color>[
  Colors.orangeAccent,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.grey,
  Colors.black,
  Colors.green,
  Colors.yellowAccent,
  Colors.cyan,
  Colors.purple,
  Colors.teal,
];

class OfficePage extends StatefulWidget {
  const OfficePage({Key? key}) : super(key: key);

  @override
  State<OfficePage> createState() => _OfficePageState();
}

class _OfficePageState extends State<OfficePage> {
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
          _buildNotice(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: ApplicationInit.session.isLogin
          ? FloatingActionButton(
              onPressed: _navigateMessagePage,
              tooltip: i18n.applicationMyMailBox,
              child: const Icon(Icons.mail_outline),
            )
          : null,
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_application.txt,
        actions: [_buildMenuButton(context)],
      ),
      body: Column(
        children: [
          _buildNotice(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: ApplicationInit.session.isLogin
          ? FloatingActionButton(
              onPressed: _navigateMessagePage,
              tooltip: i18n.applicationMyMailBox,
              child: const Icon(Icons.mail_outline),
            )
          : null,
    );
  }

  bool _enableFilter = true;
  List<SimpleFunction> _allFunctions = [];
  String? _lastError;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final functionList = await _fetchFuncList();
        if (!mounted) return;
        setState(() {
          _allFunctions = functionList;
          _lastError = null;
        });
      } on CredentialsInvalidException catch (e) {
        if (!mounted) return;
        setState(() {
          _lastError = e.toString();
        });
      }
    });
    return super.initState();
  }

  Future<List<SimpleFunction>> _fetchFuncList() async {
    if (!ApplicationInit.session.isLogin) {
      final username = Kv.auth.currentUsername!;
      final password = Kv.auth.ssoPassword!;
      await ApplicationInit.session.login(
        username: username,
        password: password,
      );
    }
    return await ApplicationInit.functionService.selectFunctionsByCountDesc();
  }

  Widget _buildFunctionList(List<SimpleFunction> functionList) {
    int count = 0;
    return ListView(
      children: functionList.where((element) => _commonUse.contains(element.id) || !_enableFilter).map((e) {
        count++;
        return buildFunctionItem(e, count <= 3);
      }).toList(),
    );
  }

  Widget _buildBody() {
    if (_lastError != null) {
      return Center(child: Text(_lastError!));
    } else if (_allFunctions.isNotEmpty) {
      return _buildFunctionList(_allFunctions);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildNotice() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: Text(
        i18n.applicationDesc,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget buildFunctionItem(SimpleFunction function, bool hot) {
    final colorIndex = Random().nextInt(_iconColors.length);
    final color = _iconColors[colorIndex];
    final trailing = hot
        ? Row(mainAxisSize: MainAxisSize.min, children: [
            Text(function.count.toString()),
            SvgPicture.asset('assets/common/icon_flame.svg', width: 20, height: 20, color: Colors.orange),
          ])
        : Text(function.count.toString());

    return ListTile(
      leading: SizedBox(height: 40, width: 40, child: Center(child: Icon(function.icon, size: 35, color: color))),
      title: Text(function.name),
      subtitle: Text(function.summary),
      trailing: trailing,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(function)),
        );
      },
    );
  }

  PopupMenuButton _buildMenuButton(BuildContext context) {
    final menuButton = PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              setState(() {
                _enableFilter = !_enableFilter;
              });
            },
            child: Row(
              children: [
                // 禁用checkbox自身的点击效果，点击由外部接管
                AbsorbPointer(
                  child: Checkbox(value: _enableFilter, onChanged: (bool? value) {}),
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

  void _navigateMessagePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagePage()));
  }
}
