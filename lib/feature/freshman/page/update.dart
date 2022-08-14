import 'dart:core';

import 'package:catcher/catcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/util/flash.dart';

import '../../../component/future_builder.dart';
import '../dao.dart';
import '../init.dart';

class MySwitcher extends StatefulWidget {
  final bool initialState;
  final ValueChanged<bool>? onChanged;

  const MySwitcher(this.initialState, {this.onChanged, Key? key}) : super(key: key);

  @override
  State<MySwitcher> createState() => _MySwitcherState();
}

class _MySwitcherState extends State<MySwitcher> {
  late bool state;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.green,
      value: state,
      onChanged: (value) {
        setState(() {
          state = value;
          if (widget.onChanged != null) {
            widget.onChanged!(state);
          }
        });
      },
    );
  }
}

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
    if (contact != null) {
      initialWechat = contact.wechat ?? '';
      initialQq = contact.qq ?? '';
      initialTel = contact.tel ?? '';
    }
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
          return _buildBody(data);
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
      child: Column(
        children: [
          buildTextFormField('微信', Icons.wechat, wechatTextEditingController),
          buildTextFormField('QQ', Icons.person, qqTextEditingController),
          buildTextFormField('手机号', Icons.phone, telTextEditingController),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '是否允许可能认识的人发现自己？',
                style: Theme.of(context).textTheme.headline3,
              ),
              MySwitcher(
                visibleState,
                onChanged: (bool value) => visibleState = value,
              ),
            ],
          ),
        ],
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
        hintText: '未填写',
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
