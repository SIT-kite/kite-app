import 'package:flutter/widgets.dart';
import '../using.dart';

Future<bool> showLeaveGameRequest(BuildContext context) async {
  final confirm = await context.showRequest(
      title: i18n.gameLeaveRequest, desc: i18n.gameLeaveRequestDesc, yes: i18n.yes, no: i18n.no, highlight: true);
  return confirm == true;
}
