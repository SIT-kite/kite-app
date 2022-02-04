import 'package:flutter/material.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/page/home/item/item.dart';

class MailItem extends StatefulWidget {
  const MailItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MailItemState();
}

class _MailItemState extends State<MailItem> {
  static const defaultContent = '查看校园邮箱中的邮件';
  String content = defaultContent;

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {}

  @override
  Widget build(BuildContext context) {
    return HomeItem(
      route: '/mail',
      icon: 'assets/home/icon_mail.svg',
      title: 'Edu 邮箱',
      subtitle: content,
    );
  }
}
