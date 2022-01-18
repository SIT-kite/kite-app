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
  String subtitle = "加载中";

  _HomeItemState(this.routeName, this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);
    final subtitleStyle = const TextStyle().copyWith(fontSize: 15);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
        ),
        child: ListTile(
          leading: Image(image: icon, height: 30, width: 30),
          title: Text(title, style: titleStyle),
          subtitle: Text(subtitle, style: subtitleStyle),
          dense: true,
        ),
      ),
    );
  }
}
