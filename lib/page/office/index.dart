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
import 'package:kite/entity/office/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/office/index.dart';

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
  Colors.orange,
  Colors.red,
  Colors.blue,
  Colors.grey,
  Colors.black,
  Colors.green,
  Colors.yellow,
  Colors.cyan,
  Colors.purple,
  Colors.teal,
];

class OfficePage extends StatefulWidget {
  const OfficePage({Key? key}) : super(key: key);

  @override
  _OfficePageState createState() => _OfficePageState();
}

class _OfficePageState extends State<OfficePage> {
  bool _isOfficeLogin = SessionPool.officeSession != null;
  bool _enableFilter = true;
  List<SimpleFunction> _allFunctions = [];
  String? _lastError;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final functionList = await _fetchFuncList();
        setState(() {
          _allFunctions = functionList;
          _lastError = null;
        });
      } on OfficeLoginException catch (e) {
        setState(() {
          _lastError = e.toString();
        });
      }
    });
    return super.initState();
  }

  Future<List<SimpleFunction>> _fetchFuncList() async {
    if (!_isOfficeLogin) {
      final username = StoragePool.authSetting.currentUsername!;
      final password = StoragePool.authPool.get(username)!.password;
      SessionPool.officeSession ??= await officeLogin(username, password);
      _isOfficeLogin = true;
    }
    return await selectFunctionsByCountDesc(SessionPool.officeSession!);
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
      child: const Text(
        '本模块及子模块的内容来源于 "上应一网通办"。\n'
        '对于绝大多数业务，您在平台上完成申请后，仍然要去现场办理。',
        overflow: TextOverflow.visible,
      ),
      padding: const EdgeInsets.all(15),
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

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: SizedBox(height: 40, width: 40, child: Center(child: Icon(function.icon, size: 35, color: color))),
        title: Text(function.name),
        subtitle: Text(function.summary),
        trailing: trailing,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(SessionPool.officeSession!, function)),
          );
        },
      ),
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
                const Text('过滤不常用功能'),
              ],
            ),
          ),
        ];
      },
    );
    return menuButton;
  }

  void _navigateMessagePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessagePage(SessionPool.officeSession!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('办公'),
        actions: [_buildMenuButton(context)],
      ),
      body: Column(
        children: [
          _buildNotice(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: _isOfficeLogin
          ? FloatingActionButton(
              onPressed: _navigateMessagePage,
              tooltip: '我的消息',
              child: const Icon(Icons.mail_outline),
            )
          : null,
    );
  }
}
