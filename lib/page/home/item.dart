import 'package:flutter/material.dart';

class HomeItem extends StatefulWidget {
  final String route;
  final AssetImage icon;
  final String title;

  const HomeItem(this.route, this.icon, this.title, {Key? key}) : super(key: key);

  @override
  _HomeItemState createState() => _HomeItemState(route, icon, title);
}

class _HomeItemState extends State<HomeItem> {
  String routeName;
  AssetImage icon;
  String title;
  String content = "加载中";

  _HomeItemState(this.routeName, this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);
    final contentStyle = const TextStyle().copyWith(fontSize: 15);

    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Image(image: icon, width: 30, height: 30),
              ),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text(title, style: titleStyle)]),
              const SizedBox(height: 2.0),
              Row(children: [Text(content, style: contentStyle)]),
            ])
          ]),
        ));
  }
}
