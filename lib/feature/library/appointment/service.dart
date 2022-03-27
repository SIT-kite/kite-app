import 'package:intl/intl.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/library/appointment/dao.dart';
import 'package:kite/feature/library/appointment/entity.dart';
import 'package:kite/util/date_format.dart';

class AppointmentService extends AService implements AppointmentDao {
  static const _library = '/library';
  static const _application = '$_library/application';
  static const _notice = '$_library/notice';
  static const _status = '$_library/status';

  AppointmentService(ASession session) : super(session);

  @override
  Future<ApplyResponse> apply(int period) async {
    final response = await session.post(
      _application,
      data: {'period': period},
    );
    return ApplyResponse.fromJson(response.data);
  }

  @override
  Future<void> cancelApplication(int applyId) async {
    await session.delete('$_application/$applyId');
  }

  @override
  Future<List<ApplicationRecord>> getApplication({
    int? period,
    String? username,
    DateTime? date,
  }) async {
    Map<String, String> queryParameters = {};
    if (period != null) {
      queryParameters = {'period': period.toString()};
    }
    if (username != null) {
      queryParameters = {'user': username};
    }
    if (date != null) {
      queryParameters['date'] = DateFormat('yyyyMMdd').format(date);
    }
    final response = await session.get('$_application/', queryParameters: queryParameters);
    List raw = response.data;
    return raw.map((e) => ApplicationRecord.fromJson(e)).toList();
  }

  @override
  Future<String> getApplicationCode(int applyId) async {
    final response = await session.get('$_application/$applyId/code');
    return response.data;
  }

  @override
  Future<Notice?> getNotice() async {
    final response = await session.get(_notice);
    return Notice.fromJson(response.data);
  }

  @override
  Future<List<PeriodStatusRecord>> getPeriodStatus(DateTime dateTime) async {
    final response = await session.get('$_status/${dateTime.yyyyMMdd}/');
    List raw = response.data;
    return raw.map((e) => PeriodStatusRecord.fromJson(e)).toList();
  }

  @override
  Future<void> updateApplication(int applyId, int status) async {
    await session.patch('$_application/$applyId', data: {'status': status});
  }

  @override
  Future<CurrentPeriodResponse> getCurrentPeriod() async {
    final response = await session.get('$_library/current');
    return CurrentPeriodResponse.fromJson(response.data);
  }

  @override
  Future<String> getRsaPublicKey() async {
    final response = await session.get('$_library/publicKey');
    return response.data;
  }
}
