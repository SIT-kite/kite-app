import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'index.dart';

class FreshmanItem extends StatelessWidget {
  const FreshmanItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeFunctionButton(
      route: '/freshman',
      iconWidget: Icon(Icons.people, size: 30.h, color: Theme.of(context).primaryColor),
      title: '迎新',
      subtitle: '新生入学查询',
    );
  }
}
