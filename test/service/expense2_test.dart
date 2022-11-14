import 'package:kite/global/global.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/module/expense2/service/getter.dart';

void main() async {
  await init(debugNetwork: true);
  // await login();
  var session = Global.ssoSession;
  test('expense_tracker2 test', () async {
    final expense = await ExpenseGetService(session).get('1910400401', from: DateTime(2010), to: DateTime.now());
    Log.info(expense);
  });
}
