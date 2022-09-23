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

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/component/my_switcher.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/flash.dart';

import '../../../component/future_builder.dart';
import '../dao.dart';
import '../init.dart';

class FreshmanUpdatePage extends StatefulWidget {
  const FreshmanUpdatePage({Key? key}) : super(key: key);

  @override
  State<FreshmanUpdatePage> createState() => _FreshmanUpdatePageState();
}

class _FreshmanUpdatePageState extends State<FreshmanUpdatePage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  /// 初始状态
  late String initialQq;
  late String initialWechat;
  late String initialTel;
  late bool initialVisible;

  /// 状态变量
  late bool visibleState;
  TextEditingController qqTextEditingController = TextEditingController();
  TextEditingController wechatTextEditingController = TextEditingController();
  TextEditingController telTextEditingController = TextEditingController();

  /// 初始化初始态变量
  void makeInitialState(FreshmanInfo info) {
    final contact = info.contact;
    initialWechat = contact?.wechat ?? '';
    initialQq = contact?.qq ?? '';
    initialTel = contact?.tel ?? '';

    initialVisible = info.visible;
    visibleState = initialVisible;
    qqTextEditingController.text = initialQq;
    wechatTextEditingController.text = initialWechat;
    telTextEditingController.text = initialTel;
  }

  /// 判断信息是否发生变更
  bool hasChanged() {
    // 只要存在一种发生变更的情况就判定为被更改
    return [
      qqTextEditingController.text != initialQq,
      wechatTextEditingController.text != initialWechat,
      telTextEditingController.text != initialTel,
      visibleState != initialVisible,
    ].contains(true);
  }

  Future<void> update() async {
    // 没更改信息直接不管
    if (!hasChanged()) return;
    // 更新信息
    await freshmanDao.update(
      contact: Contact()
        ..qq = qqTextEditingController.text
        ..wechat = wechatTextEditingController.text
        ..tel = telTextEditingController.text,
      visible: visibleState,
    );
    // 销毁后当前组件的context将不存在
    // Catcher中存放了上一个父节点的context可以继续用
    showBasicFlash(Catcher.navigatorKey!.currentContext!, const Text('信息更新完成'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隐私安全'),
      ),
      body: MyFutureBuilder<FreshmanInfo>(
        future: freshmanDao.getInfo(),
        builder: (context, data) {
          makeInitialState(data);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBody(data),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    update();
    super.dispose();
  }

  Widget _buildBody(FreshmanInfo info) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTextFormField(i18n.wechat, Icons.wechat, wechatTextEditingController),
            buildTextFormField(i18n.qq, Icons.person, qqTextEditingController),
            buildTextFormField(i18n.phoneNumber, Icons.phone, telTextEditingController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '允许可能认识的人发现我',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  MySwitcher(
                    visibleState,
                    onChanged: (bool value) => visibleState = value,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'PS: 本页填写的信息将使同学，舍友之间可见，以方便大家互相添加好友，组建群聊',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(
    String? fieldName,
    IconData iconData,
    TextEditingController textEditingController,
  ) {
    return TextFormField(
      autofocus: true,
      controller: textEditingController,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black),
        labelText: fieldName,
        hintText: i18n.unfilled,
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
