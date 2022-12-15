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

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/module/activity/using.dart';
import 'package:rettulf/rettulf.dart';

import '../dao/Freshman.dart';
import '../entity/info.dart';
import '../init.dart';
import '../using.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final FreshmanDao service = FreshmanInit.freshmanDao;

  /// 初始状态
  String qqInit = "";
  String wechatInit = "";
  String telInit = "";
  bool visibilityInit = false;

  /// 状态变量
  bool visibility = false;
  final $qq = TextEditingController();
  final $wechat = TextEditingController();
  final $tel = TextEditingController();

  @override
  void initState() {
    super.initState();
    service.getMyInfo().then((info) {
      setState(() {
        final contact = info.contact;
        if (contact != null) {
          wechatInit = contact.wechat;
          qqInit = contact.qq;
          telInit = contact.tel;
          visibilityInit = info.visible;
        }
        visibility = visibilityInit;
        $qq.text = qqInit;
        $wechat.text = wechatInit;
        $tel.text = telInit;
      });
    });
  }

  bool anyChanged() {
    return qqInit != $qq.text || wechatInit != $wechat.text || telInit != $tel.text || visibilityInit != visibility;
  }

  Future<void> tryUpdate() async {
    // 没更改信息直接不管
    if (!anyChanged()) return;
    try {
      // 更新信息
      await service.updateMyContact(
        contact: Contact()
          ..qq = $qq.text
          ..wechat = $wechat.text
          ..tel = $tel.text,
        visible: visibility,
      );
    } catch (e) {
      Log.info("Can't update freshman info. $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: context.isPortrait ? buildPortrait(context) : buildLandscape(context),
        onWillPop: () async {
          tryUpdate();
          return true;
        });
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.personalInfoTitle.text(),
      ),
      body: [
        Icon(
          Icons.group_outlined,
          size: 120,
          color: context.darkSafeThemeColor,
        ).flexible(flex: 1),
        _buildBody().flexible(flex: 2),
      ].column().padAll(8),
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: [
          i18n.personalInfoTitle.text(),
          Icon(Icons.group_outlined, color: context.darkSafeThemeColor),
        ].row(),
      ),
      body: _buildBody().padAll(8),
    );
  }

  Widget _buildBody() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildField(i18n.wechat, Icons.wechat, $wechat),
            buildField(i18n.qq, Icons.person, $qq),
            buildField(i18n.phoneNumber, Icons.phone, $tel),
            [
              Text(
                i18n.allowOthersFindMeCheckbox,
                style: Theme.of(context).textTheme.headline3,
              ),
              CupertinoSwitch(
                value: visibility,
                onChanged: (newVal) {
                  setState(() {
                    visibility = newVal;
                  });
                },
              ),
            ].row(maa: MainAxisAlignment.spaceBetween).padAll(8),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                i18n.personalInfoDescLabel,
                style: Theme.of(context).textTheme.headline3,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String? fieldName,
    IconData iconData,
    TextEditingController textEditingController,
  ) {
    return TextFormField(
      autofocus: true,
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: fieldName,
        hintText: i18n.unfilled,
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
