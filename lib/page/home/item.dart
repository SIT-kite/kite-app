import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'item/electricity.dart';
export 'item/expense.dart';
export 'item/library.dart';
export 'item/office.dart';
export 'item/report.dart';
export 'item/score.dart';
export 'item/timetable.dart';

class HomeItem extends StatelessWidget {
  final String route;
  final String icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;

  const HomeItem({
    required this.route,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.bold);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      child: ListTile(
        leading: iconWidget ?? SvgPicture.asset(icon, height: 30, width: 30, color: Theme.of(context).primaryColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? ''),
        // dense: true,
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        style: ListTileStyle.list,
      ),
    );
  }
}
