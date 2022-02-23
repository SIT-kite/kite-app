import 'package:format/format.dart';
import 'package:kite/dao/sc/join.dart';
import 'package:kite/entity/sc/join.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class ScJoinActivityService extends AService implements ScJoinActivityDao {
  static const _applyActivity = 'http://sc.sit.edu.cn/public/pcenter/checkUser.action?activityId=';

  static const _applySuccess = 'http://sc.sit.edu.cn/public/pcenter/applyActivity.action?activityId=';

  ScJoinActivityService(ASession session) : super(session);

  /// 参加活动
  @override
  Future<String> process(ScJoinActivity item) async {
    if (item.force) {
      var applyUrl = format('{}{}', _applySuccess, item.activityId);
      final response = await session.get(applyUrl);
      String result = response.data;
      return result;
    } else {
      var applyUrl = format('{}{}', _applyActivity, item.activityId);
      final response = await session.post(applyUrl);
      String result = response.data;
      var message = _fromHtml(result);

      switch (message) {
        case 0:
          {
            var applyUrl = format('{}{}', _applySuccess, item.activityId);
            await session.get(applyUrl);
            return '申请成功';
          }
        case 1:
          return '您的个人信息不全，请补全您的信息！';
        case 2:
          return '您已申请过该活动，不能重复申请！';
        case 3:
          return '对不起，您今天的申请次数已达上限！';
        case 4:
          return '对不起，该活动的申请人数已达上限！';
        case 5:
          return '对不起，该活动已过期并停止申请！';
        case 6:
          return '您已申请过该时间段的活动，不能重复申请！';
        case 7:
          return '对不起，您不能申请该活动！';
        case 8:
          return '对不起，您不在该活动的范围内！';
        default:
          return '未知错误';
      }
    }
  }

  static int _fromHtml(String htmlPage) {
    var code = int.tryParse(htmlPage) ?? -1;
    return code;
  }
}
