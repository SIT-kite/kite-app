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
import 'package:flutter_svg/svg.dart';
import 'package:kite/design/colors.dart';
import 'package:kite/design/utils.dart';
import 'package:kite/module/application/using.dart';

typedef IconBuilder = Widget Function(double size, Color color);
// ignore: non_constant_identifier_names
IconBuilder SysIcon(IconData icon) {
  return (size, color) => Icon(icon, size: size, color: color);
}

// ignore: non_constant_identifier_names
IconBuilder SvgAssetIcon(String path) {
  return (size, color) => SvgPicture.asset(path, width: size, height: size, color: color);
}

// ignore: non_constant_identifier_names
IconBuilder SvgNetworkIcon(String path) {
  return (size, color) => SvgPicture.network(path, width: size, height: size, color: color);
}

class Brick extends StatefulWidget {
  final String? route;
  final Map<String, dynamic>? routeArgs;
  final IconBuilder icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  const Brick({
    this.route,
    this.routeArgs,
    this.onPressed,
    required this.title,
    this.subtitle,
    required this.icon,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BrickState();
}

class _BrickState extends State<Brick> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle? titleStyle;
    final TextStyle? subtitleStyle;
    final Color bg;
    final Color iconColor = context.darkSafeThemeColor;
    final titleStyleRaw = theme.textTheme.headline4;
    if (theme.isLight) {
      titleStyle = titleStyleRaw?.copyWith(color: Color.lerp(titleStyleRaw.color, iconColor, 0.6));
      subtitleStyle = theme.textTheme.bodyText2?.copyWith(color: Colors.black87);
      bg = Colors.white.withOpacity(0.6);
    } else {
      titleStyle = titleStyleRaw?.copyWith(color: Color.lerp(titleStyleRaw.color, iconColor, 0.8));
      subtitleStyle = theme.textTheme.bodyText2?.copyWith(color: theme.textTheme.headline4?.color);
      bg = Colors.black87.withOpacity(0.2);
    }
    return Container(
      decoration: BoxDecoration(color: bg),
      child: ListTile(
        leading: widget.icon(48, iconColor),
        title: Text(widget.title, style: titleStyle),
        subtitle: Text(widget.subtitle ?? '', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        // dense: true,
        onTap: () {
          widget.onPressed?.call();
          final dest = widget.route;
          if (dest != null) {
            Navigator.of(context).pushNamed(dest, arguments: widget.routeArgs);
          }
        },
        style: ListTileStyle.list,
      ),
    );
  }
}
