import 'package:kite/feature/expense/service/expense.dart';
import 'package:kite/global/global.dart';

import 'mock_util.dart';

void main() async {
  await init();
  await login();
  var session = Global.ssoSession;
  test('expense test', () async {
    final expense = await ExpenseRemoteService(session).getExpensePage(1, start: DateTime(2010), end: DateTime.now());
    Log.info(expense);
  });
}
