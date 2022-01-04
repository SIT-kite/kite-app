import 'package:flutter/material.dart';
import 'package:kite/pages/office/apply.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kite/services/office/office.dart';
import 'package:kite/storage/auth.dart';

const String functionMainPage = 'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=123';

class OfficePage extends StatefulWidget {
  const OfficePage({Key? key}) : super(key: key);

  @override
  _OfficePageState createState() => _OfficePageState();
}

class _OfficePageState extends State<OfficePage> {
  List<SimpleFunction> _functionList = [];
  AuthStorage? user;
  OfficeSession? session;

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

        selectFunctions(session!).then(
          (value) => setState(() {
            _functionList = value;
          }),
        );
      }
    });
  }

  Widget buildFunctionItem(SimpleFunction function) {
    return ListTile(
      leading: SizedBox(height: 40, width: 40, child: Center(child: Icon(function.icon, size: 35))),
      title: Text(function.name),
      subtitle: Text(function.summary),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ApplyPage('123')),
        );
      },
    );
  }

  Widget buildFunctionList() {
    return ListView(
      children: _functionList.map(buildFunctionItem).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('办公')),
      body: SafeArea(child: buildFunctionList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: '我的消息',
        child: const Icon(Icons.mail_outline),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
