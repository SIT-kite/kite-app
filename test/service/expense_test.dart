import 'package:kite/service/expense.dart';

import 'mock.dart';

void main() async {
  await init();
  await login();
  var session = SessionPool.ssoSession;
  test('expense test', () async {
    await session.login(username, password);
    final expense = await ExpenseRemoteService(session).getExpensePage(1);
    Log.info(expense);
  });
}
