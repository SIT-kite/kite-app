import 'package:flutter/cupertino.dart';
import 'package:kite/feature/sit_app/init.dart';
import 'package:kite/session/sit_app_session.dart';
import 'package:kite/util/alert_dialog.dart';

class ArriveCodeDialog {
  static Future<void> scan(BuildContext context, String code) async {
    String msg = '';
    try {
      final response = await SitAppInitializer.arriveCodeService.arrive(code);
      msg = response;
    } on SitAppApiError catch (e, _) {
      if (e.code == 301) {
        msg = '您刚刚已经扫过了';
      } else {
        msg = '${e.msg}';
      }
    }
    await showAlertDialog(context, title: '场所码登记', content: [Text(msg)], actionTextList: ['我知道了']);
  }
}
