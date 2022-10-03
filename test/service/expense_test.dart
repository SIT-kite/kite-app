import 'package:kite/module/expense/service/expense.dart';
import 'package:kite/global/global.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  var session = Global.ssoSession;
  test('expense test', () async {
    final expense = await ExpenseRemoteService(session).getExpensePage(1, start: DateTime(2010), end: DateTime.now());
    Log.info(expense);
  });
}
