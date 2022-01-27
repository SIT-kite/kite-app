import 'package:kite/service/expense.dart';

import 'mock_util.dart';

void main() async {
  await init();
  await login();
  var session = SessionPool.ssoSession;
  test('expense test', () async {
    final expense = await ExpenseRemoteService(session).getExpensePage(1);
    Log.info(expense);
  });
}
