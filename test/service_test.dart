import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await loginKite();
  final service = LibraryAppointmentInitializer.appointmentService;

  test('apply', () async {
    int period = 2203262;
    final result = await service.apply(period);
    Log.info(result);
  });
  test('cancelApplication', () async {
    await service.cancelApplication(2203261);
  });
  test('getApplication', () async {
    // 获取自己的所有申请
    final application = await service.getApplication(username: username);
    Log.info(application);
  });
  test('getApplicationCode', () async {
    int applyId = 2203262;
    final code = await service.getApplicationCode(applyId);
    Log.info(code);
  });
  test('getNotice', () async {
    final notice = await service.getNotice();
    Log.info(notice);
  });
  test('getPeriodStatus', () async {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final status = await service.getPeriodStatus(today);
    Log.info('今日时间: $status');
    final status1 = await service.getPeriodStatus(tomorrow);
    Log.info('明日时间: $status1');
  });
  test('updateApplication', () async {
    int applyId = 2203262;
    int status = 0;
    await service.updateApplication(applyId, status);
  });
}
