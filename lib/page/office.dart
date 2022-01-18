import 'package:flutter/material.dart';
import 'package:kite/entity/office.dart';
import 'package:kite/service/office.dart';
import 'package:kite/storage/auth.dart';
import 'package:kite/util/flash.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  AuthStorage? user;
  OfficeSession? session;
  bool enableFilter = true;

  Future<AuthStorage> _queryLocalCredential() async => AuthStorage(await SharedPreferences.getInstance());

  Future<List<SimpleFunction>> _fetchFuncList() async {
    user = await _queryLocalCredential();
    session = await login(user!.username, user!.password);
    return await selectFunctionsByCountDesc(session!);
  }

  Widget _buildFunctionList(List<SimpleFunction> functionList) {
    return ListView(
      children: functionList
          .where((element) => commonUse.contains(element.id) || !enableFilter)
          .map(buildFunctionItem)
          .toList(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<SimpleFunction>>(
      future: _fetchFuncList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<SimpleFunction> result = snapshot.data!;
          return _buildFunctionList(result);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
          MaterialPageRoute(builder: (_) => DetailPage(session!, function)),
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
                  value: enableFilter,
                  onChanged: (bool? value) {
                    setState(() {
                      enableFilter = value ?? true;
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
    if (session != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessagePage(session!)));
    } else {
      showBasicFlash(context, const Text('办公模块还未登录，再试试？'));
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateMessagePage,
        tooltip: '我的消息',
        child: const Icon(Icons.mail_outline),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
