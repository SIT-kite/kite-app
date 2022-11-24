import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/module/expense2/cache/cache.dart';
import 'package:kite/module/expense2/service/getter.dart';
import 'package:kite/module/expense2/storage/local.dart';
import 'package:kite/network/session.dart';
import 'package:kite/session/dio_common.dart';

class MySession extends DefaultDioSession {
  MySession(super.dio);
  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    print('Request: $para');
    return super.request(
      url,
      method,
      para: para,
      data: data,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

void main() async {
  await Hive.initFlutter('kite_test');

  final session = MySession(Dio());
  final box = await Hive.openBox('expense2');
  final storage = ExpenseStorage(box);
  final service = ExpenseGetService(session);
  final cached = CachedExpenseGetDao(remoteDao: service, storage: storage);

  test('as', () async {
    storage.getTransactionTsByRange().map((e) => storage.getTransactionByTs(e)!).forEach(print);
  });

  test('expense_tracker2 test', () async {
    final sw = Stopwatch()..start();
    final from = DateTime(2010);
    final to = DateTime.now();
    await cached.fetch(
      studentID: '1910400401',
      from: from,
      to: to,
    );
    sw.stop();
    Log.info('第一次获取数据用时：${sw.elapsedMilliseconds}');

    sw
      ..reset()
      ..start();
    await cached.fetch(
      studentID: '1910400401',
      from: from,
      to: to,
    );
    sw.stop();
    Log.info('第二次获取数据用时：${sw.elapsedMilliseconds}');
  });
}
