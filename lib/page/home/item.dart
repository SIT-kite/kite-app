import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final String route;
  final AssetImage icon;
  final String title;
  final Future<String?> Function()? callback;

  const HomeItem({required this.route, required this.icon, required this.title, this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
        ),
        child: ListTile(
          leading: Image(image: icon, height: 30, width: 30),
          title: Text(title, style: titleStyle),
          subtitle: callback != null
              ? FutureBuilder(
                  future: callback!(),
                  builder: (BuildContext build, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data ?? '');
                    }
                    return const Text('加载中…');
                  },
                )
              : Container(),
          dense: true,
        ),
      ),
    );
  }
}
