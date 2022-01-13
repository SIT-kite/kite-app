import 'package:flutter/material.dart';
import 'package:kite/pages/office/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kite/services/office/office.dart';
import 'package:kite/storage/auth.dart';

import 'office/detail.dart';

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
  List<SimpleFunction> _functionList = [];
  AuthStorage? user;
  OfficeSession? session;

  bool enableFilter = true;

  Future<AuthStorage> _queryLocalCredential() async => AuthStorage(await SharedPreferences.getInstance());

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      user = await _queryLocalCredential();

      if (user != null && user!.username != '') {
        session = await login(user!.username, user!.password);
        if (session == null) {
          return;
        }

        selectFunctionsByCountDesc(session!).then(
          (value) => setState(() {
            _functionList = value;
          }),
        );
      }
    });
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

  Widget _buildFunctionList() {
    return ListView(
      children: _functionList
          .where((element) => commonUse.contains(element.id) || !enableFilter)
          .map(buildFunctionItem)
          .toList(),
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessagePage(session!)));
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
            Expanded(child: _buildFunctionList(), flex: 10),
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
