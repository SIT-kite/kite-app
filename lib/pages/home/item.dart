import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final String routeName;
  final Icon icon;
  final String title;

  const ItemWidget(this.routeName, this.icon, this.title, {Key? key});

  @override
  _ItemWidgetState createState() => _ItemWidgetState(routeName, icon, title);
}

class _ItemWidgetState extends State<ItemWidget> {
  String routeName;
  Icon icon;
  String title;
  String content = "加载中";

  _ItemWidgetState(this.routeName, this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);
    final contentStyle = TextStyle().copyWith(fontSize: 15);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        // decoration: BoxDecoration(
        // border: Border.all(
        //   color: Colors.transparent,
        //   width: 0,
        //   style: BorderStyle.none,
        // ),
        // ),
        child: Column(children: [
          Row(children: [Text(title, style: titleStyle)]),
          const SizedBox(height: 2.0),
          Row(children: [Text(content, style: contentStyle)]),
        ]),
      ),
    );
  }
}
