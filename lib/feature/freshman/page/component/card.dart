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

import 'common.dart';

class PersonItemCardWidget extends StatefulWidget {
  final String name;
  final String lastSeenText;
  final String? locationText;
  final VoidCallback? onLoadMore;
  final Widget basicInfoWidget;
  final bool isMale;
  final double? height;

  const PersonItemCardWidget({
    required this.basicInfoWidget,
    required this.name,
    required this.lastSeenText,
    required this.locationText,
    required this.isMale,
    this.height,
    this.onLoadMore,
    Key? key,
  }) : super(key: key);

  @override
  State<PersonItemCardWidget> createState() => _PersonItemCardWidgetState();
}

class _PersonItemCardWidgetState extends State<PersonItemCardWidget> {
  Widget buildMoreButton() {
    return GestureDetector(
      onTap: widget.onLoadMore,
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
          text: ' 更多信息',
          fontSize: 20,
          context: context,
        )),
      ),
    );
  }

  Widget buildLastSeen() {
    return buildInfoItemRow(
      iconData: Icons.timelapse,
      text: "${widget.lastSeenText}在线",
      fontSize: 14,
      iconSize: 20,
      context: context,
    ).withOrangeBarStyle(context);
  }

  Widget buildLocation() {
    final loc = widget.locationText;
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
        text: '在宇宙漫游哦',
        fontSize: 14,
        iconSize: 17,
        context: context,
      ).withOrangeBarStyle(context);
    }
  }

  /// 嵌套InkWell实现水波纹点击效果  组合（头像，背景卡片，位置卡片和上次登录卡片）左区 和（信息组件）右区
  Widget buildContent() {
    return InkWell(
      onTap: widget.onLoadMore,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 6,
            child: Stack(children: [
              Align(
                alignment: const Alignment(0, -0.7),
                child: buildAvatar(name: widget.name),
              ),
              Positioned(
                top: 120,
                left: 0,
                child: buildLastSeen(),
              ),
              Positioned(
                top: 165,
                left: 0,
                child: buildLocation(),
              )
            ]),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.basicInfoWidget,
            ),
          )
        ],
      ),
    );
  }

  /// 性别icon印章
  Widget buildSexIcon() {
    return Icon(
      widget.isMale ? Icons.male : Icons.female,
      size: 100,
      color: Colors.black.withAlpha(100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor]),
            // color: Theme.of(context).primaryColor.withAlpha(200),
            borderRadius: BorderRadius.circular(15.0), //像素圆角
            boxShadow: const [
              //阴影
              BoxShadow(color: Colors.black12, offset: Offset(7.0, 7.0), blurRadius: 4.0)
            ],
          ),
          child: SizedBox(
            height: widget.height,
            width: MediaQuery.of(context).size.width - 20.w,
            child: buildContent(),
          ),
        ),
      ],
    );
  }
}
