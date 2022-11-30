import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

Widget  buildLeavingBlankBody(BuildContext ctx,
    {required IconData icon, required String desc, VoidCallback? onIconTap}) {
  return [
    if (onIconTap == null)
      icon.make(size: 120).padAll(20)
    else
      GestureDetector(onTap: onIconTap, child: Icon(icon, size: 120).padAll(20)),
    desc.text(
      style: ctx.theme.textTheme.titleLarge,
    ),
  ].column(maa: MAAlign.spaceAround).center();
}
