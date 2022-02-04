import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'bulletin.dart';
export 'electricity.dart';
export 'expense.dart';
export 'library.dart';
export 'mail.dart';
export 'notice.dart';
export 'office.dart';
export 'report.dart';
export 'score.dart';
export 'timetable.dart';
export 'upgrade.dart';

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
    final titleStyle = Theme.of(context).textTheme.headline3;
    final subtitleStyle = Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black54);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      child: ListTile(
        leading:
            iconWidget ?? SvgPicture.asset(icon!, height: 30.h, width: 30.w, color: Theme.of(context).primaryColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? '', style: subtitleStyle),
        // dense: true,
        onTap: (route != null) ? () => Navigator.of(context).pushNamed(route!) : null,
        style: ListTileStyle.list,
      ),
    );
  }
}
