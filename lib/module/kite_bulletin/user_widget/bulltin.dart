import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/bulletin.dart';
import '../using.dart';

class BulletinCard extends StatelessWidget {
  final KiteBulletin bulletin;

  const BulletinCard(this.bulletin, {super.key});

  @override
  Widget build(BuildContext context) {
    return [
      _buildTitle(context, bulletin),
      Text(context.dateNum(bulletin.publishTime), style: const TextStyle(color: Colors.grey))
          .align(at: Alignment.bottomRight),
      [
        // 标题, 注意遇到长标题时要折断
        // 日期
        const SizedBox(height: 10),
        // 正文
        MyMarkdownWidget(bulletin.content ?? '').expanded(),
      ].row(maa: MainAxisAlignment.spaceBetween)
    ]
        .column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min)
        .padAll(10)
        .inCard(elevation: 5)
        .padSymmetric(h: 10.h, v: 2.h);
  }
}

class BulletinPreview extends StatelessWidget {
  final KiteBulletin bulletin;

  const BulletinPreview(this.bulletin, {super.key});

  @override
  Widget build(BuildContext context) {
    return [
      _buildTitle(context, bulletin),
      context
          .dateNum(bulletin.publishTime)
          .text(style: const TextStyle(color: Colors.grey))
          .align(at: Alignment.bottomRight),
    ].column().inCard(elevation: 8).padAll(10);
  }
}

Widget _buildTitle(BuildContext ctx, KiteBulletin bulletin) {
  if (bulletin.top) {
    return [const Icon(Icons.push_pin_rounded), _buildTitleText(ctx, bulletin.title)].row();
  } else {
    return _buildTitleText(ctx, bulletin.title);
  }
}

Widget _buildTitleText(BuildContext ctx, String title) {
  return title.text(overflow: TextOverflow.ellipsis, style: Theme.of(ctx).textTheme.headline3);
}
