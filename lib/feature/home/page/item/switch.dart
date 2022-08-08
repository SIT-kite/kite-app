import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/route.dart';

import 'index.dart';

class SwitchAccountItem extends StatelessWidget {
  const SwitchAccountItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeFunctionButton(
      route: RouteTable.login,
      iconWidget: Icon(Icons.switch_account, size: 30.h, color: Theme.of(context).primaryColor),
      title: '切换用户',
      subtitle: '切换到正式用户',
    );
  }
}
