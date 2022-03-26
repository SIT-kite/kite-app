import 'entity.dart';

abstract class AppointmentDao {
  /// 获取图书馆公告
  /// 返回一个 html 文档
  Future<Notice> getNotice();

  /// 查询图书馆某日场次和剩余座位情况
  Future<List<PeriodStatusRecord>> getPeriodStatus(DateTime dateTime);

  /// 查询自己的所有预约记录
  Future<List<ApplicationRecord>> getApplication({int? period, String? username, DateTime? date});

  /// 查询预约凭证
  Future<String> getApplicationCode(int applyId);

  /// 获取RSA加密公钥
  Future<String> getRsaPublicKey();

  /// 申请座位
  /// 返回applyId
  Future<ApplyResponse> apply(int period);

  /// 更新预约状态
  Future<void> updateApplication(int applyId, int status);

  /// 取消预约状态
  Future<void> cancelApplication(int applyId);

  /// 获取当前开放场次
  Future<CurrentPeriodResponse?> getCurrentPeriod();
}
