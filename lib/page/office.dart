import 'package:flutter/material.dart';
import 'package:kite/entity/office.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/office.dart';

import 'office/detail.dart';
import 'office/message.dart';

// 本科生常用功能列表
final Set<String> commonUse = <String>{
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
    return ListView(
      children: functionList
          .where((element) => commonUse.contains(element.id) || !_enableFilter)
          .map(buildFunctionItem)
          .toList(),
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
        '对于绝大多数业务，您在平台完成申请后，仍然要去现场办理。',
        overflow: TextOverflow.visible,
      ),
      padding: const EdgeInsets.all(15),
    );
  }

  Widget buildFunctionItem(SimpleFunction function) {
    return ListTile(
      leading: SizedBox(height: 40, width: 40, child: Center(child: Icon(function.icon, size: 35))),
      title: Text(function.name),
      subtitle: Text(function.summary),
      trailing: Text(function.count.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(SessionPool.officeSession!, function)),
        );
      },
    );
  }

  PopupMenuButton _buildMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _enableFilter,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableFilter = value ?? true;
                    });
                  },
                ),
                const Text('过滤不常用功能')
              ],
            ),
          ),
        ];
      },
    );
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildNotice(), flex: 1),
            Expanded(child: _buildBody(), flex: 10),
          ],
        ),
      ),
      floatingActionButton: _isOfficeLogin
          ? FloatingActionButton(
              onPressed: _navigateMessagePage,
              tooltip: '我的消息',
              child: const Icon(Icons.mail_outline),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}
