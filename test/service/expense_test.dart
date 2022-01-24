import 'package:kite/service/expense.dart';

import 'mock.dart';

void main() async {
  await init();
  await login();
  var session = SessionPool.ssoSession;
  test('expense test', () async {
    final expense = await ExpenseRemoteService(session).getExpensePage(true, 1);
    Log.info(expense);
  });
}
