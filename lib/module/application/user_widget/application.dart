import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

import '../design.dart';
import '../entity/function.dart';
import '../page/detail.dart';
import 'dart:math';

class ApplicationTile extends StatelessWidget {
  final ApplicationMeta item;
  final bool isHot;

  const ApplicationTile({super.key, required this.item, required this.isHot});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random(item.id.hashCode).nextInt(iconColors.length);
    final color = iconColors[colorIndex];
    final Widget views;
    if (isHot) {
      views = [
        Text(item.count.toString()),
        SvgPicture.asset('assets/common/icon_flame.svg', width: 20, height: 20, color: Colors.orange),
      ].row(mas: MainAxisSize.min);
    } else {
      views = Text(item.count.toString());
    }

    return ListTile(
      leading: SizedBox(height: 40, width: 40, child: Center(child: Icon(item.icon, size: 35, color: color))),
      title: Text(item.name),
      subtitle: Text(item.summary),
      trailing: views,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(item)),
        );
      },
    );
  }
}
