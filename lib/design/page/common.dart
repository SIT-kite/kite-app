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
import 'package:rettulf/rettulf.dart';

import '../colors.dart';

class LeavingBlank extends StatelessWidget {
  final WidgetBuilder iconBuilder;
  final String desc;
  final VoidCallback? onIconTap;
  final Widget? subtitle;

  const LeavingBlank.builder({super.key, required this.iconBuilder, required this.desc, this.onIconTap, this.subtitle});

  factory LeavingBlank({
    Key? key,
    required IconData icon,
    required String desc,
    VoidCallback? onIconTap,
    double size = 120,
    Widget? subtitle,
  }) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => icon.make(size: size, color: ctx.darkSafeThemeColor),
      desc: desc,
      onIconTap: onIconTap,
      subtitle: subtitle,
    );
  }

  factory LeavingBlank.svgAssets({
    Key? key,
    required String assetName,
    required String desc,
    VoidCallback? onIconTap,
    double width = 120,
    double height = 120,
    Widget? subtitle,
  }) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => SvgPicture.asset(assetName, width: width, height: height),
      desc: desc,
      onIconTap: onIconTap,
      subtitle: subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = iconBuilder(context).padAll(20);
    if (onIconTap != null) {
      icon = icon.on(tap: onIconTap);
    }
    final sub = subtitle;
    if (sub != null) {
      return [
        icon.expanded(),
        [
          buildDesc(context),
          sub,
        ].column().expanded(),
      ].column(maa: MAAlign.spaceAround).center();
    } else {
      return [
        icon.expanded(),
        buildDesc(context).expanded(),
      ].column(maa: MAAlign.spaceAround).center();
    }
  }

  Widget buildDesc(BuildContext ctx) {
    return desc
        .text(
          style: ctx.textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
        .center()
        .padAll(10);
  }
}
