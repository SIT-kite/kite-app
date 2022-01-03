import 'package:flutter/material.dart';
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

  Future<AuthStorage> _queryLocalCredential() async => AuthStorage(await SharedPreferences.getInstance());

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final AuthStorage credential = await _queryLocalCredential();

      if (credential.username != '') {
        final OfficeSession? session = await login(credential.username, credential.password);
        if (session == null) {
          return;
        }

        selectFunctions(session).then(
          (value) => setState(() {
            _functionList = value;
          }),
        );
      }
    });
  }

  Widget buildFunctionItem(SimpleFunction function) {
    return ListTile(
      title: Text(function.name),
      subtitle: Text(function.summary),
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
