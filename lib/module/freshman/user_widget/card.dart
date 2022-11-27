/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/l10n/extension.dart';

import 'common.dart';

class PersonItemWidget extends StatelessWidget {
  final String name;
  final String lastSeenText;
  final String? locationText;
  final VoidCallback? onLoadMore;
  final Widget basicInfoWidget;
  final bool isMale;
  final double? height;

  const PersonItemWidget({
    required this.basicInfoWidget,
    required this.name,
    required this.lastSeenText,
    required this.locationText,
    required this.isMale,
    this.height,
    this.onLoadMore,
    Key? key,
  }) : super(key: key);

  Widget buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: onLoadMore,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(5.0)), //像素圆角
            boxShadow: const [
              //阴影
              BoxShadow(color: Colors.black54, offset: Offset(7.0, 7.0), blurRadius: 4.0)
            ]),
        child: (buildInfoItemRow(
          iconData: Icons.send,
          text: context.l.moreInfoTitle,
          fontSize: 20,
          context: context,
        )),
      ),
    );
  }

  Widget buildLastSeen(BuildContext context) {
    return buildInfoItemRow(
      iconData: Icons.timelapse,
      text: lastSeenText,
      fontSize: 14,
      iconSize: 20,
      context: context,
    ).withOrangeBarStyle(context);
  }

  Widget buildLocation(BuildContext context) {
    final loc = locationText;
    if (loc != null) {
      return buildInfoItemRow(
        iconData: Icons.room,
        text: loc,
        fontSize: 14,
        iconSize: 20,
        context: context,
      ).withOrangeBarStyle(context);
    } else {
      return buildInfoItemRow(
        iconData: Icons.room,
        text: i18n.noLocationLabel,
        fontSize: 14,
        iconSize: 17,
        context: context,
      ).withOrangeBarStyle(context);
    }
  }

  /// 嵌套InkWell实现水波纹点击效果  组合（头像，背景卡片，位置卡片和上次登录卡片）左区 和（信息组件）右区
  Widget buildContent(BuildContext context) {
    return InkWell(
      onTap: onLoadMore,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 6,
            child: Stack(children: [
              Align(
                alignment: const Alignment(0, -0.7),
                child: buildAvatar(context, name: name),
              ),
              Positioned(
                top: 120,
                left: 0,
                child: buildLastSeen(context),
              ),
              Positioned(
                top: 165,
                left: 0,
                child: buildLocation(context),
              )
            ]),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: basicInfoWidget,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4.0), //像素圆角
          ),
          child: SizedBox(
            height: height,
            width: MediaQuery.of(context).size.width - 20.w,
            child: buildContent(context),
          ),
        ),
      ],
    );
  }
}
