import 'package:flutter_test/flutter_test.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/expense.dart';
import 'package:logger/logger.dart';

void main() async {
  var logger = Logger();

  await StoragePool.init();
  await SessionPool.init();
  test('expense test', () async {
    var username = '';
    var password = '';
    var session = SessionPool.ssoSession;
    await session.login(username, password);
    final expense = await ExpenseRemoteService(session).getExpensePage(1);
    logger.i(expense);
  });
}
