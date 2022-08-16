import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/setting/dao/index.dart';
import 'package:kite/setting/init.dart';

import 'index.dart';

class FreshmanItem extends StatelessWidget {
  const FreshmanItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userType = SettingInitializer.auth.userType!;
    // 老师根本不会显示这个列表项
    // 所以只考虑正式学生的情况
    if (userType != UserType.freshman) {
      // 正式学生，获取学号
      final username = SettingInitializer.auth.currentUsername!;
      // 取今年的后两位，若今年的后两位大于学号前两位
      // 说明已经不是新生了
      if (DateTime.now().year % 100 > int.parse(username.substring(0, 2))) {
        return Container();
      }
    }
    return HomeFunctionButton(
      route: '/freshman',
      iconWidget: Icon(Icons.people, size: 30.h, color: Theme.of(context).primaryColor),
      title: '入学信息',
      subtitle: '新生入学信息查询',
    );
  }
}
