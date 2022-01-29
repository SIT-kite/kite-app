import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'item/electricity.dart';
export 'item/expense.dart';
export 'item/library.dart';
export 'item/notice.dart';
export 'item/office.dart';
export 'item/report.dart';
export 'item/score.dart';
export 'item/timetable.dart';
export 'item/upgrade.dart';

class HomeItem extends StatelessWidget {
  final String? route;
  final String? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;

  HomeItem({
    this.route,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    Key? key,
  }) : super(key: key) {
    assert(icon != null || iconWidget != null);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle().copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      child: ListTile(
        leading:
            iconWidget ?? SvgPicture.asset(icon!, height: 30.h, width: 30.w, color: Theme.of(context).primaryColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? ''),
        // dense: true,
        onTap: (route != null) ? () => Navigator.of(context).pushNamed(route!) : null,
        style: ListTileStyle.list,
      ),
    );
  }
}
