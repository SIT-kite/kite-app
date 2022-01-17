import 'package:flutter/material.dart';
import 'package:kite/page/game/old_game/constants.dart';
import 'package:kite/page/game/old_game/index.dart';

class WebGameListPage extends StatelessWidget {
  const WebGameListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile buildItem(String title, String url) {
      return ListTile(
          title: Text(title),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => WebPageGamePage(url),
            ));
          });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('模拟器游戏列表')),
      body: ListView(
        children: gameList.map((e) => buildItem(e[0], e[1])).toList(),
      ),
    );
  }
}
