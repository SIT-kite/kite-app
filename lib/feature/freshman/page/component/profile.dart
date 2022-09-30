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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/storage/init.dart';

import '../../../../route.dart';
import 'package:kite/l10n/extension.dart';

class InfoItem {
  IconData iconData = Icons.person;
  String title = '';
  String subtitle = '';
  VoidCallback? onTap;
  IconData? trailIconData;

  InfoItem(this.iconData, this.subtitle, this.title, {this.onTap, this.trailIconData});
}

class BasicInfoPageWidget extends StatelessWidget {
  final String name;
  final String college;
  final List<InfoItem> infoItems;
  final Widget? avatar;

  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;
  final String? title;
  const BasicInfoPageWidget({
    required this.name,
    required this.college,
    required this.infoItems,
    this.avatar,
    this.floatingActionButton,
    this.appBarActions,
    this.title,
    Key? key,
  }) : super(key: key);

  final double bgHeight = 250;

  @override
  Widget build(BuildContext context) {
    if (Kv.freshman.freshmanSecret == null) {
      // 若无新生信息
      Navigator.of(context).pushReplacementNamed(RouteTable.freshmanLogin);
    }

    return _buildBackground(context, name, college, infoItems);
  }

  /// 构造默认头像
  Widget buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 3, 99, 172), Color.fromARGB(255, 150, 97, 217)],
            end: Alignment.topCenter,
            begin: Alignment.bottomCenter,
          ),
          boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)]),
      child: Container(
        alignment: const Alignment(0, -0.5),
        child: (name).isEmpty
            ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
            : Text(name[0],
                style: const TextStyle(
                    fontFamily: 'calligraphy',
                    fontSize: 45,
                    color: Colors.white,
                    shadows: [BoxShadow(color: Colors.black54, offset: Offset(2.0, 4.0), blurRadius: 10.0)],
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none)),
      ),
    );
  }

  /// 构造背景及内容
  Widget _buildBackground(BuildContext context, String name, String college, List<InfoItem> list) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? i18n.studentInfoTitle),
        actions: appBarActions,
      ),
      body: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
          children: [
            // 上背景
            Column(
              children: [
                Container(
                  height: bgHeight,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                ),
              ],
            ),

            // 列表
            Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight - 70.h,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: list.map((e) => _buildItem(context, e)).toList(),
              ),
            ),

            // 头像，以后可以加载用户头像，如果有的话
            Positioned(
              top: bgHeight,
              height: MediaQuery.of(context).size.height - bgHeight,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: const Alignment(0.9, -1.2),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: avatar ?? buildDefaultAvatar(),
                ),
              ),
            ),

            //背景文字
            Positioned(
              top: bgHeight - 100,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 30, decoration: TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$college ${i18n.freshman}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: CupertinoColors.white, fontSize: 16, decoration: TextDecoration.none),
                  )
                ],
              ),
            ),
          ]),
      floatingActionButton: floatingActionButton,
    );
  }

  /// 构造列表项
  Widget _buildItem(BuildContext context, InfoItem infoItem) {
    return ListTile(
      textColor: Colors.black,
      leading: SizedBox(
          width: 45,
          height: 45,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                infoItem.iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
          )),
      subtitle: Text(infoItem.subtitle),
      title: Text(infoItem.title),
      onTap: () {
        if (infoItem.onTap != null) infoItem.onTap!();
      },
      trailing: Icon(infoItem.trailIconData),
    );
  }
}
