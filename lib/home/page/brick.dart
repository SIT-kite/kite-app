/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/design/colors.dart';
import 'package:kite/design/utils.dart';

class Brick extends StatelessWidget {
  final String? route;
  final String? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  Brick({
    this.route,
    this.onPressed,
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
    final theme = Theme.of(context);
    final TextStyle? titleStyle;
    final TextStyle? subtitleStyle;
    final Color bg;
    final Color iconColor;
    if (theme.isLight) {
      titleStyle = theme.textTheme.headline4?.copyWith(color: theme.textTheme.headline2?.color);
      subtitleStyle = theme.textTheme.bodyText2?.copyWith(color: Colors.black87);
      bg = Colors.white.withOpacity(0.6);
      iconColor = context.themeColor;
    } else {
      titleStyle = theme.textTheme.headline4?.copyWith(color: theme.textTheme.headline2?.color);
      subtitleStyle = theme.textTheme.bodyText2?.copyWith(color: theme.textTheme.headline4?.color);
      bg = Colors.black87.withOpacity(0.2);
      iconColor = Colors.white70;
    }
    return Container(
      decoration: BoxDecoration(color: bg),
      child: ListTile(
        leading: iconWidget ?? SvgPicture.asset(icon!, height: 30.h, width: 30.w, color: iconColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? '', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        // dense: true,
        onTap: () {
          if (onPressed != null) {
            onPressed!();
            return;
          }
          if (route != null) {
            Navigator.of(context).pushNamed(route!);
          }
        },
        style: ListTileStyle.list,
      ),
    );
  }
}
