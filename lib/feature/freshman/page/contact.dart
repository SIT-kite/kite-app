import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/feature/freshman/page/component/staticValue.dart';

import '../../../component/future_builder.dart';
import '../dao.dart';
import '../init.dart';

class FreshmanContactPage extends StatefulWidget {
  const FreshmanContactPage({Key? key}) : super(key: key);

  @override
  State<FreshmanContactPage> createState() => _FreshmanContactPageState();
}

class _FreshmanContactPageState extends State<FreshmanContactPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  TextEditingController qqTextEditingController = TextEditingController();
  TextEditingController wechatTextEditingController = TextEditingController();
  TextEditingController telTextEditingController = TextEditingController();
  bool isEditAble = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('隐私安全'),
        ),
        body: MyFutureBuilder<FreshmanInfo>(
            future: freshmanDao.getInfo(),
            builder: (context, data) {
              return _buildBody(data);
            }));
  }

  Widget _buildBody(FreshmanInfo info) {
    return Column(
      children: [
        _buildEditTextField(isEditAble, '微信', info.contact?.wechat, Icons.wechat, wechatTextEditingController),
        _buildEditTextField(isEditAble, 'QQ', info.contact?.qq, Icons.person, qqTextEditingController),
        _buildEditTextField(isEditAble, '手机号', info.contact?.tel, Icons.phone, telTextEditingController),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                  activeColor: Colors.green,
                  value: info.visible,
                  onChanged: (value) {
                    setState(() {
                      freshmanDao.update(visible: !info.visible);
                    });
                  }),
            ),
            SizedBox(width: 5.w),
            Text(
              info.visible ? '信息可见' : '信息不可见',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("编辑信息"),
              onPressed: () {
                setState(() {
                  isEditAble = !isEditAble;
                });
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            ElevatedButton(
                onPressed: () {
                  //同时刷新页面
                  setState(() {
                    if ([null, ''].contains(telTextEditingController.text))
                      StaticValue.updateContact.tel = telTextEditingController.text;
                    if ([null, ''].contains(qqTextEditingController.text))
                      StaticValue.updateContact.qq = qqTextEditingController.text;
                    if ([null, ''].contains(wechatTextEditingController.text))
                      StaticValue.updateContact.wechat = wechatTextEditingController.text;
                    freshmanDao.update(contact: StaticValue.updateContact);
                  });
                },
                child: const Text("更新信息")),
          ],
        )
      ],
    );
  }

  Widget _buildEditTextField(
      bool isEditAble, String text, String? info, IconData iconData, TextEditingController textEditingController) {
    return TextField(
      enabled: isEditAble,
      autofocus: true,
      controller: textEditingController,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          labelText: !['', null].contains(info) ? info : '$text未填写',
          hintText: '你的$text',
          prefixIcon: Icon(iconData)),
    );
  }
}
